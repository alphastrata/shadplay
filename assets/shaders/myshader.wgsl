// The time since startup data is in the globals binding which is part of the mesh_view_bindings import
#import bevy_pbr::mesh_view_bindings globals
#import bevy_pbr::mesh_vertex_output MeshVertexOutput

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    let speed = 2.0;

    // the globals have many things: their docs 
    let t_1 = sin(globals.time * speed) * 0.5 + 0.5;


    return vec4<f32>(100.0, 0.0, 200.0, 0.4 * t_1);
}