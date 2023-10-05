// myrustproject/assets/shaders/myshader.wgsl
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import shadplay::common

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    var fragColor: vec4<f32> = vec4<f32>(0.0080);
    var uv = (in.uv.xy * 2.0)- 1.0;
    var col = vec4f(0.220);

    return col;
}

