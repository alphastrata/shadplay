/// ***************************** ///
/// THIS IS THE DEFAULT 2D SHADER ///
/// You can always get back to this with `python3 scripts/reset-2d.py` ///
/// ***************************** ///

#import bevy_sprite::mesh2d_view_bindings globals 
#import shadplay::shader_utils::common::{NEG_HALF_PI, shader_toy_default, rotate2D, TWO_PI}
#import bevy_render::view::View
#import bevy_pbr::forward_io::VertexOutput;

@group(0) @binding(0) var<uniform> view: View;

const SPEED:f32 = 1.0;
const NUM_ITER = 15.0;
const PI: f32 = 3.14159265359;
const TWO_PI: f32 = 6.28318530718;

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    // ensure our uv coords match shadertoy/the-lil-book-of-shaders
    var uv = (in.uv * 2.0) - 1.0;
    let resolution = view.viewport.zw;
    let t = globals.time * SPEED;
    uv.x *= resolution.x / resolution.y;
    uv *= rotate2D(NEG_HALF_PI);

    return spirals(uv, resolution, t);
}    

fn spirals(_uv: vec2f, resolution: vec2f, i_time: f32) -> vec4f {

    let PI: f32 = 3.14159265359;
    let TWO_PI: f32 = 6.28318530718;
    let NUM_ITER: f32 = 15.0;

    var uv: vec2<f32> = adjust_viewport(_uv, resolution);

    let c1: vec3<f32> = vec3<f32>(0.5, 0.5, 0.5);
    let c2: vec3<f32> = vec3<f32>(0.5, 0.5, 0.5);
    let c3: vec3<f32> = vec3<f32>(0.1, 0.1, 0.1);
    let c4: vec3<f32> = vec3<f32>(0.6, 0.7, 0.8);
    let t: f32 = i_time * 0.5;
    let mag: f32 = length(uv);
    uv *= 0.5;
    uv.y -= t * 0.1 + 100.0;
    var d: f32 = 0.0;
    var col: vec3<f32> = vec3<f32>(0.0, 0.0, 0.0);
    for (var i: f32 = 0.0; i < NUM_ITER; i += 1.0) {
        let h: f32 = i + 1.0;
        let ph: f32 = t + noise_overload_3(uv.y);
        let amp: f32 = pow(1.333, i);
        let fq: f32 = uv.y * TWO_PI * h;
        let sig: f32 = sin(fq + ph * h) * (0.333 / amp);
        d = uv.x + sig;
        d = abs(d);
        let gap: f32 = cos(fq * 0.4 + t);
        var a: f32 = abs(gap);
        a = pow(a, 5.0);
        d += a;
        let lum: f32 = scale(sin(ph * h), -1.0, 1.0, 0.003, 0.007) * (NUM_ITER * 0.25 / h);
        d = lum / abs(d);
        col += d * gradient(h + t, c1, c2, c3, c4);
    }
    col += mag * 0.125;

    return vec4<f32>(col, 1.0);
}

fn adjust_viewport(uv: vec2<f32>, r: vec2<f32>) -> vec2<f32> {
    if r.x < r.y {
        return (uv * 2.0 - r) / r.x;
    } else {
        return (uv * 2.0 - r) / r.y;
    }
}

fn rand(x: f32, s: i32) -> f32 {
    return fract(sin(x + f32(s)) * 43758.5453123);
}

fn rand_overload_1(x: f32) -> f32 {
    return rand(x, 0);
}

fn rand_overload_2(uv: vec2<f32>, seed: i32) -> f32 {
    return fract(sin(dot(uv.xy, vec2<f32>(12.9898, 78.233)) + f32(seed)) * 43758.5453123);
}

fn rand_overload_3(uv: vec2<f32>) -> f32 {
    return rand_overload_2(uv, 0);
}

fn noise(x: f32, s: i32) -> f32 {
    let xi = floor(x);
    let xf = fract(x);
    return mix(rand(xi, s), rand(xi + 1.0, s), smoothstep(0.0, 1.0, xf));
}

fn noise_overload_1(x: f32) -> f32 {
    return noise(x, 0);
}

fn noise_overload_2(p: vec2<f32>, s: i32) -> f32 {
    let pi = floor(p);
    let pf = fract(p);

    let bl = rand_overload_2(pi, s);
    let br = rand_overload_2(pi + vec2<f32>(1.0, 0.0), s);
    let tl = rand_overload_2(pi + vec2<f32>(0.0, 1.0), s);
    let tr = rand_overload_2(pi + vec2<f32>(1.0), s);

    let w = smoothstep(vec2<f32>(0.0), vec2<f32>(1.0), pf);

    let t = mix(tl, tr, w.x);
    let b = mix(bl, br, w.x);

    return mix(b, t, w.y);
}

fn noise_overload_3(p: vec2<f32>) -> f32 {
    return noise_overload_2(p, 0);
}

fn scale(x: f32, a: f32, b: f32, c: f32, d: f32) -> f32 {
    return (x - a) / (b - a) * (d - c) + c;
}

fn gradient(t: f32, a: vec3<f32>, b: vec3<f32>, c: vec3<f32>, d: vec3<f32>) -> vec3<f32> {
    return a + b * cos(TWO_PI * (c * t + d));
}
