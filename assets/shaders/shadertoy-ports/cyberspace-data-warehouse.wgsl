// Author: bitless
// Title: Cyberspace data warehouse
// Ported from GLSL to WGSL for shadplay

#import bevy_sprite::mesh2d_view_bindings::globals 
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

const BC: vec3f = vec3f(0.18, 0.44, 0.78);

fn h21(p: vec2f) -> f32 {
    return fract(sin(dot(p, vec2f(12.9898, 78.233))) * 43758.5453);
}

fn glsl_mod(x: f32, y: f32) -> f32 {
    return x - y * floor(x / y);
}

fn getHex(p: vec2f) -> vec4f {
    let s = vec2f(1.0, 1.7320508);
    let hC = floor(vec4f(p, p - vec2f(0.5, 1.0)) / s.xyxy) + vec4f(0.5);
    let h = vec4f(p - hC.xy * s, p - (hC.zw + vec2f(0.5)) * s);
    if (dot(h.xy, h.xy) < dot(h.zw, h.zw)) {
        return vec4f(h.xy, hC.xy);
    } else {
        return vec4f(h.zw, hC.zw + vec2f(0.5));
    }
}

fn noise(f_in: vec2f) -> f32 {
    let i = floor(f_in);
    let f = f_in - i;

    let u = f * f * (vec2f(3.0) - 2.0 * f);

    return mix(
        mix(h21(i + vec2f(0.0, 0.0)), h21(i + vec2f(1.0, 0.0)), u.x),
        mix(h21(i + vec2f(0.0, 1.0)), h21(i + vec2f(1.0, 1.0)), u.x),
        u.y
    );
}

struct HexToSqrResult {
    r: vec3f,
    uf: vec2f,
}

fn HexToSqr(st: vec2f) -> HexToSqrResult {
    var res: HexToSqrResult;
    res.uf = vec2f((st.x + st.y * 1.73), (st.x - st.y * 1.73)) - vec2f(0.5);
    if (st.y > 0.0 - abs(st.x) * 0.57777) {
        if (st.x > 0.0) {
            res.r = vec3f(fract(vec2f(-st.x, (st.y + st.x / 1.73) * 0.86) * 2.0), 2.0);
        } else {
            res.r = vec3f(fract(vec2f(st.x, (st.y - st.x / 1.73) * 0.86) * 2.0), 3.0);
        }
    } else {
        res.r = vec3f(fract(res.uf + vec2f(0.5)), 1.0);
    }
    return res;
}

fn sphere(hx: vec4f, st: vec2f, sm: f32, iTime: f32) -> vec4f {
    var R = vec4f(0.0);

    let T = glsl_mod(iTime + h21(hx.zw * 20.0) * 20.0, 20.0);

    var d: f32 = 0.0;
    if (T < 3.0) {
        d = 0.4 * sin(T * 0.52);
    } else if (T < 6.0) {
        d = 0.4;
    } else if (T < 9.0) {
        d = 0.4 * sin((9.0 - T) * 0.52);
    } else {
        d = 0.0;
    }

    var y: f32 = 0.0;
    if (T < 4.0) {
        y = 0.4 * sin((T - 1.0) * 0.52);
    } else if (T < 5.5) {
        y = 0.4;
    } else if (T < 8.5) {
        y = 0.4 * sin((8.5 - T) * 0.52);
    } else {
        y = 0.0;
    }
    y -= 0.06;

    var f = (0.9 + noise(vec2f(hx.x * 50.0 + iTime * 4.0, 0.0)) * 0.3) * smoothstep(-0.57, 1.7, st.y - st.x);

    R = mix(vec4f(0.0), vec4f(BC * f, 1.0), smoothstep(d + sm, d - sm, length(st)));
    R = mix(R, vec4f(BC * 0.5, 1.0), smoothstep(sm, -sm, abs(length(st) - d) - 0.02) * smoothstep(0.0, 0.02, d));

    f = noise(hx.xy * vec2f(12.0, 7.0) + vec2f(0.0, iTime * -4.0)) * 0.25 + 0.5;

    let top_mask = select(smoothstep(d - 0.02 + sm, d - 0.02 - sm, abs(length(st))), 1.0, (st.y - st.x) > 0.0);

    let sphere_col = vec4f(
        mix(vec3f(BC * 8.0) * f, vec3f(0.15, 0.1, 0.1), sin(T * 0.48 - 1.8))
        * (smoothstep(0.1, 0.2, length(hx.xy + vec2f(0.0, y))) * 0.5 + 0.5)
        * (smoothstep(-0.02, -0.52, hx.y)),
        1.0
    );

    let sphere_mask = smoothstep(0.2 + sm, 0.2 - sm, length(hx.xy + vec2f(0.0, y))) * top_mask;

    R = mix(R, sphere_col, sphere_mask);
    return R;
}

