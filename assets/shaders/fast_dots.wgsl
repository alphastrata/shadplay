#import bevy_pbr::mesh_view_bindings globals
#import bevy_pbr::mesh_vertex_output MeshVertexOutput

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    let uv: vec2<f32> = in.uv;

    var m = 0.;
    let t = globals.time;

    var min_dist = 0.;

    for (var i = 0; i < 20; i += 1) {
        let n = N22(vec2(f32(i)));
        let p = sin(n*t);
        let d = length(uv - p);

        m += smoothstep(0.002, 0.001, d);

        if d < min_dist {
            min_dist = d;
        }
    }

    var col = vec3(m);
    return vec4(col, 1.0);
}

// Noise: two in -> two out
fn N22(pp: vec2<f32>)->vec2<f32>{
    var a = fract(pp.xyx*vec3(123.34, 234.34, 345.65));
    a += dot(a, a + 34.45);
    return fract(vec2(a.x*a.y, a.y*a.z));
}
