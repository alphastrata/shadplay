#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_sprite::mesh2d_view_bindings globals 
#import bevy_render::view View
#import bevy_pbr::utils PI

@group(0) @binding(0) var<uniform> view: View;

const SPEED:f32 = 1.0;
const TAU: f32 = 6.283185;
const HALF_PI:f32 =  1.57079632679;
const NEG_HALF_PI:f32 =  -1.57079632679;


// From #05 in the little-book-of-shaders https://thebookofshaders.com/05/
@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    let resolution: vec2f = view.viewport.xy;
    var uv = in.uv * -2.0 + 1.0; 
    var col = vec3f(0.0);

    let v = pow(mix(uv.y, uv.x, 0.5), -2.0);

    col = vec3f(v);

    return vec4f(col, 1.0);
}

fn plot(st: vec2f, pct: f32) -> f32 {
    let l = pct - 0.02;
    let r = pct + 0.02;

    return smoothstep(l, pct, st.y) - smoothstep(pct, r, st.y);
}
