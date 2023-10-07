#import bevy_pbr::mesh_view_bindings globals 
#import bevy_pbr::mesh_vertex_output MeshVertexOutput

const TAU:f32 =  6.28318530718;
const HEIGHT:f32 = 4.0;
const INTENSITY:f32 = 5.0;
const NUM_LINES:f32 = 4.0;
const SPEED:f32 = 1.0;

// This is a port of Discoteq2 https://www.shadertoy.com/view/DtXfDr by 'supah' https://www.shadertoy.com/user/supah
@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    let uv = (in.uv * 2.0) - 1.0;
    var col = vec4f(0.0);

    return col;
}
