//
// Configurable Holographic Storage Shader
// Based on 'Holographic Storage' by dthopper
// Source: https://www.shadertoy.com/view/fsffWH
//
// OVERVIEW:
// This shader uses raymarching to render a volumetric, repeating lattice structure.
// The scene consists of tower-like structures arranged in a 3D grid, with organic
// distortions created through domain warping (position displacement using sine waves).
//
// WHAT IS RAYMARCHING?
// Instead of traditional polygon rendering, we cast rays from the camera and step
// along each ray, checking the distance to the nearest surface at each step. When
// we get close enough to a surface, we accumulate color based on proximity.
//
// VISUAL EFFECT:
// The result is a glowing, volumetric lattice that appears to have depth and
// translucency, with each tower pulsating and warping over time.
//

#import bevy_sprite::mesh2d_view_bindings::globals
#import bevy_sprite::mesh2d_vertex_output::VertexOutput
#import shadplay::shader_utils::common PI, SQRT_OF_3, pR, sdBoundingBox, hash22, calcLookAtMatrix
#import bevy_render::view::View

@group(0) @binding(0) var<uniform> view: View;

// =============================================================================
// CONFIGURATION GLOBALS
// =============================================================================
// These constants control the appearance and layout of the scene.
// Adjust these to customize the shader without diving into the implementation.

/// Number of tower cells in the X direction (columns)
const GRID_COLS: f32 = 3.0;

/// Number of tower cells in the Y direction (rows/vertical)
const GRID_ROWS: f32 = 4.0;

/// Number of tower cells in the Z direction (depth)
const GRID_DEPTH: f32 = 3.0;

/// Camera zoom factor. Higher = closer view. (Effectively adjusts focal length ratio)
const CAMERA_ZOOM: f32 = 1.0;

/// Distance of camera from scene origin
const CAMERA_DISTANCE: f32 = 8.0;

/// Camera rotation around Y axis (horizontal spin) in radians
const CAMERA_ROTATION_Y: f32 = PI * 0.25;

/// Camera rotation around X axis (vertical tilt) in radians
const CAMERA_ROTATION_X: f32 = PI * 0.2;

/// Size of each tower cell in world space
const CELL_SIZE: f32 = 1.0;

/// Animation cycle duration in seconds
const ANIMATION_PERIOD: f32 = 8.0;

/// Number of temporal AA samples per pixel (higher = smoother but slower)
const AA_SAMPLES: i32 = 4;

/// Maximum raymarch distance multiplier
const MAX_RAYMARCH_DISTANCE: f32 = 10.0;

/// Number of raymarch iterations
const RAYMARCH_ITERATIONS: i32 = 200;

/// Color accumulation factor (controls brightness/glow intensity)
const COLOR_ACCUMULATION: f32 = 0.002;

/// Minimum step size epsilon (prevents overshooting surfaces)
const RAYMARCH_EPSILON: f32 = 0.00004;

// =============================================================================
// DATA STRUCTURES
// =============================================================================

/// Represents the result of sampling the scene's distance field.
/// 
/// d: Signed distance to nearest surface (negative = inside, positive = outside)
/// col: Color at this point in space
/// id: Object identifier (for potential future use with multiple object types)
struct Model {
    d: f32,
    col: vec3<f32>,
    id: i32,
};

// =============================================================================
// PRIVATE STATE
// =============================================================================

/// Current animation time fraction [0, 1), cycles every ANIMATION_PERIOD seconds
var<private> t: f32;

// =============================================================================
// MAIN FRAGMENT SHADER
// =============================================================================

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let fragCoord = in.uv * view.viewport.zw;
    
    // Normalize time to [0, 1) range for smooth animation cycling
    t = fract(globals.time / ANIMATION_PERIOD);
    
    // --- TEMPORAL ANTI-ALIASING ---
    // We render the scene multiple times with slight random offsets (jitter)
    // and average the results. This technique reduces aliasing artifacts
    // (jagged edges) by distributing samples across pixel boundaries.
    //
    // WHY THIS WORKS:
    // Single samples can only say "hit" or "miss" for an edge passing through
    // a pixel. Multiple jittered samples give us partial coverage information,
    // creating smooth gradients at edges when averaged.
    
    var col = vec4<f32>(0.0);
    let frame_approx = i32(globals.time * 60.0);

    for (var i = 0; i < AA_SAMPLES; i = i + 1) {
        // Each sample gets a unique seed for different jitter
        col += vec4<f32>(draw(fragCoord, frame_approx * AA_SAMPLES + i), 1.0);
    }

    col /= f32(AA_SAMPLES);
    return col;
}

// =============================================================================
// SCENE RENDERING
// =============================================================================

