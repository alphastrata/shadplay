/// How to use the mouse, in shadplay.
#import bevy_pbr::forward_io::VertexOutput
#import bevy_sprite::mesh2d_view_bindings globals 
#import shadplay::shader_utils::common NEG_HALF_PI, shader_toy_default, rotate2D

#import bevy_render::view  View
@group(0) @binding(0) var<uniform> view: View;

@group(1) @binding(0) var<uniform> mouse: YourShader2D;
struct YourShader2D{
    mouse_pos : vec2f,
}

const SPEED:f32 = 1.0;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    // ensure our uv coords match shadertoy/the-lil-book-of-shaders
    var uv = (in.uv * 2.0) - 1.0;
    let resolution = view.viewport.zw;
    let mouse = mouse.mouse_pos;
    let t = globals.time * SPEED;
    uv.x *= resolution.x / resolution.y;
    uv *= rotate2D(NEG_HALF_PI);

    var col =vec4f(shader_toy_default(t, uv), 1.0);
    col.a *= abs(mouse.y);
    col.a *= abs(mouse.x);
    col.a *= 0.225; // prevent us from ever going truly transparent.

    return col;
}    

