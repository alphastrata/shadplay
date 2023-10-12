/// ***************************** ///
/// THIS IS THE DEFAULT 2D SHADER ///
/// You can always get back to this with `python3 scripts/reset-2d.py` ///
/// ***************************** ///

/// This is a port of 'fractal pyramid' by brajamesgrant from shadertoy https://www.shadertoy.com/view/tsXBzS
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_sprite::mesh2d_view_bindings globals 
#import shadplay::shader_utils::common NEG_HALF_PI, shaderToyDefault, rotate2D

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

    var col =vec4f(shaderToyDefault(t, uv), 1.0);
    col.a *= abs(mouse.y);
    col.a *= abs(mouse.x);
    col.a *= 0.225; // prevent us from ever going truly transparent.

    return col;
}    

