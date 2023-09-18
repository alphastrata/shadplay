#import bevy_pbr::mesh_view_bindings globals view
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_pbr::utils PI HALF_PI
#import bevy_pbr::mesh_functions 

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    var uv = in.uv;
    uv -= 0.5;

    let wp = in.world_position;
    
    return  vec4<f32>(uv.y, uv.x, 0.0, 1.0);
}
