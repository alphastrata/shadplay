//
// Port of "Water" shader from https://www.shadertoy.com/view/Ms2SD1
// Original by afl_ext (MIT License)
//

#import bevy_sprite::mesh2d_view_bindings::globals 
#import shadplay::shader_utils::common::{NEG_HALF_PI, shader_toy_default, rotate2D, TWO_PI}
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

// Constants
const DRAG_MULT: f32 = 0.38;       // How much waves pull on the water
const WATER_DEPTH: f32 = 1.0;      // Depth of the water
const CAMERA_HEIGHT: f32 = 1.5;     // Camera height above water
const ITERATIONS_RAYMARCH: i32 = 12; // Wave iterations for raymarching
const ITERATIONS_NORMAL: i32 = 36;   // Wave iterations for normal calculation
const PI: f32 = 3.141592653589793;

// Helper function: Creates a rotation matrix around an axis by given angle
fn create_rotation_matrix_axis_angle(axis: vec3f, angle: f32) -> mat3x3f {
    let s = sin(angle);
    let c = cos(angle);
    let oc = 1.0 - c;
    
    return mat3x3f(
        oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,
        oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,          oc * axis.y * axis.z - axis.x * s,
        oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s, oc * axis.z * axis.z + c
    );
}

// Calculates wave value and its derivative
fn wavedx(position: vec2f, direction: vec2f, frequency: f32, timeshift: f32) -> vec2f {
    let x = dot(direction, position) * frequency + timeshift;
    let wave = exp(sin(x) - 1.0);
    let dx = wave * cos(x);
    return vec2f(wave, -dx);
}

// Calculates waves by summing octaves
fn get_waves(i_position: vec2f, iterations: i32) -> f32 {
    let wave_phase_shift = length(i_position) * 0.1;
    var iter: f32 = 0.0;
    var frequency: f32 = 1.0;
    var time_multiplier: f32 = 2.0;
    var weight: f32 = 1.0;
    var sum_of_values: f32 = 0.0;
    var sum_of_weights: f32 = 0.0;
    
    for(var i: i32 = 0; i < iterations; i = i + 1) {
        // Generate wave direction that looks random
        let p = vec2f(sin(iter), cos(iter));
        
        // Calculate wave data
        let res = wavedx(i_position, p, frequency, globals.time * time_multiplier + wave_phase_shift);

        // Shift position according to wave drag and derivative
        let position = i_position + p * res.y * weight * DRAG_MULT;

        // Add to sums
        sum_of_values = sum_of_values + res.x * weight;
        sum_of_weights = sum_of_weights + weight;

        // Modify next octave
        weight = mix(weight, 0.0, 0.2);
        frequency = frequency * 1.18;
        time_multiplier = time_multiplier * 1.07;

        // Add random value to make next wave look different
        iter = iter + 1232.399963;
    }
    
    return sum_of_values / sum_of_weights;
}

// Raymarches the ray from top water layer to bottom
fn raymarch_water(camera_pos: vec3f, start: vec3f, end: vec3f, depth: f32) -> f32 {
    var pos: vec3f = start;
    let dir = normalize(end - start);
    
    for(var i: i32 = 0; i < 64; i = i + 1) {
        let height = get_waves(pos.xz, ITERATIONS_RAYMARCH) * depth - depth;
        
        // If waves height nearly matches ray height, assume hit
        if(height + 0.01 > pos.y) {
            return distance(pos, camera_pos);
        }
        
        // Iterate forward according to height mismatch
        pos = pos + dir * (pos.y - height);
    }
    
    // If no hit, assume top layer hit
    return distance(start, camera_pos);
}

// Calculate normal at point by sampling nearby points
fn calculate_normal(pos: vec2f, epsilon: f32, depth: f32) -> vec3f {
    let ex = vec2f(epsilon, 0.0);
    let H = get_waves(pos.xy, ITERATIONS_NORMAL) * depth;
    let a = vec3f(pos.x, H, pos.y);
    
    return normalize(
        cross(
            a - vec3f(pos.x - epsilon, get_waves(pos.xy - ex.xy, ITERATIONS_NORMAL) * depth, pos.y),
            a - vec3f(pos.x, get_waves(pos.xy + ex.yx, ITERATIONS_NORMAL) * depth, pos.y + epsilon)
        )
    );
}

// NOTE: the glsl's `y` is flipped.
fn get_ray(frag_coord: vec2f) -> vec3f {
    let viewport_size = view.viewport.zw;
    
    let uv = vec2f(
        frag_coord.x / viewport_size.x,
        1.0 - (frag_coord.y / viewport_size.y) // Flip Y coordinate from glsl
    );
    
    // Convert to clip space (-1 to 1) and account for aspect ratio
    let clip = (uv * 2.0 - 1.0) * vec2f(viewport_size.x / viewport_size.y, 1.0);
    
    // Standard perspective projection
    return normalize(vec3f(clip.x, clip.y, 1.5));
}

// Ray-Plane intersection
fn intersect_plane(origin: vec3f, direction: vec3f, point: vec3f, normal: vec3f) -> f32 { 
    return clamp(dot(point - origin, normal) / dot(direction, normal), -1.0, 9991999.0); 
}

