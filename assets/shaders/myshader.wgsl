//!
//! The default 3d Shader.
//!


#import bevy_sprite::mesh2d_vertex_output::VertexOutput
#import bevy_sprite::mesh2d_view_bindings globals
#import bevy_render::view View

fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    // Normalize and center UV coordinates (-1 to 1)
    var uv = (in.uv * 2.0) - 1.0;
    
    // Adjust for aspect ratio
    let resolution = vec2<f32>(globals.viewport_size);
    uv.x *= resolution.x / resolution.y;
    
    // Time variable
    let t = globals.time;
    
    // Iterator and attenuation (distance-squared)
    var iteration: f32 = 0.2;
    var attenuation: f32;
    
    // Diagonal vector for skewing
    let diagonal = vec2<f32>(-1.0, 1.0);
    
    // Blackhole center offset
    let blackhole_center = uv - iteration * diagonal;
    
    // Rotate and apply perspective
    let perspective_coords = uv * mat2x2<f32>(
        vec2<f32>(1.0, 1.0),
        diagonal / (0.1 + iteration / dot(blackhole_center, blackhole_center))
    );
    
    // Calculate distance squared for attenuation
    attenuation = dot(perspective_coords, perspective_coords);
    
    // Rotate into spiraling coordinates
    var spiral_coords = perspective_coords * mat2x2<f32>(
        cos(0.5 * log(attenuation) + t * iteration + vec4<f32>(0.0, 33.0, 11.0, 0.0)).xy,
        cos(0.5 * log(attenuation) + t * iteration + vec4<f32>(0.0, 33.0, 11.0, 0.0)).zw
    ) / iteration;
    
    // Waves cumulative total for coloring
    var wave_total: vec2<f32> = vec2<f32>(0.0);
    
    // Loop through waves
    while (iteration < 9.0) {
        iteration += 1.0;
        
        // Add wave pattern
        wave_total += 1.0 + sin(spiral_coords);
        
        // Distort coordinates
        spiral_coords += 0.7 * sin(spiral_coords.yx * iteration + t) / iteration + 0.5;
    }
    
    // Accretion disk radius
    let disk_radius = length(sin(spiral_coords / 0.3) * 0.4 + perspective_coords * (3.0 + diagonal));
    
    // Red/blue gradient base
    var color = 1.0 - exp(-exp(perspective_coords.x * vec4<f32>(0.6, -0.4, -1.0, 0.0))
        // Wave coloring
        / wave_total.xyyx
        // Accretion disk brightness
        / (2.0 + disk_radius * disk_radius / 4.0 - disk_radius)
        // Center darkness
        / (0.5 + 1.0 / attenuation)
        // Rim highlight
        / (0.03 + abs(length(uv) - 0.7)));
    
    return color;
}