/// Renders a single sample of the scene from the camera's perspective.
///
/// PROCESS:
/// 1. Setup camera position and orientation
/// 2. Calculate ray direction through this pixel
/// 3. March the ray through the scene, accumulating color
/// 4. Return the final accumulated color
///
/// fragCoord: Screen-space coordinate of the pixel
/// frame: Frame counter for temporal jittering
fn draw(fragCoord: vec2<f32>, frame: i32) -> vec3<f32> {
    let resolution = view.viewport.zw;
    
    // Convert to normalized device coordinates [-1, 1], corrected for aspect ratio
    var p = (-resolution.xy + 2.0 * fragCoord.xy) / resolution.y;
        
    // --- ANTI-ALIASING JITTER ---
    // Add random sub-pixel offset to this sample. Over multiple samples,
    // this creates smooth anti-aliased edges.
    var seed = hash22(fragCoord + f32(frame) * SQRT_OF_3);
    p += 2.0 * (seed - vec2(0.5)) / resolution.xy;

    // --- CAMERA SETUP ---
    var camPos = vec3<f32>(0.0, 0.0, CAMERA_DISTANCE);
    
    // Apply camera rotations
    var temp_yz = camPos.yz;
    pR(&temp_yz, CAMERA_ROTATION_X);
    camPos.y = temp_yz.x;
    camPos.z = temp_yz.y;

    var temp_xz = camPos.xz;
    pR(&temp_xz, CAMERA_ROTATION_Y);
    camPos.x = temp_xz.x;
    camPos.z = temp_xz.y;

    // Create view matrix for camera orientation
    let camMat = calcLookAtMatrix(camPos, vec3<f32>(0.0), vec3<f32>(0.0, 1.0, 0.0));
    
    // --- RAY SETUP ---
    let focalLength = 100.0;
    camPos *= focalLength / CAMERA_ZOOM; // Apply zoom by scaling camera distance
    let rayDir = normalize(camMat * vec3<f32>(p.xy, focalLength));
    let origin = camPos;
    
    // --- RAYMARCHING LOOP ---
    // We step along the ray, accumulating color based on proximity to surfaces.
    // This creates the volumetric, glowing effect.
    //
    // TECHNIQUE:
    // - Query distance field at current position
    // - Step forward by that distance (we know we won't hit anything closer)
    // - Accumulate color inversely proportional to distance (closer = brighter)
    // - Repeat until we've traveled too far or hit max iterations
    
    var col = vec3<f32>(0.0);
    var rayLength = 0.0;
    let maxlen = MAX_RAYMARCH_DISTANCE * focalLength;
    
    for (var i = 0; i < RAYMARCH_ITERATIONS; i++) {
        let rayPosition = origin + rayDir * rayLength;
        let model = map(rayPosition);
        
        let d = max(RAYMARCH_EPSILON, abs(model.d));
        
        // Advance ray with slight random dithering to break up banding artifacts
        rayLength += d * (1.0 - seed.x * 0.125);
        seed = hash22(seed); // Re-seed for next iteration
 
        if (rayLength > maxlen) {
            break;
        }
        
        // Accumulate color: closer to surface = brighter contribution
        // The pow(d, 0.125) creates a non-linear falloff for artistic effect
        col += model.col / pow(d, 0.125) * COLOR_ACCUMULATION;
    }

    return col;
}

// =============================================================================
// SCENE DEFINITION (SIGNED DISTANCE FIELD)
// =============================================================================

/// Defines the geometry and appearance of the 3D scene.
///
/// SIGNED DISTANCE FIELDS (SDF):
/// Instead of defining surfaces with polygons, we define a function that
/// returns the distance to the nearest surface at any point in space.
/// - Positive values: outside objects
/// - Negative values: inside objects
/// - Zero: exactly on the surface
///
/// DOMAIN OPERATIONS:
/// We manipulate the input position `p` before evaluating the base shape.
/// This creates complex, organic forms from simple primitives.
///
/// p_in: Position in 3D space to evaluate
/// Returns: Model struct with distance, color, and ID
fn map(p_in: vec3<f32>) -> Model {
    var p = p_in;
    
    // Base color derived from position (creates rainbow-like coloring)
    let col_in = normalize(p) * 0.5 + 0.5;
    var col = col_in;

    // --- DOMAIN WARPING: Creating Organic Motion ---
    // Each displacement layer adds visual complexity and animation.
    // Think of these as "bending space" before we measure distances.
    
    // LAYER 1: Low frequency vertical waves
    // Creates slow, large-scale undulation
    p -= sin(p.y * 15.0 + t * PI * 2.0 * 3.0) * 0.05;

    // LAYER 2: High frequency noise based on Y position
    // Adds fine surface detail that increases toward edges
    let highFreqPos = p * mix(50.0, 100.0, smoothstep(-1.0, 1.0, p.y));
    p += (sin(highFreqPos.x) + sin(highFreqPos.z) + sin(highFreqPos.y)) 
         * 0.02 * smoothstep(-1.0, 1.0, p.y);

    // LAYER 3: Medium frequency vertical waves (phase-shifted from layer 1)
    p += sin(p.y * 10.0 + t * PI * 2.0 * 3.0) * 0.05;
    
    // LAYER 4: Animated 3D noise
    // Creates time-varying turbulence throughout the space
    p += sin(p * 8.0 + t * PI * 2.0) * 0.1;
    
    // --- DOMAIN REPETITION: Creating the Grid ---
    // We tile space into a repeating grid of cells, but bound it to a finite region.
    
    p -= CELL_SIZE * 0.5; // Center the cells
    let cellIndex = floor(p / CELL_SIZE + 0.5); // Which cell are we in?
    
    // Calculate grid bounds based on configuration
    let gridMin = vec3<f32>(-GRID_COLS * 0.5, -GRID_ROWS * 0.5, -GRID_DEPTH * 0.5);
    let gridMax = vec3<f32>(GRID_COLS * 0.5, GRID_ROWS * 0.5, GRID_DEPTH * 0.5);
    
    // Clamp to bounded region (creates finite grid instead of infinite tiling)
    let boundedCellIndex = clamp(cellIndex, gridMin, gridMax);
    p -= boundedCellIndex * CELL_SIZE; // Fold space into cell
    
    // Blend position-based coloring with cell-based coloring
    col = mix(col, normalize(p) * 0.5 + 0.5, 0.5);

    // --- BASE GEOMETRY ---
    // Each cell contains a rounded box (tower structure)
    let d = sdBoundingBox(p, vec3<f32>(0.3), 0.5);
    
    return Model(d, col, 1);
}
