// Water Shader with Interactive Controls
// Port of "Water" shader from https://www.shadertoy.com/view/Ms2SD1
// Original by afl_ext (MIT License)
// Modifications: Toggleable sun, speed/zoom controls, hopefully informative? comments

#import bevy_sprite::mesh2d_view_bindings::globals 
#import shadplay::shader_utils::common::{NEG_HALF_PI, shader_toy_default, rotate2D, PI}
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

// CONTROLS
const DRAG_MULT: f32 = 0.38;       // Hydrodynamic drag coefficient
const WATER_DEPTH: f32 = 1.0;      // Vertical scale of water volume
const CAMERA_HEIGHT: f32 = 1.5;    // Camera elevation above water
const ITERATIONS_RAYMARCH: i32 = 12; // Balance quality/performance for raymarching
const ITERATIONS_NORMAL: i32 = 36;   // Higher quality for normal calculations
const SPEED:f32 = 0.60; // SLOW MOTION
const SUN_ON:f32 = 1.0; // 0.0 will disable the sun, which runis the lightning, but is still cool.
const ZOOM:f32 = 0.85; // I dunno how to solve the fisheye problem yet this creates..

/// Creates a 3x3 rotation matrix using axis-angle representation
///  axis Normalized rotation axis
///  angle Rotation angle in radians
///  3x3 rotation matrix
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

/// Calculates wave height and horizontal derivative at given position
///  position 2D surface position
///  direction Wave propagation direction
///  frequency Spatial frequency of wave
///  timeshift Time-based phase shift
///  vec2(wave_height, x_derivative)
fn wavedx(position: vec2f, direction: vec2f, frequency: f32, timeshift: f32) -> vec2f {
    let phase = dot(direction, position) * frequency + timeshift;
    let wave = exp(sin(phase) - 1.0);       // Exponential sine wave for sharp crests
    let dx = wave * cos(phase);             // Derivative for horizontal displacement
    return vec2f(wave, -dx);
}

/// Generates multi-octave wave pattern using fractal summation
///  i_position 2D surface position
///  iterations Number of octaves to accumulate
///  time Current time adjusted by speed control
///  Heightmap value at position
fn get_waves(i_position: vec2f, iterations: i32, time: f32) -> f32 {
    let wave_phase_shift = length(i_position) * 0.1; // Position-based phase variation
    var iter: f32 = 0.0;                  // Wave seed for directional variation
    var frequency: f32 = 1.0;             // Frequency multiplier per octave
    var time_multiplier: f32 = 2.0;        // Time scaling per octave
    var weight: f32 = 1.0;                // Energy preservation weight
    var sum_values: f32 = 0.0;            // Accumulated wave heights
    var sum_weights: f32 = 0.0;           // Normalization factor
    
    for(var i: i32 = 0; i < iterations; i += 1) {
        // Generate pseudo-random wave direction from seed
        let dir = vec2f(sin(iter), cos(iter));
        
        // Calculate wave height and displacement
        let wave_data = wavedx(i_position, dir, frequency, time * time_multiplier + wave_phase_shift);

        // Advect position based on wave displacement
        let new_pos = i_position + dir * wave_data.y * weight * DRAG_MULT;

        // Accumulate weighted results
        sum_values += wave_data.x * weight;
        sum_weights += weight;

        // Prepare next octave with decreased influence
        weight = mix(weight, 0.0, 0.2);   // Energy preservation falloff
        frequency *= 1.18;                 // Increase frequency geometrically
        time_multiplier *= 1.07;           // Accelerate time variation
        iter += 1232.399963;               // Arbitrary seed increment
    }
    
    return sum_values / sum_weights; // Normalize accumulated values
}

/// Raymarching through water volume to find surface intersection
///  camera_pos Camera position in world space
///  start Ray start position (water surface)
///  end Ray end position (water floor)
///  depth Vertical depth of water volume
///  time Time adjusted by speed control
///  Distance from camera to intersection point
fn raymarch_water(camera_pos: vec3f, start: vec3f, end: vec3f, depth: f32, time: f32) -> f32 {
    var pos: vec3f = start;
    let dir = normalize(end - start);
    
    // Adaptive step size based on water depth
    for(var i: i32 = 0; i < 64; i += 1) {
        let wave_height = get_waves(pos.xz, ITERATIONS_RAYMARCH, time) * depth - depth;
        
        // Check intersection with wave surface
        if(abs(wave_height - pos.y) < 0.01) {
            return distance(pos, camera_pos);
        }
        
        // March forward proportionally to height difference
        pos += dir * (pos.y - wave_height);
    }
    return distance(start, camera_pos); // Fallback for no intersection
}

