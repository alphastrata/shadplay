#import bevy_sprite::mesh2d_view_bindings::globals
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

// Shader constants
const MAX_MARCHING_STEPS: i32 = 80;
const CAMERA_BACKWARD_OFFSET: f32 = 5.0;
const RING_RADIUS: f32 = 3.0;
const RING_DISTANCE_WEIGHT: f32 = 0.05;
const TURBULENCE_Y_WEIGHT: f32 = 0.04;
const TONEMAP_SCALE: f32 = 1e4;
const PALETTE_CHANGE_INTERVAL: f32 = 5.0; // Change palette every 5 seconds

// Color palettes
const PALETTES: array<array<vec3<f32>, 3>, 4> = array<array<vec3<f32>, 3>, 4>(
// Purple/Pink (original style)
array<vec3<f32>, 3>(vec3<f32>(0.8, 0.1, 0.8), vec3<f32>(1.0, 0.3, 0.6), vec3<f32>(0.5, 0.1, 1.0)),
// Green/Orange
array<vec3<f32>, 3>(vec3<f32>(0.1, 0.8, 0.1), vec3<f32>(0.8, 0.5, 0.1), vec3<f32>(0.9, 0.9, 0.2)),
// Gold/Blue
array<vec3<f32>, 3>(vec3<f32>(0.9, 0.7, 0.1), vec3<f32>(0.1, 0.5, 0.9), vec3<f32>(0.9, 0.9, 0.3)),
// Cyan/Magenta
array<vec3<f32>, 3>(vec3<f32>(0.1, 0.9, 0.9), vec3<f32>(0.9, 0.1, 0.5), vec3<f32>(0.3, 0.9, 0.9)));

fn get_current_palette(time: f32) -> array<vec3<f32>, 3> {
    let palette_index = i32(floor(time / PALETTE_CHANGE_INTERVAL)) % 4;
    return PALETTES[palette_index];
}

fn distance_field(p: vec3<f32>, time: f32, ray_depth: f32) -> f32 {
    // Rotation axis based on time and depth
    var rotation_axis = normalize(cos(vec3<f32>(4.0, 2.0, 0.0) + time - ray_depth * 8.0));

    // Apply rotation using Rodrigues' formula
    rotation_axis = rotation_axis * dot(rotation_axis, p) - cross(rotation_axis, p);

    // Turbulence effect via iterative noise-like perturbation
    var turbulence: vec3<f32> = rotation_axis;
    for (var octave: i32 = 2; octave < 9; octave += 1) {
        let octave_f = f32(octave);
        turbulence += sin(turbulence * octave_f + time).yzx / octave_f;
    }

    // Distance field: rings with turbulence affecting vertical component
    return RING_DISTANCE_WEIGHT * abs(length(p) - RING_RADIUS)
        + TURBULENCE_Y_WEIGHT * abs(turbulence.y);
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    var uv = in.uv;
    let resolution = view.viewport.zw;
    uv.x *= resolution.x / resolution.y; // Correct aspect ratio

    let time = globals.time;
    let palette = get_current_palette(time);

    // Initialise raymarch variables
    var ray_depth: f32 = 0.0;
    var step_distance: f32 = 0.0;
    var colour = vec4<f32>(0.0);

    // Raymarching loop
    for (var step_index: i32 = 0; step_index < MAX_MARCHING_STEPS; step_index += 1) {
        // Compute ray direction from uv and normalize
        let ray_direction = normalize(vec3<f32>(uv * 2.0, 0.0) - resolution.xyy / resolution.y);
        var point_on_ray = ray_depth * ray_direction;

        // Move camera back
        point_on_ray.z += CAMERA_BACKWARD_OFFSET;

        // Get distance field value
        step_distance = distance_field(point_on_ray, time, ray_depth);

        // Advance ray
        ray_depth += step_distance;

        // Get color weights using cosine waves
        let color_weights = cos(step_distance / 0.1 + vec3<f32>(0.0, 2.0, 4.0)) + 1.0;

        // Create color from palette
        let base_color = palette[0] * color_weights.x + palette[1] * color_weights.y + palette[2] * color_weights.z;

        // Accumulate color with falloff
        colour += vec4<f32>(base_color, 1.0) / (step_distance + 0.01) * ray_depth;
    }

    // Final tonemapping using hyperbolic tangent
    colour = tanh(colour / TONEMAP_SCALE);

    return colour;
}
