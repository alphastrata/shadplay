/// ***************************** ///
/// THIS IS THE DEFAULT 2D SHADER ///
/// You can always get back to this with `python3 scripts/reset-2d.py` ///
/// ***************************** ///

#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_sprite::mesh2d_view_bindings globals 
#import shadplay::shader_utils::common NEG_HALF_PI, shader_toy_default, rotate2D

#import bevy_render::view  View
@group(0) @binding(0) var<uniform> view: View;

const SPEED:f32 = 1.0;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    // ensure our uv coords match shadertoy/the-lil-book-of-shaders
    var uv = (in.uv * 2.0) - 1.0;
    let resolution = view.viewport.zw;
    let t = globals.time * SPEED;
    uv.x *= resolution.x / resolution.y;
    uv *= rotate2D(NEG_HALF_PI);

    return vec4f(shader_toy_default(t, uv), 1.0);
}    
    
