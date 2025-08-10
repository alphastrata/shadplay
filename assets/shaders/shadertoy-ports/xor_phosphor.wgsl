/*
    This is a port of "Phosphor" by @XorDev https://www.shadertoy.com/view/WXV3zt
*/

#import bevy_sprite::mesh2d_view_bindings::globals
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

/// Maximum steps for ray marching - higher values increase quality but reduce performance
const MAX_MARCHING_STEPS: i32 = 80;

/// How far back the camera is positioned - affects the apparent size of the effect
const CAMERA_BACKWARD_OFFSET: f32 = 5.0;

/// Base radius of the phosphor ring structure - larger values make the effect more expansive
const RING_RADIUS: f32 = 3.0;

/// Controls how strongly particles adhere to the ring shape - higher values make more distinct rings
const RING_DISTANCE_WEIGHT: f32 = 0.05;

/// Strength of the turbulent motion - higher values create more chaotic, sand-like movement
const TURBULENCE_Y_WEIGHT: f32 = 0.04;

/// Final brightness scaling - lower values make the overall effect brighter
const TONEMAP_SCALE: f32 = 1.6e3;

/// Animation speed multiplier - higher values make the particles move faster
const SPEED: f32 = 1.015;

/// Contrast boost applied at the end - higher values (1.5+) create more dramatic light/dark separation
const CONTRAST: f32 = 0.5;

/// Depth fade control - higher values make particles appear more gradually with distance
const DEPTH_FADE_END: f32 = 3.8;

/// Edge sharpness control - lower values create crisper particle edges (0.02-0.1 recommended)
const EDGE_SHARPNESS: f32 = 0.03;

/// Controls glow intensity - higher values make bright areas glow more
const GLOW_INTENSITY: f32 = 1.25;

/// Glow curve mixing amount (0.0-1.0)
const GLOW_MIX: f32 = 0.05;

/// Colour palette selector (0-3):
const PALETTE_INDEX: i32 = 0;

/// Distance field colour calculation divisor - affects colour cycling speed
const COLOUR_CYCLE_DIVISOR: f32 = 0.1;

/// Brightness calculation constants
const BRIGHTNESS_SCALE: f32 = 0.03;
const BRIGHTNESS_OFFSET: f32 = 0.025;

/// Rotation axis base vector
const ROTATION_BASE: vec3<f32> = vec3<f32>(2.0, 1.0, 0.0);

/// Distance feedback multiplier - affects tumbling intensity
const DISTANCE_FEEDBACK: f32 = 8.0;

/// Turbulence loop parameters
const TURBULENCE_START: i32 = 2;
const TURBULENCE_END: i32 = 9;

// Multiple colour palettes
const PALETTES: array<array<vec3<f32>, 3>, 4> = array<array<vec3<f32>, 3>, 4>(
// 0: Original purple/pink
array<vec3<f32>, 3>(vec3<f32>(0.8, 0.1, 0.8), // Vibrant purple
vec3<f32>(1.0, 0.3, 0.6), // Bright pink
vec3<f32>(0.5, 0.1, 1.0) // Deep violet
),
// 1: Green/orange
array<vec3<f32>, 3>(vec3<f32>(0.1, 0.8, 0.1), // Electric green
vec3<f32>(0.8, 0.5, 0.1), // Warm orange
vec3<f32>(0.9, 0.9, 0.2) // Sunny yellow
),
// 2: Gold/blue
array<vec3<f32>, 3>(vec3<f32>(0.9, 0.7, 0.1), // Rich gold
vec3<f32>(0.1, 0.5, 0.9), // Deep blue
vec3<f32>(0.9, 0.9, 0.3) // Light gold
),
// 3: Cyan/magenta
array<vec3<f32>, 3>(vec3<f32>(0.1, 0.9, 0.9), // Bright cyan
vec3<f32>(0.9, 0.1, 0.5), // Vibrant magenta
vec3<f32>(0.3, 0.9, 0.9) // Light cyan
));

fn get_palette() -> array<vec3<f32>, 3> {
    return PALETTES[PALETTE_INDEX % 4];
}

fn distance_field(p: vec3<f32>, time: f32, current_distance: f32) -> f32 {
    // Use current_distance in the rotation calculation like the original
    var a = normalize(cos(ROTATION_BASE + time - current_distance * DISTANCE_FEEDBACK));
    a = a * dot(a, p) - cross(a, p);

    var turbulence: vec3<f32> = a;
    // Turbulence loop with configurable parameters
    for (var d: i32 = TURBULENCE_START; d < TURBULENCE_END; d += 1) {
        turbulence += sin(turbulence * f32(d) + time).yzx / f32(d);
    }

    return RING_DISTANCE_WEIGHT * abs(length(p) - RING_RADIUS) + TURBULENCE_Y_WEIGHT * abs(turbulence.y);
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    var uv = in.uv;
    let resolution = view.viewport.zw;
    uv = uv * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;

    let time = globals.time * SPEED;
    let palette = get_palette();

    var z: f32 = 0.0;
    var d: f32 = 0.0;
    var frag_colour = vec4<f32>(0.0);

    for (var i: i32 = 0; i < MAX_MARCHING_STEPS; i += 1) {
        let ray_dir = normalize(vec3<f32>(uv, -1.0));
        var p = z * ray_dir;
        p.z += CAMERA_BACKWARD_OFFSET;

        // Pass current d value to create feedback loop
        d = distance_field(p, time, d);
        z += d;

        let colour_weights = cos(d / COLOUR_CYCLE_DIVISOR + vec3<f32>(0.0, 2.0, 4.0)) + 1.0;
        let base_colour = palette[0] * colour_weights.x + palette[1] * colour_weights.y + palette[2] * colour_weights.z;

        // Configurable contrast controls
        let falloff = smoothstep(0.0, DEPTH_FADE_END, z) * (1.0 - smoothstep(0.0, EDGE_SHARPNESS, d));
        frag_colour += vec4<f32>(base_colour, 1.0) * falloff / (d * BRIGHTNESS_SCALE + BRIGHTNESS_OFFSET) * z;
    }

    // Configurable tonemapping with contrast & glow
    frag_colour = tanh(frag_colour / TONEMAP_SCALE);
    frag_colour = pow(frag_colour, vec4<f32>(CONTRAST));
    frag_colour = mix(frag_colour, frag_colour * frag_colour, GLOW_MIX * GLOW_INTENSITY / 1.8);

    return frag_colour;
}
