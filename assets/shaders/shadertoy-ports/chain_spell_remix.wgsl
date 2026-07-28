// Magic Spells & Trapped Storm Sphere (Chains Removed)
// By Leon (2017) - Ported from GLSL to WGSL for shadplay

#import bevy_sprite::mesh2d_view_bindings::globals 
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

const PI: f32 = 3.14159265359;
const TAU: f32 = 6.28318530718;
const STEPS: f32 = 30.0;
const BIAS: f32 = 0.001;
const DIST_MIN: f32 = 0.01;

fn rot(a: f32) -> mat2x2f {
    let c = cos(a);
    let s = sin(a);
    return mat2x2f(vec2f(c, -s), vec2f(s, c));
}

fn glsl_mod(x: f32, y: f32) -> f32 {
    return x - y * floor(x / y);
}

fn sdSphere(p: vec3f, r: f32) -> f32 {
    return length(p) - r;
}

fn sdCylinder(p: vec2f, r: f32) -> f32 {
    return length(p) - r;
}

fn sdTorus(p: vec3f, s: vec2f) -> f32 {
    let q = vec2f(length(p.xz) - s.x, p.y);
    return length(q) - s.y;
}

fn sdBox(p: vec3f, b: vec3f) -> f32 {
    let d = abs(p) - b;
    return min(max(d.x, max(d.y, d.z)), 0.0) + length(max(d, vec3f(0.0)));
}

fn smin(a: f32, b: f32, r: f32) -> f32 {
    let h = clamp(0.5 + 0.5 * (b - a) / r, 0.0, 1.0);
    return mix(b, a, h) - r * h * (1.0 - h);
}

fn rand2(co: vec2f) -> f32 {
    return fract(sin(dot(co * 0.123, vec2f(12.9898, 78.233))) * 43758.5453);
}

fn moda(p: vec2f, count: f32) -> vec3f {
    let an = TAU / count;
    let a_orig = atan2(p.y, p.x) + an / 2.0;
    let c = floor(a_orig / an);
    let a = glsl_mod(a_orig, an) - an / 2.0;
    return vec3f(vec2f(cos(a), sin(a)) * length(p), c);
}

fn getLocalWave(x: f32, t: f32) -> f32 {
    return sin(-t + x * 3.0);
}

fn mapSpell(p_in: vec3f, t: f32) -> f32 {
    var p = p_in;
    var scene: f32 = 1.0;
    let a = atan2(p.z, p.x);
    let l = length(p);
    let lw = getLocalWave(a, t);

    // Warping space into cylinder
    p.z = l - 1.0 + 0.1 * lw;

    // Torsade effect
    let p_yz = rot(t + a * 2.0) * p.yz;
    p = vec3f(p.x, p_yz.x, p_yz.y);

    // Long cube shape
    scene = min(scene, sdBox(p, vec3f(10.0, 0.25 - 0.1 * lw, 0.25 - 0.1 * lw)));

    // Long cylinder cutting the box
    scene = max(scene, -sdCylinder(p.zy, 0.3 - 0.2 * lw));
    return scene;
}

fn posCore(p_in: vec3f, count: f32) -> vec3f {
    var p = p_in;
    let m = moda(p.xz, count);
    p = vec3f(m.x, p.y, m.y);

    let c: f32 = 0.2;
    p.x = glsl_mod(p.x, c) - c / 2.0;
    return p;
}

fn mapCore(p_in: vec3f, t: f32) -> f32 {
    var p = p_in;
    var scene: f32 = 1.0;
    let count: f32 = 10.0;

    // Displace space
    let r1 = rot(p.y * 6.0) * p.xz;
    p = vec3f(r1.x, p.y, r1.y);
    let r2 = rot(t) * p.xz;
    p = vec3f(r2.x, p.y, r2.y);
    let r3 = rot(t * 0.5) * p.xy;
    p = vec3f(r3.x, r3.y, p.z);
    let r4 = rot(t * 1.5) * p.yz;
    p = vec3f(p.x, r4.x, r4.y);

    let p1 = posCore(p, count);
    let size = vec2f(0.1, 0.2);

    // Tentacles torus shape
    scene = min(scene, sdTorus(p1.xzy * 1.5, size));

    // Sphere used for intersection difference with the toruses
    scene = max(-scene, sdSphere(p, 0.6));
    return scene;
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let resolution = view.viewport.zw;
    let coord = vec2f(in.uv.x, 1.0 - in.uv.y) * resolution;
    let iTime = globals.time;

    let uv = (coord - 0.5 * resolution) / resolution.y;
    let eye = vec3f(0.0, 2.2, 0.001);
    let fwd = normalize(-eye);
    let rgt = normalize(cross(vec3f(0.0, 0.0, 1.0), fwd));
    let upv = cross(fwd, rgt);
    let ray = normalize(fwd + rgt * uv.x + upv * uv.y);
    var pos = eye + rgt * uv.x * 1.5 + upv * uv.y * 1.5;

    let dpos = coord / resolution;
    let seed = dpos + vec2f(fract(iTime));

    var shade: f32 = 0.0;

    for (var i: f32 = 0.0; i < STEPS; i += 1.0) {
        let distSpell = min(mapSpell(pos, iTime), mapCore(pos, iTime));
        var dist = distSpell;

        if (dist < 0.001) {
            shade += 0.35;
        }

        dist = abs(dist) * (0.85 + 0.3 * rand2(seed * vec2f(i)));
        dist = max(0.018, dist);
        pos += ray * dist;
    }

    let n_shade = clamp(shade / (STEPS - 1.0), 0.0, 1.0);

    // High-contrast airy silver-grey sand particles on pitch-black background
    let greyScale = pow(n_shade, 1.1);
    var rgb = vec3f(0.85, 0.87, 0.9) * greyScale * 2.8;
    rgb = pow(clamp(rgb, vec3f(0.0), vec3f(1.0)), vec3f(1.85)) * 1.6;
    rgb = clamp(rgb, vec3f(0.0), vec3f(1.0));

    return vec4f(rgb, 1.0);
}
