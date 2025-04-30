//
// Port of https://www.shadertoy.com/view/W3sXWj
//

#import bevy_sprite::mesh2d_vertex_output::VertexOutput
#import bevy_sprite::mesh2d_view_bindings globals 
#import shadplay::shader_utils::common NEG_HALF_PI, shader_toy_default, rotate2D

#import bevy_render::view  View
@group(0) @binding(0) var<uniform> view: View;

@group(2) @binding(0) var<uniform> mouse: YourShader2D;
struct YourShader2D{
    mouse_pos : vec2f,
}


const PI: f32 = 3.141592653589;
const BITS_PER_CHANNEL: f32 = 4.0;
const BASE_PIXEL_COUNT: f32 = 2000.0;
const ZOOM_FACTOR: f32 = 1.0; // Higher values zoom in, lower values zoom out

// Cube root functions
fn cube_root_scalar(x: f32) -> f32 {
    return pow(x, 1.0 / 3.0);
}

fn cube_root_vector(v: vec3<f32>) -> vec3<f32> {
    return vec3<f32>(
        cube_root_scalar(v.x),
        cube_root_scalar(v.y),
        cube_root_scalar(v.z)
    );
}

// Pixelation functions
fn pixelate_coordinates(uv: vec2<f32>, pixel_density: vec2<f32>) -> vec2<f32> {
    return floor(uv * pixel_density);
}

// Quantization functions
fn quantize_scalar(value: f32, levels: f32) -> f32 {
    return floor(value * levels) / levels;
}

fn quantize_vector3(v: vec3<f32>, levels: f32) -> vec3<f32> {
    return vec3<f32>(
        floor(v.x * levels) / levels,
        floor(v.y * levels) / levels,
        floor(v.z * levels) / levels
    );
}

fn quantize_to_integer(v: vec3<f32>, levels: f32) -> vec3<u32> {
    return vec3<u32>(
        u32(floor(v.x * levels)),
        u32(floor(v.y * levels)),
        u32(floor(v.z * levels))
    );
}

// RGB to OKLAB conversion matrices
const RGB_TO_LMS_MATRIX: mat3x3<f32> = mat3x3<f32>(
    0.4122214708, 0.5363325363, 0.0514459929,
    0.2119034982, 0.6806995451, 0.1073969566,
    0.0883024619, 0.2817188376, 0.6299787005
);

const LMS_TO_LAB_MATRIX: mat3x3<f32> = mat3x3<f32>(
    0.2104542553, 0.7936177850, -0.0040720468,
    1.9779984951, -2.4285922050, 0.4505937099,
    0.0259040371, 0.7827717662, -0.8086757660
);

fn rgb_to_oklab(rgb_color: vec3<f32>) -> vec3<f32> {
    let lms_values = rgb_color * RGB_TO_LMS_MATRIX;
    let nonlinear_lms = cube_root_vector(lms_values);
    return nonlinear_lms * LMS_TO_LAB_MATRIX;
}

// OKLAB to RGB conversion matrices
const LAB_TO_LMS_MATRIX: mat3x3<f32> = mat3x3<f32>(
    1.0, 0.3963377774, 0.2158037573,
    1.0, -0.1055613458, -0.0638541728,
    1.0, -0.0894841775, -1.2914855480
);

const LMS_TO_RGB_MATRIX: mat3x3<f32> = mat3x3<f32>(
    4.0767416621, -3.3077115913, 0.2309699292,
    -1.2684380046, 2.6097574011, -0.3413193965,
    -0.0041960863, -0.7034186147, 1.7076147010
);

fn oklab_to_rgb(lab_color: vec3<f32>) -> vec3<f32> {
    let lms_values = lab_color * LAB_TO_LMS_MATRIX;
    let linear_lms = lms_values * lms_values * lms_values;
    return linear_lms * LMS_TO_RGB_MATRIX;
}

// LCH conversions (polar representation of LAB)
fn lab_to_lch(lab_color: vec3<f32>) -> vec3<f32> {
    let lightness = lab_color.x;
    let chroma = length(lab_color.yz);
    let hue = atan2(lab_color.z, lab_color.y) / (2.0 * PI);
    return vec3<f32>(lightness, chroma, hue);
}

fn lch_to_lab(lch_color: vec3<f32>) -> vec3<f32> {
    let lightness = lch_color.x;
    let a = lch_color.y * cos(lch_color.z * 2.0 * PI);
    let b = lch_color.y * sin(lch_color.z * 2.0 * PI);
    return vec3<f32>(lightness, a, b);
}

@fragment
fn fragment(input: VertexOutput) -> @location(0) vec4<f32> {
    // Normalize and zoom coordinates
    var uv_coords = input.uv;
    uv_coords -= vec2(0.5); // Center coordinates
    uv_coords /= ZOOM_FACTOR; // Apply zoom
    uv_coords += vec2(0.5); // Restore center
    
    // Calculate quantization parameters
    let color_levels = pow(2.0, BITS_PER_CHANNEL);
    let pixel_density = vec2<f32>(
        BASE_PIXEL_COUNT, 
        BASE_PIXEL_COUNT * view.viewport.z / view.viewport.w
    );
    
    // Create pixelated coordinates
    let pixelated_uv = pixelate_coordinates(uv_coords, pixel_density);
    let normalized_pixel_uv = pixelated_uv / pixel_density;
    
    // Create base color gradient
    var output_color = vec3<f32>(
        1.0 - normalized_pixel_uv.y,
        0.3, // Fixed green channel value
        normalized_pixel_uv.x
    );
    
    // Convert to integer quantized values
    let quantized_color = quantize_to_integer(output_color, color_levels);
    output_color = vec3<f32>(quantized_color) / color_levels;
    
    // Reduce saturation by half
    output_color.y = output_color.y * 0.5;
    
    // Convert to LAB space through LCH
    output_color = lch_to_lab(output_color);
    
    // Convert back to RGB
    output_color = oklab_to_rgb(output_color);
    
    // Special case for pure black (make it red)
    if (all(quantized_color == vec3<u32>(0))) {
        output_color = vec3<f32>(1.0, 0.0, 0.0);
    }
    
    return vec4<f32>(output_color, 1.0);
}