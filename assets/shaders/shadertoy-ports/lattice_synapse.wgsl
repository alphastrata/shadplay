//
// Port of 'Lattice Synapse' by baxin1919
// source: https://www.shadertoy.com/view/W3yXWy
//

#import bevy_sprite::mesh2d_view_bindings::globals
#import bevy_sprite::mesh2d_vertex_output::VertexOutput
#import bevy_render::view::View
#import shadplay::shader_utils::common::{sd_sphere, sdBox, rotate2D, calcLookAtMatrix}

@group(0) @binding(0) var<uniform> view: View;

const CUBE_SIZE: i32 = 8;
const LED_RADIUS: f32 = 0.05;
const GRID_SPACING: f32 = 0.35;
const LED_COLOR: vec3<f32> = vec3<f32>(1.0);


/// GLSL-style modulo function to ensure correct behavior with negative coordinates.
fn mod_glsl(x: vec3<f32>, y: f32) -> vec3<f32> {
    return x - y * floor(x / y);
}

/// The main distance function for the scene.
fn map(p_in: vec3<f32>) -> f32 {
    var p_local = p_in;
    let angle = globals.time * 0.25;
    
    // To rotate the object on its own axis, we apply the inverse rotation
    // to the incoming ray position. This transforms the world-space point
    // into the object's local, un-rotated space.
    let rotMatrix = rotate2D(angle); // Use counter-clockwise for inverse
    
    let new_xz = rotMatrix * p_local.xz;
    p_local.x = new_xz.x;
    p_local.z = new_xz.y;

    // Now that we are in the object's local space, we define all geometry.
    
    // 1. The repeating grid of spheres.
    // We use a GLSL-style mod function to ensure the grid is centered correctly
    // even when coordinates are negative during rotation.
    let q = mod_glsl(p_local, GRID_SPACING) - GRID_SPACING * 0.5;
    let spheresDist = sd_sphere(q, LED_RADIUS);

    // 2. The bounding box that contains the spheres.
    let cubeHalfSize = f32(CUBE_SIZE) * GRID_SPACING * 0.5;
    let boxDist = sdBox(p_local, vec3<f32>(cubeHalfSize));

    // 3. The final geometry is the intersection of the spheres and the box.
    return max(spheresDist, boxDist);
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let R = view.viewport.zw;
    var uv = (in.uv * R * 2.0 - R) / R.y;
    uv.y *= -1.0; // Invert Y-axis to match OpenGL coordinate system

    let time = globals.time * 0.2;
    // Define camera position (ray origin).
    let ro = vec3<f32>(1.0, 2.5, 4.0);
  
    // Set up camera using the look-at matrix helper from common.wgsl
    let look_at_target = vec3<f32>(0.0);
    let up = vec3<f32>(0.0, 1.0, 0.0);
    let fov = 1.5;
    let camMat = calcLookAtMatrix(ro, look_at_target, up);
    let rd = normalize(camMat * vec3<f32>(uv, fov));

    var t = 0.0;
    var col = vec3<f32>(0.0);

    // Raymarch loop.
    for (var i = 0; i < 100; i = i + 1) {
        let p = ro + rd * t;
        let d = map(p);

        if (d < 0.001) {
            // Hit a sphere, calculate color.
            let scanWave = sin(p.y * 2.0 - globals.time * 3.0);
            let line = smoothstep(0.9, 0.95, scanWave);
            let lineColor = vec3<f32>(0.25, 1.0, 0.3);
            
            let finalColor = mix(LED_COLOR * 0.5, lineColor, line);
            
            // Apply fog based on distance.
            col = finalColor * exp(-0.15 * t);
            
            break;
        }

        t += d;

        if (t > 20.0) {
            break;
        }
    }

    col = max(col, vec3<f32>(0.0, 0.0, 0.0) + uv.y * 0.05);

    // Apply gamma correction.
    col = pow(col, vec3<f32>(0.4545));
    return vec4<f32>(col, 1.0);
}
