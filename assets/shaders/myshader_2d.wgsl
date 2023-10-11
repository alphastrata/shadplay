//!
//! Showing how to the mouse
//!
#import bevy_pbr::mesh_vertex_output      MeshVertexOutput
#import bevy_sprite::mesh2d_view_bindings globals
#import bevy_render::view                 View
#import shadplay::shader_utils::common    NEG_HALF_PI, rotate2D 

@group(0) @binding(0) var<uniform> view: View;
@group(1) @binding(0) var<uniform>myshader: YourShader2D;
@group(1) @binding(1) var texture: texture_2d<f32>;
@group(1) @binding(2) var texture_sampler: sampler;



struct YourShader2D{
    mouse_pos : vec2f,
}

const SPEED: f32 = 1.0;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    let uv = in.uv;
    // ensure our uv coords match shadertoy/the-lil-book-of-shaders
    // var uv = (in.uv * 2.0) - 1.0;
    // let resolution = view.viewport.zw;
    // let t = globals.time * SPEED;
    // uv.x *= resolution.x / resolution.y;
    // uv *= rotate2D(NEG_HALF_PI);

    var col: vec4f = vec4f(0.0);
    col.b = uv.x;
    col.r = uv.y;
    col.g = uv.y;

    // col.g += myshader.mouse_pos.y;
    // col.r -= myshader.mouse_pos.x;


    
    col.a = myshader.mouse_pos.x;

    return col;
}    
    