// Simple atmosphere approximation
fn extra_cheap_atmosphere(ray_dir: vec3f, sun_dir: vec3f) -> vec3f {
    let special_trick = 1.0 / (ray_dir.y * 1.0 + 0.1);
    let special_trick2 = 1.0 / (sun_dir.y * 11.0 + 1.0);
    let raysundt = pow(abs(dot(sun_dir, ray_dir)), 2.0);
    let sundt = pow(max(0.0, dot(sun_dir, ray_dir)), 8.0);
    let mymie = sundt * special_trick * 0.2;
    
    let suncolor = mix(vec3f(1.0), max(vec3f(0.0), vec3f(1.0) - vec3f(5.5, 13.0, 22.4) / 22.4), special_trick2);
    let bluesky = vec3f(5.5, 13.0, 22.4) / 22.4 * suncolor;
    let bluesky2 = max(vec3f(0.0), bluesky - vec3f(5.5, 13.0, 22.4) * 0.002 * (special_trick + -6.0 * sun_dir.y * sun_dir.y));
    
    return bluesky2 * special_trick * (0.24 + raysundt * 0.24) * (1.0 + 1.0 * pow(1.0 - ray_dir.y, 3.0));
}

// Calculate sun direction (moving around the sky)
fn get_sun_direction() -> vec3f {
    return normalize(vec3f(-0.0773502691896258, 0.5 + sin(globals.time * 0.2 + 2.6) * 0.45, 0.5773502691896258));
}

// Get atmosphere color for given direction
fn get_atmosphere(dir: vec3f) -> vec3f {
    return extra_cheap_atmosphere(dir, get_sun_direction()) * 0.5;
}

// Get sun color for given direction
fn get_sun(dir: vec3f) -> f32 { 
    return pow(max(0.0, dot(dir, get_sun_direction())), 720.0) * 210.0;
}

// ACES tonemapping function - corrected WGSL version
fn aces_tonemap(color: vec3f) -> vec3f {  
    let m1 = mat3x3f(
        0.59719, 0.07600, 0.02840,
        0.35458, 0.90834, 0.13383,
        0.04823, 0.01566, 0.83777
    );
    let m2 = mat3x3f(
        1.60475, -0.10208, -0.00327,
        -0.53108,  1.10813, -0.07276,
        -0.07367, -0.00605,  1.07602
    );
    let v = m1 * color;  
    let a = v * (v + 0.0245786) - 0.000090537;
    let b = v * (0.983729 * v + 0.4329510) + 0.238081;
    let x = m2 * (a / b);
    return pow(clamp(x, vec3f(0.0), vec3f(1.0)), vec3f(1.0 / 2.2));
}

@fragment
fn fragment(input: VertexOutput) -> @location(0) vec4f {
    // Get the ray direction
    let ray = get_ray(input.position.xy);
    
    // If ray is pointing upwards, render sky
    if(ray.y >= 0.0) {
        let atmosphere_color = get_atmosphere(ray) + get_sun(ray);
        return vec4f(aces_tonemap(atmosphere_color * 2.0), 1.0);   
    }
    
    // Define water planes
    let water_plane_high = vec3f(0.0, 0.0, 0.0);
    let water_plane_low = vec3f(0.0, -WATER_DEPTH, 0.0);
    
    // Define ray origin (moving forward over time)
    let origin = vec3f(globals.time * 0.2, CAMERA_HEIGHT, 1.0);
    
    // Calculate intersections with water planes
    let high_plane_hit = intersect_plane(origin, ray, water_plane_high, vec3f(0.0, 1.0, 0.0));
    let low_plane_hit = intersect_plane(origin, ray, water_plane_low, vec3f(0.0, 1.0, 0.0));
    let high_hit_pos = origin + ray * high_plane_hit;
    let low_hit_pos = origin + ray * low_plane_hit;
    
    // Raymarch water and find hit position
    let dist = raymarch_water(origin, high_hit_pos, low_hit_pos, WATER_DEPTH);
    let water_hit_pos = origin + ray * dist;
    
    // Calculate normal at hit position
    var N = calculate_normal(water_hit_pos.xz, 0.01, WATER_DEPTH);
    
    // Smooth normal with distance to reduce high frequency noise
    N = mix(N, vec3f(0.0, 1.0, 0.0), 0.8 * min(1.0, sqrt(dist*0.01) * 1.1));
    
    // Calculate fresnel effect
    let fresnel = (0.04 + (1.0-0.04)*(pow(1.0 - max(0.0, dot(-N, ray)), 5.0)));
    
    // Reflect the ray (ensure it bounces upwards)
    var R = normalize(reflect(ray, N));
    R.y = abs(R.y);
    
    // Calculate reflection and subsurface scattering
    let reflection = get_atmosphere(R) + get_sun(R);
    let scattering = vec3f(0.0293, 0.0698, 0.1717) * 0.1 * (0.2 + (water_hit_pos.y + WATER_DEPTH) / WATER_DEPTH);
    
    // Combine results with tonemapping
    let final_color = fresnel * reflection + scattering;
    return vec4f(aces_tonemap(final_color * 2.0), 1.0);
}