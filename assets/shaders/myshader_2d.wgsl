//
// Porting https://www.shadertoy.com/view/tsBXW3 by set111:https://www.shadertoy.com/user/set111
//

/// ***************************** ///
/// Pure Procedural Black Hole Shader ///
/// ***************************** ///

#import bevy_sprite::mesh2d_vertex_output::VertexOutput
#import bevy_sprite::mesh2d_view_bindings::globals  // for 2D
#import bevy_render::view::View
#import bevy_pbr::utils::PI
#import shadplay::shader_utils::common::{NEG_HALF_PI, shader_toy_default, rotate2D, TWO_PI}

@group(0) @binding(0) var<uniform> view: View;

const SPEED: f32 = 0.25;
const CAM_DISTANCE: f32 = 2.0;
const DISK_ROTATION_SPEED: f32 = 3.0;
const DISK_TEXTURE_LAYERS: f32 = 12.0;
const BLACK_HOLE_SIZE: f32 = 0.3;
const PI: f32 = 3.141592653589793;
const FOV: f32 = 1.5;  // Wider field of view

@fragment
fn fragment(
    in: VertexOutput
) -> @location(0) vec4<f32> {
    let t = globals.time * SPEED;
    let resolution = view.viewport.zw;
    
    // Screen coordinates (-1 to 1 with aspect ratio correction)
    var frag_coord = (in.uv * 2.0 - 1.0) * vec2f(resolution.x/resolution.y, 1.0);
    
    // Create ray direction
    var ray = normalize(vec3f(frag_coord, FOV));
    
    // Rotate the scene for animation
    ray = rotate3D(ray, vec2f(t * 0.1, PI * 0.25));
    
    // Start with starfield background
    var col = starfield(ray);
    
    // Add accretion disk
    let disk = accretion_disk(ray, vec3f(0.0), t);
    col = mix(col, disk, disk.a);
    
    // Black hole gravitational effects
    var pos = ray * CAM_DISTANCE;
    for (var i: i32 = 0; i < 20; i++) {
        let dist = length(pos);
        
        // Event horizon
        if dist < BLACK_HOLE_SIZE * 0.1 {
            col = vec4f(0.0, 0.0, 0.0, 1.0);
            break;
        }
        
        let step_dist = min(0.5, dist * 0.5);
        let inv_dist = 1.0 / dist;
        let bend_force = step_dist * inv_dist * inv_dist * BLACK_HOLE_SIZE;
        
        // Bend ray toward black hole
        ray = normalize(ray - bend_force * pos * inv_dist);
        pos += ray * step_dist;
        
        // Disk intersection
        if abs(pos.y) < BLACK_HOLE_SIZE * 0.01 {
            let disk_col = accretion_disk(ray, pos, t);
            col = mix(col, disk_col, disk_col.a);
            pos += ray * abs(BLACK_HOLE_SIZE * 0.01 / ray.y);
        }
    }
    
    return col;
}

fn accretion_disk(ray: vec3f, pos: vec3f, t: f32) -> vec4f {
    let len_pos = length(pos.xz);
    let dist = min(1.0, len_pos * 0.5 / BLACK_HOLE_SIZE) * 0.4 / abs(ray.y);
    
    var col = vec4f(0.0);
    var glow = vec3f(0.0);
    
    for (var i: f32 = 0.0; i < DISK_TEXTURE_LAYERS; i += 1.0) {
        var p = pos - ray * dist * i * 0.5;
        let intensity = clamp(1.0 - abs((i - 0.8) * 0.166), 0.0, 1.0);
        let len_p = length(p.xz);
        
        // Disk shape
        var dist_mult = 1.0;
        dist_mult *= smoothstep(9.0, 10.0, len_p);
        dist_mult *= smoothstep(120.0, 110.0, len_p);
        dist_mult *= dist_mult;
        
        // Rotation and turbulence
        let rot = t * DISK_ROTATION_SPEED;
        let x = -p.z * sin(rot) + p.x * cos(rot);
        let turbulence = value_noise(vec2f(0.02 * atan(x), len_p * 0.05), 70.0);
        
        // Doppler effect (redshift/blueshift)
        let velocity_factor = dot(normalize(ray.xz), normalize(p.xz));
        let red_shift = clamp(pow(velocity_factor * 0.5 + 0.3, 2.0), 0.0, 1.0);
        
        // Disk colors
        var inner_color = mix(
            vec3f(1.0, 0.7, 0.3),  // Warm inner disk
            vec3f(1.6, 2.4, 4.0),  // Blue shifted
            red_shift
        );
        
        var outer_color = mix(
            vec3f(0.4, 0.2, 0.1),  // Cool outer disk
            vec3f(1.6, 2.4, 4.0),  // Blue shifted
            red_shift
        );
        
        var disk_color = mix(inner_color, outer_color, smoothstep(15.0, 60.0, len_p));
        disk_color *= 1.25;
        
        // Alpha based on turbulence and distance
        let alpha = clamp(turbulence * intensity * dist_mult * 10.0, 0.0, 1.0);
        col = vec4f(disk_color * alpha + col.rgb * (1.0 - alpha), alpha + col.a * (1.0 - alpha));
        
        // Accumulate glow
        glow += red_shift * intensity * 8.33 / (len_p * len_p);
    }
    
    // Add glow effect
    glow = clamp(glow - 0.005, 0.0, 1.0);
    return vec4f(col.rgb + glow * 0.5, col.a);
}

