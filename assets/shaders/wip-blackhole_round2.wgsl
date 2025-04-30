#import bevy_sprite::mesh2d_view_bindings::globals
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;
const BRIGHTNESS: f32 = 1.2; // Increased brightness for vibrancy

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    // 1. Base setup with centered coordinates
    let resolution = vec2f(view.viewport.z, view.viewport.w);
    let aspect = resolution.x / resolution.y;
    var uv = (2.0 * in.uv - 1.0) * vec2f(aspect, 1.0);
    
    // 2. Centered gravity warp
    let gravity_center = vec2f(0.0, 0.0); // Center of screen
    let dist = length(uv - gravity_center);
    
    // Gravity calculation with better falloff
    let gravity = min(0.1 + 0.5 / max(dist * dist, 0.01), 3.0);
    var warped = uv * gravity;
    
    // 3. Spiral transformation with tighter winding
    let initial_radius = length(warped);
    let angle = atan2(warped.y, warped.x);
    let spiral_strength = 3.0; // Increased spiral tightness
    let spiral_angle = angle + spiral_strength * log(max(initial_radius, 0.01)) - globals.time * 0.7;
    warped = initial_radius * vec2f(cos(spiral_angle), sin(spiral_angle));
    
    // 4. Accretion disk with color variation
    var waves = 0.0;
    for(var i = 0; i < 5; i++) {
        let fi = f32(i);
        waves += sin(warped.x * fi * 3.0 + globals.time) * 
                 cos(warped.y * fi * 4.0 - globals.time * 1.2) / max(fi * 0.8, 1.0);
    }
    waves = abs(waves) * 0.6 + 0.2;
    
    // 5. Event horizon with gradient colors
    let final_radius = length(warped);
    let horizon = smoothstep(0.4, 0.35, final_radius); // Larger visible area
    let redshift = exp(-final_radius * 3.0) * 2.0 + 0.2; // Stronger color gradient
    
    // 6. Improved color palette
    let base_color = mix(
        vec3f(0.3, 0.6, 1.0), // Blue
        vec3f(0.8, 0.9, 1.0), // White
        exp(-final_radius * 4.0)
    );
    let disk_color = mix(
        vec3f(1.0, 0.5, 0.2), // Orange
        vec3f(1.0, 0.9, 0.4), // Yellow
        waves
    );
    
    // 7. Final composition with glow
    let color = mix(
        disk_color * waves * 1.5,
        base_color * redshift,
        horizon
    );
    
    // Add central glow
    let glow = exp(-final_radius * 15.0) * 0.6;
    let final_color = color + vec3f(1.0, 0.9, 0.8) * glow;
    
    // Tonemapping and output
    return vec4f(final_color * BRIGHTNESS / (final_color + 1.0), 1.0);
}