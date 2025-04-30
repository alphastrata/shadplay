/// ***************************** ///
/// THIS IS THE DEFAULT 2D SHADER ///
/// You can always get back to this with `python3 scripts/reset-2d.py` ///
/// ***************************** ///

#import bevy_sprite::mesh2d_view_bindings::globals 
#import shadplay::shader_utils::common::{NEG_HALF_PI, shader_toy_default, rotate2D, TWO_PI}
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

const SPEED:f32 = 0.8;
const ZOOM_FACTOR:f32 = 0.02; // <-- Adjust this to zoom in/out (higher = more zoomed out)



// Enable these to see different parts of the shader in action
// #define EXPLAIN_UV_TRANSFORM
// #define EXPLAIN_MAIN_LOOP
// #define EXPLAIN_FINAL_COLOR

@fragment
fn fragment(input: VertexOutput) -> @location(0) vec4<f32> {
    // Convert UV coordinates from [0,1] to [-1,1] range (centered)
    var uv_coords = input.uv;
    uv_coords = (uv_coords * 2.0) - 1.0;
    
    let viewport_size = view.viewport.zw;
    let current_time = globals.time * SPEED;
    
    // Adjust for aspect ratio to prevent stretching
    uv_coords.x *= viewport_size.x / viewport_size.y;
    
    // Apply zoom factor
    uv_coords /= ZOOM_FACTOR;
    
#ifdef EXPLAIN_UV_TRANSFORM
    // Debug visualization of UV coordinates
    return vec4f(
        (uv_coords.x + 1.0) / 2.0,  // Show red channel for X coordinate
        (uv_coords.y + 1.0) / 2.0,  // Show green channel for Y coordinate
        0.0,                        // Blue channel unused
        1.0                          // Full opacity
    );
#endif

    // Additional coordinate transformations
    var transformed_coords = viewport_size.xy;
    uv_coords = 0.2 * (uv_coords + uv_coords - transformed_coords) / transformed_coords.y;
    var original_uv = uv_coords;
    
    // Color accumulation variables
    var color_components = vec4f(1.0, 2.0, 3.0, 0.0);
    var output_color = color_components;
    
    // Animation parameter
    var animation_factor = 0.5;
    
#ifdef EXPLAIN_MAIN_LOOP
    // Simplified version with just 2 iterations for debugging
    let debug_iterations = 2.0;
#else
    let debug_iterations = 19.0;
#endif

    // Main fractal/animation loop
    for (var iteration = 0.0; iteration < debug_iterations; iteration += 1.0) {
#ifdef EXPLAIN_MAIN_LOOP
        // Show iteration count in blue channel
        if (iteration == 0.0) {
            return vec4f(1.0, 0.0, 0.0, 1.0);
        } else {
            return vec4f(0.0, 1.0, 0.0, 1.0);
        }
#endif
        
        // Accumulate color based on complex transformations
        output_color += (1.0 + cos(color_components + current_time)) / length((1.0 + iteration * dot(transformed_coords, transformed_coords)) *  sin(1.5 * uv_coords / (0.5 - dot(uv_coords, uv_coords)) - 9.0 * uv_coords.yx + current_time));
        
        animation_factor += 0.03;
        
        // Transform coordinates based on time and animation factor
        transformed_coords = cos(current_time + 1.0 - 7.0 * uv_coords * pow(animation_factor, iteration)) - 5.0 * uv_coords;
        
        // Create a rotation matrix that changes over time
        let rotation_matrix = mat2x2<f32>(
            cos(iteration + 0.02 * current_time - 0.0), cos(iteration + 0.02 * current_time - 11.0),
            cos(iteration + 0.02 * current_time - 33.0), cos(iteration + 0.02 * current_time - 0.0)
        );
        
        // Apply rotation and additional transformations
        uv_coords *= rotation_matrix;
        uv_coords += tanh(40.0 * dot(uv_coords, uv_coords) * cos(1e2 * uv_coords.yx + current_time)) / 2e2 + 0.2 * animation_factor * uv_coords +  cos(4.0 / exp(dot(output_color, output_color) / 1e2) + current_time) / 3e2;
    }
    
    // Final color processing
    output_color = tanh(output_color / 5.9) - dot(original_uv, original_uv);
    
#ifdef EXPLAIN_FINAL_COLOR
    // Show components separately
    return vec4f(
        output_color.r,      // Red channel
        output_color.g,      // Green channel
        output_color.b,      // Blue channel
        1.0                  // Alpha
    );
#else
    return output_color;
#endif
}