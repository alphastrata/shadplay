#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_sprite::mesh2d_view_bindings globals 
#import bevy_render::view View
#import bevy_pbr::utils PI

@group(0) @binding(0) var<uniform> view: View;

const SPEED:f32 = 1.0;
const TAU: f32 = 6.283185;
const HALF_PI:f32 =  1.57079632679;
const NEG_HALF_PI:f32 =  -1.57079632679;


@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    var fragColor: vec4<f32> = vec4<f32>(0.0080);
    var uv = (in.uv.xy * 2.0)- 1.0;
    return vec4f(0.228);
}

