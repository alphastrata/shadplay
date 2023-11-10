#import bevy_sprite::mesh2d_view_bindings::globals 
#import shadplay::shader_utils::common::{NEG_HALF_PI, shader_toy_default, rotate2D, TWO_PI}
#import bevy_render::view::View
#import bevy_pbr::forward_io::VertexOutput;

@group(0) @binding(0) var<uniform> view: View;

const SPEED:f32 = 0.30;
const PI: f32 = 3.14159265359;
const TWO_PI = 6.2848;
const NUM_ITER = 8.0;

// This is a port of `light spirals` by `felipetovarhenao` on shadertoy. https://www.shadertoy.com/view/DlccR7
@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    var uv = (in.uv * 2.0) - 1.0;
    let resolution = view.viewport.zw;
    let t = globals.time * SPEED;
    uv.x *= resolution.x / resolution.y;

    //NOTE: we're not rotating, which allows us to remove the original's adjust_viewport
    return spirals(uv, resolution, t);
}    

// draw the 'spirals' 
fn spirals(_uv: vec2f, resolution: vec2f, t: f32) -> vec4f {
    var uv = _uv;
    // Something blank to paint onto!
    var col: vec3f = vec3(0.0, 0.0, 0.0);

    // Setup a colour palette:
    let c1: vec3f = vec3(0.5, 0.5, 0.5);
    let c2: vec3f = vec3(0.5, 0.5, 0.5);
    let c3: vec3f = vec3(0.1, 0.1, 0.1);
    let c4: vec3f = vec3(0.6, 0.7, 0.8);

    let mag: f32 = length(uv);

    // `d` is distance, we'll get multiple 'distances' that we're interested in using them as we override them in the loop.
    var d: f32 = 0.0;
    for (var i: f32 = 0.0; i < NUM_ITER; i += 1.0) {
        let h: f32 = i + 1.0;
        let ph: f32 = t + noise_overload_3(uv);
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

    return vec4<f32>(col, 1.0);
}

// Helpers:
fn rand(x: f32, s: i32) -> f32 {
    return fract(sin(x + f32(s)) * 43758.5453123);
}


//NOTE: wgsl doesn't support function overloading -- I know not whether or not there's a convention developing yet, so for now I've just enumerated them.
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