/// Calculates surface normal using finite differences
///  pos 2D surface position
///  epsilon Sampling distance for normal calculation
///  depth Water depth for height scaling
///  time Time adjusted by speed control
///  Normalized surface normal vector
fn calculate_normal(pos: vec2f, epsilon: f32, depth: f32, time: f32) -> vec3f {
    let dx = vec2f(epsilon, 0.0);
    let dz = vec2f(0.0, epsilon);
    
    // Central sample
    let h_center = get_waves(pos, ITERATIONS_NORMAL, time) * depth;
    
    // X-axis neighbors
    let h_left = get_waves(pos - dx, ITERATIONS_NORMAL, time) * depth;
    let h_right = get_waves(pos + dx, ITERATIONS_NORMAL, time) * depth;
    
    // Z-axis neighbors
    let h_down = get_waves(pos - dz, ITERATIONS_NORMAL, time) * depth;
    let h_up = get_waves(pos + dz, ITERATIONS_NORMAL, time) * depth;
    
    // Finite difference approximation
    return normalize(vec3f(h_left - h_right, 2.0 * epsilon, h_down - h_up));
}

/// Generates view ray based on fragment coordinates and zoom
///  frag_coord Fragment position in screen space
///  zoom Camera zoom level (1.0 = default)
///  Normalized view direction vector
fn get_ray(frag_coord: vec2f, zoom: f32) -> vec3f {
    let viewport = view.viewport.zw;
    let uv = vec2f(
        frag_coord.x / viewport.x,
        1.0 - (frag_coord.y / viewport.y) // Flip Y for Bevy coordinate system
    );
    
    // Convert to normalized device coordinates
    let clip = (uv * 2.0 - 1.0) * vec2f(viewport.x / viewport.y, 1.0);
    
    // Adjust FOV with zoom (larger zoom = narrower FOV)
    return normalize(vec3f(clip.x, clip.y, 1.5 / zoom));
}

/// Computes sun direction with optional animation
///  time Time adjusted by speed control
///  enabled Sun toggle state
///  Normalized sun direction vector (zero vector when disabled)
fn get_sun_direction(time: f32, enabled: f32) -> vec3f {
    // Base direction with vertical oscillation
    let animated_y = 0.5 + sin(time * 0.2 + 2.6) * 0.45;
    let raw_dir = vec3f(-0.07735, animated_y, 0.57735);
    
    // Apply toggle and normalize
    return normalize(raw_dir) * step(0.5, enabled);
}

/// Approximates atmospheric scattering with physically-inspired terms
///  ray_dir View direction vector (normalized)
///  sun_dir Sun direction vector (normalized)
///  RGB atmospheric color
fn extra_cheap_atmosphere(ray_dir: vec3f, sun_dir: vec3f) -> vec3f {
    // Horizon darkening effect
    let inv_ray_y = 1.0 / (ray_dir.y * 1.0 + 0.1);
    
    // Sun altitude effect
    let sun_altitude = 1.0 / (sun_dir.y * 11.0 + 1.0);
    let sun_dot = dot(sun_dir, ray_dir);
    
    // Mie scattering approximation
    let mie_scattering = pow(max(sun_dot, 0.0), 8.0) * inv_ray_y * 0.2;
    
    // Base sky color affected by sun position
    let base_sky = mix(
        vec3f(1.0), 
        max(vec3f(0.0), vec3f(1.0) - vec3f(5.5,13.0,22.4)/22.4), 
        sun_altitude
    );
    
    // Blue sky color with horizon effect
    let blue = vec3f(5.5,13.0,22.4)/22.4 * base_sky;
    let horizon = max(
        vec3f(0.0), 
        blue - vec3f(5.5,13.0,22.4)*0.002*(inv_ray_y - 6.0*sun_dir.y*sun_dir.y)
    );
    
    // Final atmospheric color with view angle effects
    return horizon * inv_ray_y * (0.24 + pow(abs(sun_dot), 2.0)*0.24) * (1.0 + pow(1.0 - ray_dir.y, 3.0));
}

/// Calculates sun disk intensity
///  dir View direction vector
///  sun_dir Sun direction vector
///  Sun brightness scalar
fn get_sun(dir: vec3f, sun_dir: vec3f) -> f32 { 
    return pow(max(0.0, dot(dir, sun_dir)), 720.0) * 210.0;
}

