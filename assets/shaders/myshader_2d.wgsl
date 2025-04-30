/// BLACK HOLE SHADER - FIXED VERSION
#import bevy_sprite::mesh2d_view_bindings::globals
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput
@group(0) @binding(0) var<uniform> view: View;
const BRIGHTNESS: f32 = 0.6; // Moderate brightness

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    // 1. Base setup
    let resolution = vec2f(view.viewport.z, view.viewport.w);
    let aspect = resolution.x / resolution.y;
    var uv = (2.0 * in.uv - 1.0) * vec2f(aspect, 1.0);
    
    // 2. Gravity warp - FIXED
    let dir = normalize(vec2f(-0.5, 0.5));
    // Move gravity center further away
    let gravity_center = dir * 1.5;
    let dist = length(uv - gravity_center);
    
    // FIX 1: Cap maximum gravity to prevent extreme distortion
    let gravity = min(0.1 + 0.5 / max(dist * dist, 0.01), 5.0);
    
    var warped = uv * gravity;
    // return vec4f(fract(warped * 2.0), 0.0, 1.0); // DEBUG: Warped space
    
    // 3. Spiral transformation
    let initial_radius = length(warped);
    let angle = atan2(warped.y, warped.x);
    let spiral_strength = 2.0;
    let spiral_angle = angle + spiral_strength * log(max(initial_radius, 0.01)) - globals.time * 0.5;
    warped = initial_radius * vec2f(cos(spiral_angle), sin(spiral_angle));
    // return vec4f(fract(warped * 3.0), 0.0, 1.0); // DEBUG: Spiral pattern
    
    // 4. Accretion disk waves
    var waves = 0.0;
    for(var i = 0; i < 5; i++) {
        let fi = f32(i);
        // FIX 2: Reduce wave frequency to prevent tiny values
        waves += sin(warped.x * fi * 5.0 + globals.time) * 
                 cos(warped.y * fi * 5.0 - globals.time) / max(fi, 1.0);
    }
    // FIX 3: Scale waves to ensure visible values
    waves = abs(waves) * 0.5 + 0.1;
    // return vec4f(waves, waves * 0.7, waves * 0.3, 1.0); // DEBUG: Waves
    
    // 5. Event horizon
    let final_radius = length(warped);
    // FIX 4: Increase event horizon size to make it visible
    let horizon = smoothstep(0.5, 0.45, final_radius);
    let redshift = exp(-final_radius * 1.5) + 0.1; // Add minimum redshift
    
    // 6. Final composition
    let base_color = vec3f(0.4, 0.8, 1.0); // Blue-white core
    let disk_color = vec3f(1.0, 0.7, 0.3); // Golden accretion disk
    
    // Mix between disk and core based on horizon
    let color = mix(
        disk_color * waves,
        base_color * redshift,
        horizon
    );
    
    // FIX 5: Proper tonemapping to prevent overflow
    let brightened = color * BRIGHTNESS;
    let final_color = brightened / (brightened + vec3f(1.0));
    
    return vec4f(final_color, 1.0);
}