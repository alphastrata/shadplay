#import bevy_pbr::mesh_view_bindings globals 
#import bevy_pbr::mesh_vertex_output MeshVertexOutput

const TAU:f32 =  6.28318530718;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    // let uv = in.uv;
    var uv = (in.uv * 2.0) - 1.0;
    var col = vec3f(0.);

    let distance_to_center = vec2(0.5) - uv;
    let angle = atan2(distance_to_center.y, distance_to_center.x);
    let radius = length(distance_to_center) * 2.0;

    col = hsv_to_srgb(vec3f((angle / TAU) + globals.time / 3.0, radius, 1.0));

    return vec4f(col, 1.0);
}

// From the bevy source code
fn hsv_to_srgb(c: vec3<f32>) -> vec3<f32> {
    let K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    let p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, vec3(0.0), vec3(1.0)), c.y);
}

