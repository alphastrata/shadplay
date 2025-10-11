//
// This is a port of 'Holographic Storage' by dthopper
// Source: https://www.shadertoy.com/view/fsffWH
//
// This shader demonstrates a raymarched scene with a complex, repeating
// structure. It uses temporal accumulation for anti-aliasing, creating a
// soft, volumetric look.
//

#import bevy_sprite::mesh2d_view_bindings::globals
#import bevy_sprite::mesh2d_vertex_output::VertexOutput
#import shadplay::shader_utils::common::{PI, SQRT_OF_3, pR, sdBoundingBox, hash22, calcLookAtMatrix}
#import bevy_render::view::View

@group(0) @binding(0) var<uniform> view: View;

/// Defines the data structure for our scene's geometry.
/// d: The signed distance to the surface.
/// col: The color of the surface at this point.
/// id: An identifier for the object hit.
struct Model {
    d: f32,
    col: vec3<f32>,
    id: i32,
};

// A private global variable to hold the current time fraction for animation.
var<private> t: f32;


@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    // Get screen coordinates for the current fragment.
    let fragCoord = in.uv * view.viewport.zw;
    
    // Set the global time for the animation, cycling every 4 seconds.
    t = fract(globals.time / 8.0);
    
    // --- Temporal Accumulation ---
    // To create a smoother, anti-aliased image, we render the scene multiple
    // times with slight variations and average the results. This is a common
    // technique in raymarching to reduce noise and aliasing.
    var col = vec4<f32>(0.0);
    let num_samples = 4; // Number of samples to average.
    
    // Approximate a frame count from the continuous time uniform. This is
    // used to seed the random jitter for each sample.
    let frame_approx = i32(globals.time * 60.0);

    for (var i = 0; i < num_samples; i = i + 1) {
        // Each call to draw() gets a slightly different seed, creating the jitter.
        col += vec4<f32>(draw(fragCoord, frame_approx * num_samples + i), 1.0);
    }

    // Average the accumulated colors.
    col /= f32(num_samples);

    return col;
}


// =============================================================================
// Scene Rendering
// =============================================================================

/// Sets up the camera and performs the raymarching process.
/// fragCoord: The screen coordinate for the current pixel.
/// frame: The current frame number, used for seeding temporal effects.
fn draw(fragCoord: vec2<f32>, frame: i32) -> vec3<f32> {
    let resolution = view.viewport.zw;
    // Normalise coordinates and account for aspect ratio.
    var p = (-resolution.xy + 2.0 * fragCoord.xy) / resolution.y;
        
    // --- Jittering for Anti-Aliasing ---
    // A random seed is generated for each sample to jitter the ray direction slightly.
    // This helps smooth out hard edges when averaged in the fragment shader.
    var seed = hash22(fragCoord + f32(frame) * SQRT_OF_3);
    p += 2.0 * (seed - vec2(0.5)) / resolution.xy;

    // --- Camera Setup ---
    var camPos = vec3<f32>(0.0, 0.0, 8.0);
    
    // Rotate the camera position.
    var temp_yz = camPos.yz;
    pR(&temp_yz, PI * 0.2);
    camPos.y = temp_yz.x;
    camPos.z = temp_yz.y;

    var temp_xz = camPos.xz;
    pR(&temp_xz, PI * 0.25);
    camPos.x = temp_xz.x;
    camPos.z = temp_xz.y;

    // Create the camera's view matrix.
    let camMat = calcLookAtMatrix(camPos, vec3<f32>(0.0), vec3<f32>(0.0, 1.0, 0.0));
    
    // --- Raymarching ---
    let focalLength = 100.0;
    camPos *= focalLength / 1.0; // You can effectively use this to zoom in/out
    let rayDir = normalize(camMat * vec3<f32>(p.xy, focalLength));
    let origin = camPos;
    
    var col = vec3<f32>(0.0);
    var rayLength = 0.0;
    let maxlen = 10.0 * focalLength;
    let iter = 200;
    let eps = 0.00004;
    
    for (var i = 0; i < iter; i++) {
        let rayPosition = origin + rayDir * rayLength;
        let model = map(rayPosition);
        
        let d = max(eps, abs(model.d));
        // Advance the ray. The random seed adds a bit of dithering to the step.
        rayLength += d * (1.0 - seed.x * 0.125);
        
        // Re-seed for the next step.
        seed = hash22(seed);
 
        if (rayLength > maxlen) {
            break;
        }
        
        // Accumulate color based on the distance field.
        col += model.col / pow(d, 0.125) * 0.002;
    }

    return col;
}


// =============================================================================
// Scene Definition (SDF)
// =============================================================================

/// Defines the 3D scene using a Signed Distance Function (SDF).
/// This function returns the shortest distance from a point `p` to any surface
/// in the scene. The sign of the distance indicates whether the point is
/// inside or outside an object.
fn map(p_in: vec3<f32>) -> Model {
    var p = p_in;
    let col_in = normalize(p) * 0.5 + 0.5;
    var col = col_in;

    // --- Domain Warping ---
    // The position `p` is displaced using sine waves and smoothstep functions.
    // This creates the complex, organic-looking distortions in the geometry.
    p -= sin(p.y * 15.0 + t * PI * 2.0 * 3.0) * 0.05;

    let ps = p * mix(50.0, 100.0, smoothstep(-1.0, 1.0, p.y));
    p += (sin(ps.x) + sin(ps.z) + sin(ps.y)) * 0.02 * smoothstep(-1.0, 1.0, p.y);

    p += sin(p.y * 10.0 + t * PI * 2.0 * 3.0) * 0.05;
    p += sin(p * 8.0 + t * PI * 2.0) * 0.1;
    
    // --- Domain Repetition ---
    // The space is tiled by repeatedly clamping the coordinates, which creates
    // the repeating lattice structure.
    let r = 1.0;
    p -= r * 0.5;
    let o = floor(p / r + 0.5);
    // let o_clamped = clamp(o, vec3<f32>(-1.0, -2.0, -1.0), vec3<f32>(0.0, 1.0, 0.0));
    // p -= o_clamped * r;

    // Tile in a larger bounded region
    let o_clamped = clamp(o, vec3<f32>(-2.0, -2.0, -2.0), vec3<f32>(2.0, 2.0, 2.0));
    p -= o_clamped * r;
    
    col = mix(col, normalize(p) * 0.5 + 0.5, 0.5);

    // The final shape is a bounding box.
    let d = sdBoundingBox(p, vec3<f32>(0.3), 0.5);
    return Model(d, col, 1);
}