/// ACES filmic tone mapping operator
/// Reference: https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve/
///  color Input linear HDR color
///  Tonemapped color in sRGB space
fn aces_tonemap(color: vec3f) -> vec3f {
    // ACES input matrix (RGB to LMS)
    let M1 = mat3x3f(
        0.59719, 0.07600, 0.02840,
        0.35458, 0.90834, 0.13383,
        0.04823, 0.01566, 0.83777
    );
    
    // ACES output matrix (LMS to RGB)
    let M2 = mat3x3f(
        1.60475, -0.10208, -0.00327,
        -0.53108, 1.10813, -0.07276,
        -0.07367, -0.00605, 1.07602
    );
    
    // Apply input matrix transform
    let v = M1 * color;
    
    // Apply tone curve
    let a = v * (v + 0.0245786) - 0.000090537;
    let b = v * (0.983729 * v + 0.4329510) + 0.238081;
    let tone = a / b;
    
    // Apply output matrix and clamp
    let x = M2 * tone;
    return pow(clamp(x, vec3f(0.0), vec3f(1.0)), vec3f(1.0/2.2));
}
/// Computes the intersection distance between a ray and a plane
///  ray_origin Origin point of the ray
///  ray_dir Normalized direction vector of the ray
///  plane_point Any point on the plane
///  plane_normal Normalized normal vector of the plane
///  Distance along ray to intersection (negative if behind origin)
fn intersect_plane(ray_origin: vec3f, ray_dir: vec3f, plane_point: vec3f, plane_normal: vec3f) -> f32 {
    // Calculate denominator (cosine of angle between ray and plane normal)
    let denom = dot(plane_normal, ray_dir);
    
    // Avoid division by zero (ray parallel to plane)
    if (abs(denom) > 1e-6) {
        // Calculate signed distance from ray origin to plane
        let t = dot(plane_point - ray_origin, plane_normal) / denom;
        return t;
    }
    
    // Return large negative value if no intersection
    return -1e6;
}

@fragment
fn fragment(input: VertexOutput) -> @location(0) vec4f {
    // Adjust time with speed control
    let adjusted_time = globals.time *SPEED;
    
    // Generate view ray with zoom control
    let ray = get_ray(input.position.xy, ZOOM);
    
    // Early exit for sky rendering
    if(ray.y >= 0.0) {
        let sun_dir = get_sun_direction(adjusted_time, SUN_ON);
        let atmos = extra_cheap_atmosphere(ray, sun_dir) * 0.5;
        let sun = get_sun(ray, sun_dir);
        return vec4f(aces_tonemap((atmos + sun) * 2.0), 1.0);
    }
    
    // Water plane definitions
    let water_top = vec3f(0.0, 0.0, 0.0);
    let water_bottom = vec3f(0.0, -WATER_DEPTH, 0.0);
    
    // Animated camera position
    let origin = vec3f(
        adjusted_time * 0.2, // Horizontal movement over time
        CAMERA_HEIGHT,
        1.0 // Z-position controlled by zoom in get_ray
    );
    
    // Calculate water plane intersections
    let t_top = intersect_plane(origin, ray, water_top, vec3f(0.0,1.0,0.0));
    let t_bottom = intersect_plane(origin, ray, water_bottom, vec3f(0.0,1.0,0.0));
    let hit_top = origin + ray * t_top;
    let hit_bottom = origin + ray * t_bottom;
    
    // Raymarch through water volume
    let dist = raymarch_water(origin, hit_top, hit_bottom, WATER_DEPTH, adjusted_time);
    let surface_pos = origin + ray * dist;
    
    // Calculate surface normal with distance-based smoothing
    var normal = calculate_normal(surface_pos.xz, 0.01, WATER_DEPTH, adjusted_time);
    normal = mix(normal, vec3f(0.0,1.0,0.0), 0.8*min(1.0, sqrt(dist*0.01)*1.1));
    
    // Fresnel effect calculation (I do not understand the magics here...)
    let fresnel = 0.04 + 0.96*pow(1.0 - max(0.0, dot(-normal, ray)),5.0);
    
    // Reflection vector with upward bias
    var refl_dir = reflect(ray, normal);
    refl_dir.y = abs(refl_dir.y); // Prevent downward reflections
    
    // Atmosphere and sun contributions
    let sun_dir = get_sun_direction(adjusted_time, SUN_ON);
    let reflection = extra_cheap_atmosphere(refl_dir, sun_dir)*0.5 + get_sun(refl_dir, sun_dir);
    
    // Subsurface scattering approximation
    let depth_factor = (surface_pos.y + WATER_DEPTH)/WATER_DEPTH;
    let scattering = vec3f(0.0293, 0.0698, 0.1717)*0.1*(0.2 + depth_factor);
    
    // Final color composition
    let final_color = fresnel*reflection + scattering;
    return vec4f(aces_tonemap(final_color*2.0), 1.0);
}