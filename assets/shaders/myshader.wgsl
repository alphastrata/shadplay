#import bevy_pbr::mesh_view_bindings globals
#import bevy_pbr::mesh_vertex_output MeshVertexOutput

/// This is a cover/port of https://www.youtube.com/watch?v=KGJUl8Teipk&t=631s&ab_channel=TheArtofCode
// Note: it's missing the texel and mouse stuff because I've not made that available yet.
// Magics are (in the functions at least) kept basically as Martien had them, but those in main are adjusted somewhat to make more sense here.

const NUM_LAYERS = 5.0;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    var uv = in.uv;

    var col = vec3(0.0);

    var t = globals.time;

    let s = sin(t);
    let c = cos(t);
    let rot = mat2x2<f32>(c, -s, s, c);
    var st = uv*rot;

    var m = 0.0;
    for (var i = 0.0; i<1.0; i+= 1.0/NUM_LAYERS){
        let z = fract(t+i);
        let size = mix(118.0, 1.0, z);
        let fade = smoothstep(0.0, 0.6, z) * smoothstep(1.0, 0.4, z);

        m += fade *net_layer(st * size * z, i, t/2.0);
    }

    let glow = -uv.y * 2.0;
    var base_col = vec3(s, cos(t*0.4), -sin(t*.24))*0.4+6.0;
    col *= base_col*glow;
    uv = uv * 10.0;
    col = vec3(1.0)*net_layer(uv, 0.0, t);    

    uv = fract(uv);
    if (uv.x>.88 || uv.y>.96) {
        col = col + 0.80;
    }

    col = col -dot(uv, uv);

    // no mod in wgsl. //TODO: make a modulo we can use in all of these...
    col = col* smoothstep(0., 20., t) * smoothstep(24., 200., t);
    
    return vec4(col, 1.0);

}

fn n21(p: vec2<f32>) -> f32 {
    var a = fract(vec3(p.xyx) * vec3(213.897, 653.453, 253.098));
    a += dot(a, a.yzx + 79.76);
    return fract((a.x + a.y) * a.z);
}

fn get_pos(id: vec2<f32>, offs: vec2<f32>, t: f32) -> vec2<f32> {
    let n: f32 = n21(id + offs);
    let n1: f32 = fract(n * 10.0);
    let n2: f32 = fract(n * 100.0);
    let a: f32 = t + n;
    return offs + vec2(sin(a * n1), cos(a * n2)) * 0.4;
}

fn get_t(ro: vec2<f32>, rd: vec2<f32>, p: vec2<f32>) -> f32 {
    return dot(p - ro, rd);
}

fn line_dist(a: vec3<f32>, b: vec3<f32>, p: vec3<f32>) -> f32 {
    return length(cross(b - a, p - a)) / length(p - a);
}

fn df_line(a: vec2<f32>, b: vec2<f32>, p: vec2<f32>) -> f32 {
    let pa = p - a;
    let ba = b - a;
    let h: f32 = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    return length(pa - ba * h);
}

fn line(start: vec2<f32>, end: vec2<f32>, point: vec2<f32>) -> f32 {
    let radius_large: f32 = 0.04;
    let radius_small: f32 = 0.01;

    let distance: f32 = df_line(start, end, point);
    let distance_total: f32 = length(start - end);

    var fade: f32 = smoothstep(1.5, 0.5, distance_total);
    fade += smoothstep(0.05, 0.02, abs(distance_total - 0.75));

    return smoothstep(radius_large, radius_small, distance) * fade;
}

fn net_layer(st: vec2<f32>, n: f32, t: f32) -> f32 {
    let id: vec2<f32> = floor(st) + vec2<f32>(n, n);
    let st: vec2<f32> = fract(st) - vec2<f32>(0.5, 0.5);
    var p: array<vec2<f32>, 9> = array<vec2<f32>, 9>(
        get_pos(id, vec2<f32>(-1.0, -1.0), t),
        get_pos(id, vec2<f32>(0.0, -1.0), t),
        get_pos(id, vec2<f32>(1.0, -1.0), t),
        get_pos(id, vec2<f32>(-1.0, 0.0), t),
        get_pos(id, vec2<f32>(0.0, 0.0), t),
        get_pos(id, vec2<f32>(1.0, 0.0), t),
        get_pos(id, vec2<f32>(-1.0, 1.0), t),
        get_pos(id, vec2<f32>(0.0, 1.0), t),
        get_pos(id, vec2<f32>(1.0, 1.0), t)
    );
    var m: f32 = 0.0;
    var sparkle: f32 = 0.0;

    for (var i: i32 = 0; i < 9; i = i + 1) {
        m += line(p[4], p[i], st);
        let d: f32 = length(st - p[i]);
        var s: f32 = 0.005 / (d * d);
        s *= smoothstep(1.0, 0.7, d);
        var pulse: f32 = sin((fract(p[i].x) + fract(p[i].y) + t) * 5.0) * 0.4 + 0.6;
        pulse = pow(pulse, 20.0);
        s *= pulse;
        sparkle += s;
    }

    m += line(p[1], p[3], st);
    m += line(p[1], p[5], st);
    m += line(p[7], p[5], st);
    m += line(p[7], p[3], st);

    var s_phase: f32 = (sin(t + n) + sin(t * 0.1)) * 0.25 + 0.5;
    s_phase += pow(sin(t * 0.1) * 0.5 + 0.5, 50.0) * 5.0;
    m += sparkle * s_phase;
    
    return m;
}
