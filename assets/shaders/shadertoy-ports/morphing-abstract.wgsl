// Shader by Frostbyte
// Licensed under CC BY-NC-SA 4.0
// Ported from GLSL to WGSL for shadplay

#import bevy_sprite::mesh2d_view_bindings::globals 
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

const AA: i32 = 2;

// 2d rotation matrix
fn r(v: vec2f, t: f32) -> vec2f {
    let s = sin(t);
    let c = cos(t);
    return mat2x2f(vec2f(c, -s), vec2f(s, c)) * v;
}

// ACES tonemap: https://www.shadertoy.com/view/Xc3yzM
fn a(c: vec3f) -> vec3f {
    let m1 = mat3x3f(
        vec3f(0.59719, 0.07600, 0.02840),
        vec3f(0.35458, 0.90834, 0.13383),
        vec3f(0.04823, 0.01566, 0.83777)
    );
    let m2 = mat3x3f(
        vec3f(1.60475, -0.10208, -0.00327),
        vec3f(-0.53108, 1.10813, -0.07276),
        vec3f(-0.07367, -0.00605, 1.07602)
    );
    let v = m1 * c;
    let val_a = v * (v + vec3f(0.0245786)) - vec3f(0.000090537);
    let val_b = v * (0.983729 * v + vec3f(0.4329510)) + vec3f(0.238081);
    return m2 * (val_a / val_b);
}

// Xor's Dot Noise: https://www.shadertoy.com/view/wfsyRX
fn no(p: vec3f) -> f32 {
    let PHI: f32 = 1.618033988;
    let GOLD = mat3x3f(
        vec3f(-0.571464913, 0.814921382, 0.096597072),
        vec3f(-0.278044873, -0.303026659, 0.911518454),
        vec3f(0.772087367, 0.494042493, 0.399753815)
    );
    return dot(cos(GOLD * p), sin((PHI * p) * GOLD));
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let resolution = view.viewport.zw;
    let U = vec2f(in.uv.x, 1.0 - in.uv.y) * resolution;
    let t = globals.time;
    var color = vec3f(0.0);

    for (var m: i32 = 0; m < AA; m++) {
        for (var n: i32 = 0; n < AA; n++) {
            let off = (vec2f(f32(m), f32(n)) + 0.5) / f32(AA) - 0.5;
            let u = U + off;
            var p = vec3f(0.0, 0.0, -1.0 - 0.5 * sin(t * 0.1));
            let d = normalize(vec3f(2.0 * u - resolution, resolution.y));
            var l = vec3f(0.0);

            for (var i: f32 = 0.0; i < 10.0; i += 1.0) {
                var b = p;
                b = vec3f(r(sin(b.xy * 0.25), t * 0.5 + b.z * 2.0), b.z);
                var s = 0.001 + abs(no(b * 20.0) / 20.0 - no(b)) * 0.7;
                s += abs(p.y * 0.2 + sin(p.z * 2.0 + abs(p.x) * 0.5)) * 0.5;
                p += d * s;
                l += (1.0 + 1.5 * sin(vec3f(i + length(p.xy * 0.1) + 2.0) + vec3f(3.0, 1.5, 0.5))) / s;
            }
            color += a(l * l / 500.0);
        }
    }

    return vec4f(color / f32(AA * AA), 1.0);
}