fn pixel(hh: f32, sm: f32, st_in: vec2f, s: vec2f, n: f32, R: vec4f, C_in: vec4f, iTime: f32) -> vec4f {
    var C = C_in;
    let st = vec2f(st_in.x, 1.0 - st_in.y);
    let lc = vec2f(1.0) - fract(st * 10.0);
    let id = floor(st * 10.0) + s;

    let b = ((4.0 - n) * 2.2 + 0.8) * 0.05;
    let th: f32 = 0.05;
    let T = glsl_mod(iTime + hh * 20.0, 20.0);

    var d: f32 = 0.0;
    if (T < 3.0) {
        d = sin(T * 0.52);
    } else if (T < 6.5) {
        d = 1.0;
    } else if (T < 9.5) {
        d = sin((9.5 - T) * 0.52);
    } else {
        d = 0.0;
    }

    let top_face_noise = select(1.0, smoothstep(d * 5.0, d * 5.0 + 2.0, length(id - vec2f(4.5)) + 0.5), n == 1.0);
    let noise_val = (pow(noise(id * hh * n + vec2f(iTime * (0.75 + h21(id) * 0.15))), 8.0) * 2.0
                    + (noise(id * 0.2 + vec2f(iTime * (0.5 + hh * n) * 0.5)) - 0.1))
                    * smoothstep(6.0, 2.0, length(id - vec2f(4.5)))
                    * top_face_noise;
    let f = min(noise_val, 0.95);

    let P = vec4f(BC * (1.0 + hh * 0.75) * b, 1.0);
    if (s.x == 0.0 && s.y == 0.0) {
        C = mix(P * 0.7, P * 0.9, step(0.0, lc.x - lc.y));
    }

    let m = s * 2.0 - vec2f(1.0);

    if (s.x != s.y) {
        let side_mix = mix(P * 0.7, P * 0.9, step(lc.x - lc.y, 0.0));
        let step_cond = select(step(1.0, lc.x - lc.y + 1.0), step(lc.x - lc.y + 1.0, 1.0), m.y == -1.0);
        C = mix(C, side_mix, step(lc.x + lc.y, f + f) * step_cond);
    }

    C = mix(C, P, smoothstep(f + sm * m.x, f - sm * m.x, lc.x) * smoothstep(f + sm * m.y, f - sm * m.y, lc.y));
    let color_refl = mix(P * (0.4 + (f + pow(f, 2.0)) * 4.0), R, 0.25);
    C = mix(C, color_refl, smoothstep(f - (th - sm) * m.x, f - (th + sm) * m.x, lc.x) * smoothstep(f - (th + sm) * m.y, f - (th + sm) * m.y, lc.y));

    return C;
}

fn tile(uv: vec2f, iTime: f32, resolution_y: f32) -> vec4f {
    let hx = getHex(uv);
    let sqr_res = HexToSqr(hx.xy);
    let s = sqr_res.uf;
    let sqr = sqr_res.r;

    let n = sqr.z;
    let sm = 3.0 / resolution_y;
    let hh = h21(hx.zw * 20.0);

    let st = sqr.xy;

    var R = vec4f(0.0);
    if (n == 1.0) {
        R = sphere(hx, st - vec2f(0.5), sm, iTime);
    } else if (n == 2.0) {
        R = sphere(hx + vec4f(0.0, -0.6, 0.5, 0.5), s + vec2f(0.0, 1.0), 0.01, iTime);
    } else {
        R = sphere(hx + vec4f(0.0, -0.6, -0.5, 0.5), s + vec2f(0.0, 1.0), 0.01, iTime);
    }

    var C = vec4f(0.0);
    C = pixel(hh, sm, st, vec2f(0.0, 0.0), n, R, C, iTime);
    C = pixel(hh, sm, st, vec2f(1.0, 0.0), n, R, C, iTime);
    C = pixel(hh, sm, st, vec2f(0.0, 1.0), n, R, C, iTime);
    C = pixel(hh, sm, st, vec2f(1.0, 1.0), n, R, C, iTime);

    if (n == 1.0) {
        C = mix(C, R, vec4f(R.a));
    }
    return C;
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let resolution = view.viewport.zw;
    let g = vec2f(in.uv.x, 1.0 - in.uv.y) * resolution;
    let iTime = globals.time;

    var uv = (g * 2.0 - resolution) / -resolution.y;

    uv *= 0.8 + sin(iTime * 0.3) * 0.25;
    uv -= uv * pow(length(uv), 2.5 - sin(iTime * 0.3) * 0.5) * 0.025 + vec2f(iTime * 0.2, cos(iTime * 0.2));

    let C = tile(uv, iTime, resolution.y);
    // Contrast & electric blue saturation boost
    var rgb = pow(clamp(C.rgb, vec3f(0.0), vec3f(1.0)), vec3f(1.4)) * 1.35;
    rgb = clamp(rgb, vec3f(0.0), vec3f(1.0));
    return vec4f(rgb, C.a);
}
