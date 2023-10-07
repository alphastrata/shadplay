#import bevy_pbr::mesh_view_bindings globals 
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_pbr::utils PI

#import bevy_render::view  View
@group(0) @binding(0) var<uniform> view: View;

const TAU:f32 =  6.28318530718;
const HEIGHT:f32 = 4.0;
const INTENSITY:f32 = 5.0;
const NUM_LINES:f32 = 4.0;
const SPEED:f32 = 1.0;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    var uv = (in.uv * 2.0) - 1.0;
    let resolution = view.viewport.zw;
    let t = globals.time * SPEED;
    uv.x *= resolution.x / resolution.y;

    var col = vec3f(0.0);
    col = shaderToyDefault(t, uv);

    return vec4<f32>(col, 1.0);
}

/// This is the default (and rather pretty) shader you start with in ShaderToy
fn shaderToyDefault(t: f32, uv: vec2f) -> vec3f {
    var col = vec3f(0.0);
    let v = vec3(t) + vec3(uv.xyx) + vec3(0., 2., 4.);
    return 0.5 + 0.5 * cos(v);
}
