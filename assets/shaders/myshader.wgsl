#import bevy_pbr::mesh_view_bindings globals view
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_pbr::utils PI HALF_PI
#import bevy_pbr::mesh_functions 

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    // return  vec4<f32>(0.0, 1.0, 0.0, 1.0);      // Green
    return  vec4<f32>(0.0, 0.0, 1.0, 1.0);  // Blue
    // return  vec4<f32>(1.0, 0.0, 0.0, 1.0);  // Red
}
