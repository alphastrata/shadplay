#import bevy_pbr::mesh_view_bindings globals
#import bevy_pbr::mesh_vertex_output MeshVertexOutput

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {

    let t = globals.time;
    var uv = in.uv;

    let temp: vec3<f32> = uv.xyx + vec3<f32>(0.0, 2.0, 4.0);
    let cos_val: vec3<f32> = cos(globals.time + temp);
    let col: vec3<f32> = vec3<f32>(0.5) + vec3<f32>(0.5) * cos_val;

    return vec4<f32>(col, 1.0);
}


