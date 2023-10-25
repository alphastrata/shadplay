#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_sprite::mesh2d_view_bindings globals 


/// This is a cover/port of https://www.youtube.com/watch?v=KGJUl8Teipk&t=631s&ab_channel=TheArtofCode
// Note: it's missing the texel and mouse stuff because I've not made that available yet.
// Magics are (in the functions at least) kept basically as Martien had them, but those in main are adjusted somewhat to make more sense here.
const NUM_LAYERS: f32 = 5.0;
const SPEED: f32 = 1.0;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    var uv = (in.uv * 2.0) - 1.0;
    let resolution = view.viewport.zw;
    let t = globals.time * SPEED;
    uv.x *= resolution.x / resolution.y;

    var col = vec3f(0.0);
    col = shader_toy_default(t, uv);

    return vec4<f32>(col, 1.0);
}

/// This is the default (and rather pretty) shader you start with in ShaderToy
fn shader_toy_default(t: f32, uv: vec2f) -> vec3f {
    var col = vec3f(0.0);
    let v = vec3(t) + vec3(uv.xyx) + vec3(0., 2., 4.);
    return 0.5 + 0.5 * cos(v);
}