fn starfield(ray: vec3f) -> vec4f {
    // Project ray onto 2D plane for star coordinates
    var uv = ray.xy;
    if abs(ray.x) > abs(ray.y) { uv.x = ray.z; }
    if abs(ray.y) > abs(ray.x) { uv.y = ray.z; }
    
    // Generate stars with different densities
    var stars = vec3f(0.0);
    
    // Large bright stars
    let big_stars = pow(value_noise(uv * 8.0, 50.0), 256.0) * 100.0;
    stars += big_stars * mix(
        vec3f(1.0, 0.9, 0.8),  // Warm white
        vec3f(0.8, 0.9, 1.0),  // Cool white
        value_noise(uv * 3.0, 20.0)
    );
    
    // Small faint stars
    let small_stars = pow(value_noise(uv * 20.0, 100.0), 512.0) * 50.0;
    stars += small_stars * 0.7;
    
    // Nebula-like background
    var nebula = vec3f(0.0);
    let n1 = value_noise(uv * 0.5, 5.0);
    let n2 = value_noise(uv * 1.0, 10.0);
    nebula += vec3f(0.2, 0.1, 0.3) * n1 * 0.5;  // Purple clouds
    nebula += vec3f(0.1, 0.2, 0.4) * n2 * 0.3;  // Blue clouds
    
    return vec4f(stars + nebula, 1.0);
}

fn rotate3D(v: vec3f, angle: vec2f) -> vec3f {
    // Y-axis rotation (left/right)
    let cosY = cos(angle.x);
    let sinY = sin(angle.x);
    let y_rot = mat3x3f(
        cosY, 0.0, -sinY,
        0.0, 1.0, 0.0,
        sinY, 0.0, cosY
    );
    
    // X-axis rotation (up/down)
    let cosX = cos(angle.y);
    let sinX = sin(angle.y);
    let x_rot = mat3x3f(
        1.0, 0.0, 0.0,
        0.0, cosX, sinX,
        0.0, -sinX, cosX
    );
    
    return y_rot * x_rot * v;
}

fn value_noise(p: vec2f, freq: f32) -> f32 {
    let p_freq = p * freq;
    let p_floor = floor(p_freq);
    let p_fract = fract(p_freq);
    
    // Smooth interpolation
    let p_smooth = (3.0 - 2.0 * p_fract) * p_fract * p_fract;
    
    // Get noise values at the four corners
    let a = hash21(p_floor);
    let b = hash21(p_floor + vec2f(1.0, 0.0));
    let c = hash21(p_floor + vec2f(0.0, 1.0));
    let d = hash21(p_floor + vec2f(1.0, 1.0));
    
    // Bilinear interpolation
    return mix(mix(a, b, p_smooth.x), mix(c, d, p_smooth.x), p_smooth.y);
}

fn hash21(p: vec2f) -> f32 {
    let d = dot(p, vec2f(12.9898, 78.233));
    return fract(sin(d) * 43758.5453);
}