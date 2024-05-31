/// ***************************** ///
/// This is a port of RainGenerator:
/// https://www.shadertoy.com/view/lt33zM, by TheBinaryCodeX
/// ***************************** ///

#import bevy_sprite::mesh2d_view_bindings::globals 
#import shadplay::shader_utils::common::{NEG_HALF_PI, shader_toy_default, rotate2D, TWO_PI}
#import bevy_render::view::View
#import bevy_pbr::forward_io::VertexOutput;

@group(0) @binding(0) var<uniform> view: View;

// Constants
const LAYERS: i32 = 3;                 // Number of layers of drops
const SCALE: f32 = 256.0;              // Overall scale of the drops
const LENGTH: f32 = 16.298;              // Length of the drops
const LENGTH_SCALE: f32 = 0.6337;         // How much the drop length changes every layer
const FADE: f32 = 0.6;                 // How much the drops fade every layer
const SPEED: f32 = 18.337;                // How fast the drops fall
const DROP_COLOR: vec3<f32> = vec3<f32>(0.54, 0.8, 0.94);
const BG_COLOR: vec3<f32> = vec3<f32>(0.003, 0.02, 0.07);
const ANGLE:f32 = -8.9337;

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4f {
    var uv: vec2f = (in.uv * 2.0) - 1.0;
    uv *= rotate2D(ANGLE); // Change the angle the rain is falling from... -8.4 to 8.4~
    let screen_resolution: vec2f = view.viewport.zw;
    let aspect: f32 = screen_resolution.x / screen_resolution.y;
    uv.x *= aspect;
    
    var finalColor: vec4f = vec4f(0.0, 0.0, 0.0, 0.0);
    
    var dropLength: f32 = LENGTH;
    var alpha: f32 = 1.0;
    
    for (var i: i32 = 0; i < LAYERS; i = i + 1) {
        let f: f32 = rainFactor(uv, SCALE, dropLength, vec2f(SCALE * f32(i), globals.time * SPEED), 0.95);
        
        let color: vec4f = vec4f(DROP_COLOR, f * alpha);
        
        finalColor = over(finalColor, color);
        
        dropLength *= LENGTH_SCALE;
        alpha *= FADE;
    }
    
    finalColor = over(finalColor, vec4f(BG_COLOR, 1.0));
    
    return finalColor;
}

// Function to generate random numbers based on coordinates
fn rand(co: vec2f) -> f32 {
    let a: f32 = 12.9898;
    let b: f32 = 78.233;
    let c: f32 = 43758.5453;
    let dt: f32 = dot(co, vec2f(a, b));
    let sn: f32 = dt % 3.14;

    return fract(sin(sn) * c);
}

// Function to calculate the rain factor based on UV coordinates
fn rainFactor(uv: vec2f, scale: f32, dripLength: f32, offset: vec2f, cutoff: f32) -> f32 {
    let pos: vec2f = uv * vec2f(scale, scale / dripLength) + offset;
    let dripOffset: vec2f = vec2f(0.0, floor(rand(floor(pos * vec2f(1.0, 0.0))) * (dripLength - 0.0001)) / dripLength);
    let f: f32 = rand(floor(pos + dripOffset));
    
    return step(cutoff, f);
}

// Function to overlay two colors
fn over(a: vec4f, b: vec4f) -> vec4f {
    return vec4f(mix(b.rgb, a.rgb, a.a), max(a.a, b.a));
}
