#import bevy_pbr::mesh_view_bindings globals 
#import bevy_pbr::forward_io::VertexOutput

const TAU:f32 =  6.28318530718;

fn plot(st: vec2f, pct: f32) -> f32 {
    let l = pct - 0.02;
    let r = pct + 0.02;

    return smoothstep(l, pct, st.y) - smoothstep(pct, r, st.y);
}

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    // var uv = (in.uv * 2.0) - 1.0;
    var uv = in.uv;
    var col = vec3f(0.);
    uv *= fract(uv);

    let to_center = vec2(0.25) - uv;
    let angle = atan2(to_center.y, to_center.x);
    let radius = length(to_center) * 2.0;

    col = hsv_to_srgb(vec3f((angle / TAU) + globals.time / 3.0, radius, 1.0));

    let circ = circle(uv, 0.6);
    col *= circ;

    let pct = distance(uv, vec2f(0.5));

    return vec4f(col, 1.0);
}

fn circle(st: vec2f, rad: f32) -> f32 {
    let dist = st - vec2f(0.5);
    return 1.0 - smoothstep(rad - (rad * 0.01), rad + (rad * 0.01), dot(dist, dist) * 4.0);
}

// From the bevy source code
fn hsv_to_srgb(c: vec3<f32>) -> vec3<f32> {
    let K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    let p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, vec3(0.0), vec3(1.0)), c.y);
}

