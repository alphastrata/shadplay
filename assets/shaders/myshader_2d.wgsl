#import bevy_sprite::mesh2d_view_bindings::globals
#import shadplay::shader_utils::common::{rotate2D, NEG_HALF_PI}
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

const MAX_MARCHING_STEPS: i32 = 40;
const CAMERA_BACKWARD_OFFSET: f32 = 2.0;
const RING_RADIUS: f32 = 0.9;
const RING_DISTANCE_WEIGHT: f32 = 0.05; // forces the turbulence to be 'closer' to the ring
const TURBULENCE_Y_WEIGHT: f32 = 0.08; // Higher values == more spherical
const TONEMAP_SCALE: f32 = 1e4; // Make it brighter/darker

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    var uv = in.uv;
    let resolution = view.viewport.zw;
    uv.x *= resolution.x / resolution.y; // Correct aspect ratio

    let time = globals.time;

    // Initialise raymarch variables
    var ray_depth: f32 = 0.0;
    var step_distance: f32 = 0.0;
    var colour = vec4<f32>(0.0);

    // Raymarching loop
    for (var step_index: i32 = 0; step_index < MAX_MARCHING_STEPS; step_index += 1) {
        // Compute ray direction from uv and normalise
        let ray_direction = normalize(vec3<f32>(uv * 2.0, 0.0) - resolution.xyy / resolution.y);
        var point_on_ray = ray_depth * ray_direction;

        // Rotation axis based on time and depth
        var rotation_axis = normalize(cos(vec3<f32>(4.0, 2.0, 0.0) + time - ray_depth * 8.0));

        // Move camera back
        point_on_ray.z += CAMERA_BACKWARD_OFFSET;

        // Apply rotation using Rodrigues' formula: a * dot(a,p) - cross(a,p)
        rotation_axis = rotation_axis * dot(rotation_axis, point_on_ray) - cross(rotation_axis, point_on_ray);

        // Turbulence effect via iterative noise-like perturbation
        var turbulence: vec3<f32> = rotation_axis;
        for (var octave: i32 = 2; octave < 9; octave += 1) {
            let octave_f = f32(octave);
            turbulence += sin(turbulence * octave_f + time).yzx / octave_f;
        }

        // Distance field: rings with turbulence affecting vertical component
        step_distance = RING_DISTANCE_WEIGHT * abs(length(point_on_ray) - RING_RADIUS)
            + TURBULENCE_Y_WEIGHT * abs(turbulence.y);

        // Advance ray
        ray_depth += step_distance;

        // Accumulate colour with frequency-based oscillation
        colour += (cos(step_distance / 0.1 + vec4<f32>(0.0, 2.0, 4.0, 0.0)) + 1.0)
            / (step_distance + 0.01) // Avoid division by zero
        * ray_depth;
    }

    // Final tonemapping using hyperbolic tangent
    colour = tanh(colour / TONEMAP_SCALE);

    return colour;
}
