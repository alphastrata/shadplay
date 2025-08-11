// Port of "Ionize" by @XorDev - https://www.shadertoy.com/view/wfc3z7
// Original tweet: https://twitter.com/XorDev/status/1921224922166104360

// ------ CONFIGURATION PARAMETERS ------
const SPEED: f32 = 1.0; // Animation speed multiplier
const ZOOM_LEVEL: f32 = 1.0; // Overall zoom level (0.1-1.0)
const MAX_RAYMARCH_STEPS: u32 = 100; // Quality/performance tradeoff
const INITIAL_CAMERA_DISTANCE: f32 = 9.0; // Camera Z position
const GLOW_INTENSITY: f32 = 2e3; // Glow/tonemapping intensity
const GYROID_SCALE: f32 = 0.7; // Gyroid pattern scale
const TURBULENCE_ITERATIONS: f32 = 9.0; // Distortion complexity
const SPHERE_BOUNDARY: f32 = 6.0; // Scene bounding sphere size

// ------ IMPORTS ------
#import bevy_sprite::mesh2d_view_bindings::globals
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

@fragment
fn fragment(in_fragment: VertexOutput) -> @location(0) vec4<f32> {
    // Setup UV coordinates (centered, aspect-corrected)
    var uv = (in_fragment.uv - 0.5) * 2.0;
    uv *= ZOOM_LEVEL;
    uv.x *= view.viewport.z / view.viewport.w;

    let time = globals.time * SPEED;
    var colour = vec4f(0.0);
    var ray_depth = 0.0;

    // Raymarching loop
    for (var i: u32 = 0u; i < MAX_RAYMARCH_STEPS; i++) {
        // Calculate sample point
        let sample_point = ray_depth * normalize(vec3f(uv, 1.0)) + vec3f(0.0, 0.0, -INITIAL_CAMERA_DISTANCE);

        // Apply turbulence distortion
        var distorted_point = sample_point;
        var distortion = 1.0;
        while (distortion < TURBULENCE_ITERATIONS) {
            distorted_point += 0.5 * sin(distorted_point.yzx * distortion + time) / distortion;
            distortion += distortion;
        }

        // Calculate gyroid distance field
        let gyroid = dot(cos(distorted_point), sin(distorted_point / GYROID_SCALE).yzx);
        let distance = 0.2 * (0.01 + abs(gyroid) - min(SPHERE_BOUNDARY - length(sample_point), -(SPHERE_BOUNDARY - length(sample_point)) * 0.1));

        ray_depth += distance;

        // Colour calculation
        let phase = gyroid / 0.1 + ray_depth + time;
        colour += (cos(phase + vec4f(2.0, 4.0, 5.0, 0.0)) + 1.2) / distance / ray_depth;
    }

    // Tonemapping
    return tanh(colour / GLOW_INTENSITY);
}
