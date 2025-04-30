///
/// Port of https://www.shadertoy.com/view/XXyGzh by https://www.shadertoy.com/user/SnoopethDuckDuck
/// 

#import bevy_sprite::mesh2d_view_bindings::globals 
#import shadplay::shader_utils::common::{NEG_HALF_PI, shader_toy_default, rotate2D, TWO_PI}
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

const ANIMATION_SPEED: f32 = 1.0;
// The zoom here is quite cool, if made small enough you can see we're just really zoomed in on the far
// edge of a circle, locally within that zoomed in frame of reference it's disorientating enough to seem 
// utterly random.
const BASE_ZOOM: f32 = 0.01;
const ITERATION_COUNT: f32 = 19.0;
const COLOR_INTENSITY: f32 = 5.9;

@fragment
fn fragment(vertex_output: VertexOutput) -> @location(0) vec4<f32> {
    // Normalize UV coordinates to centered [-1, 1] range
    var uv_coordinates = vertex_output.uv;
    uv_coordinates = (uv_coordinates * 2.0) - 1.0;
    
    let viewport_dimensions = view.viewport.zw;
    let time = globals.time * ANIMATION_SPEED;
    
    // Correct for aspect ratio
    let aspect_ratio = viewport_dimensions.x / viewport_dimensions.y;
    uv_coordinates.x *= aspect_ratio;
    
    // Apply zoom transformation
    uv_coordinates = uv_coordinates / BASE_ZOOM;
    
    // Prepare coordinate system for fractal calculations
    var fractal_space = viewport_dimensions.xy;
    let coordinate_normalizer = 0.2 / viewport_dimensions.y;
    uv_coordinates = coordinate_normalizer * (uv_coordinates + uv_coordinates - fractal_space);
    
    let original_uv_pattern = uv_coordinates;
    
    // Initialize color accumulation
    var base_color = vec4f(1.0, 2.0, 3.0, 0.0);
    var final_color = base_color;
    var animation_parameter = 0.5;
    
    // Main fractal generation loop
    for (var iteration = 0.0; iteration < ITERATION_COUNT; iteration += 1.0) {
        // Calculate time-dependent color modulation
        let time_color_shift = cos(base_color + time);
        let color_modulation = 1.0 + time_color_shift;
        
        // Calculate spatial distortion components
        let coord_magnitude = dot(fractal_space, fractal_space);
        let iteration_factor = 1.0 + iteration * coord_magnitude;
        
        // Compute complex denominator components
        let uv_magnitude = dot(uv_coordinates, uv_coordinates);
        let distortion_divisor = 0.5 - uv_magnitude;
        let base_distortion = 1.5 * uv_coordinates / distortion_divisor;
        
        let time_distortion = 9.0 * uv_coordinates.yx + time;
        let full_distortion = base_distortion - time_distortion;
        
        // Combine components for final denominator
        let distorted_wave = sin(full_distortion);
        let scaled_distortion = iteration_factor * distorted_wave;
        let distortion_length = length(scaled_distortion);
        
        // Accumulate color
        final_color += color_modulation / distortion_length;
        
        // Update animation parameters
        animation_parameter += 0.03;
        
        // Calculate coordinate transformations
        let time_shift = time + 1.0;
        let uv_scale = 7.0 * uv_coordinates;
        let power_factor = pow(animation_parameter, iteration);
        let inner_transform = time_shift - uv_scale * power_factor;
        
        fractal_space = cos(inner_transform) - 5.0 * uv_coordinates;
        
        // Build rotation matrix
        let angle1 = iteration + 0.02 * time - 0.0;
        let angle2 = iteration + 0.02 * time - 11.0;
        let angle3 = iteration + 0.02 * time - 33.0;
        let angle4 = iteration + 0.02 * time - 0.0;
        
        let rotation_matrix = mat2x2<f32>(
            cos(angle1), cos(angle2),
            cos(angle3), cos(angle4)
        );
        
        // Apply coordinate transformations
        uv_coordinates = uv_coordinates * rotation_matrix;
        
        // Calculate additional perturbations
        let perturbation1_input = 40.0 * dot(uv_coordinates, uv_coordinates);
        let perturbation1_wave = cos(1e2 * uv_coordinates.yx + time);
        let perturbation1 = tanh(perturbation1_input * perturbation1_wave) / 2e2;
        
        let perturbation2 = 0.2 * animation_parameter * uv_coordinates;
        
        let color_magnitude = dot(final_color, final_color);
        let perturbation3_wave = 4.0 / exp(color_magnitude / 1e2) + time;
        let perturbation3 = cos(perturbation3_wave) / 3e2;
        
        uv_coordinates += perturbation1 + perturbation2 + perturbation3;
    }
    
    // Final color processing
    let normalized_color = final_color / COLOR_INTENSITY;
    let hyperbolic_color = tanh(normalized_color);
    let pattern_contribution = dot(original_uv_pattern, original_uv_pattern);
    
    return hyperbolic_color - pattern_contribution;
}