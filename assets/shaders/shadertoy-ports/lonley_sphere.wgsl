// Author: bitless
// Title: A lonely sphere running over a field of voxels
// Ported from GLSL to WGSL for shadplay

#import bevy_sprite::mesh2d_view_bindings::globals 
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

fn h21(p: vec2f) -> f32 {
    return fract(sin(dot(p, vec2f(12.9898, 78.233))) * 43758.5453);
}

fn glsl_mod(x: f32, y: f32) -> f32 {
    return x - y * floor(x / y);
}

fn rot(a: f32) -> mat2x2f {
    let v = cos(a + vec4f(0.0, 11.0, 33.0, 0.0));
    return mat2x2f(vec2f(v.x, v.y), vec2f(v.z, v.w));
}

fn palette(t: f32, a: vec3f, b: vec3f, c: vec3f, d: vec3f) -> vec3f {
    return a + b * cos(6.28318 * (c * t + d));
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

fn hexToSqr(st: vec2f) -> vec3f {
    var r: vec3f;
    if (st.y > 0.0 - abs(st.x) * 0.57777) {
        if (st.x > 0.0) {
            r = vec3f((vec2f(st.x, (st.y + st.x / 1.73) * 0.86) * 2.0), 3.0);
        } else {
            r = vec3f(-(vec2f(st.x, -(st.y - st.x / 1.73) * 0.86) * 2.0), 2.0);
        }
    } else {
        r = vec3f(-(vec2f(st.x + st.y * 1.73, -st.x + st.y * 1.73)), 1.0);
    }
    return r;
}

fn toSqr(lc: vec2f) -> vec2f {
    return vec2f((lc.x + lc.y) * 0.5, (lc.x - lc.y) * 0.28902);
}

fn voxel(uv_in: vec2f, id: vec2f, lc: vec2f, sh: vec2f, C_in: vec4f, sp: vec2f, T: f32, sm: f32, iTime: f32) -> vec4f {
    var C = C_in;
    let ic = vec2f((uv_in.x + uv_in.y * 1.73), (uv_in.x - uv_in.y * 1.73));
    let uv = uv_in + sh * vec2f(-1.0, 0.28902);
    let ii = floor(vec2f((uv.x + uv.y * 1.73), (uv.x - uv.y * 1.73)));

    let th = mix(
        mix(1.0, noise(ii * 0.5) * 0.3, smoothstep(4.0, 1.0, abs(ii.x + 15.0 - noise(vec2f(ii.y * 0.1, 0.0)) * 15.0))),
        smoothstep(2.0, 4.0, length(ii + sp - vec2f(-0.5, T + 0.5))),
        smoothstep(2.0, -1.0, ii.y - T)
    );

    let s = pow(noise(h21(ii) * ii + vec2f(iTime * 0.5)), 8.0) * 0.75;
    let rot1_pos = rot(1.0) * (ii * 0.2) - vec2f(iTime * 0.02);
    var hg = (pow(noise(rot1_pos), 4.0) - 0.5) * 2.0 + s;

    hg = (hg + 1.0) * th - 1.0;
    let sz = 1.1 + s * 1.5 * th;

    var vx = hexToSqr(lc - vec2f(sh.x, (sh.y - (hg * 2.0 - 1.0) / sz) * 0.28902));
    let vx_xy = vx.xy * sz;
    vx = vec3f(vx_xy, vx.z);

    let pal_col = palette(ii.y * 0.05 + hg * 0.3 * th, vec3f(0.9), vec3f(0.7), vec3f(0.26), vec3f(0.0, 0.1, 0.2));
    let V = vec4f(pal_col, 1.0);

    var f = mix(0.3, (0.9 - vx.z * 0.15), smoothstep(0.45 + sm, 0.45 - sm, max(abs(vx.x - 0.5), abs(vx.y - 0.5))));
    f = mix(f, 1.0 - length(vx.xy - vec2f(0.6) * 1.2), smoothstep(0.4 + sm, 0.4 - sm, length(vx.xy - vec2f(0.5))));
    f = mix(f, 0.4, smoothstep(0.04 + sm, -sm, abs(length(vx.xy - vec2f(0.5)) - 0.4)));
    f -= f * smoothstep(5.0, 3.0, length(ic + sp - vec2f(-0.5, T + 0.5))) * 0.5;
    f += (hg + 1.0) * 0.07;

    C = mix(C, V * f, smoothstep(1.0 + sm, 1.0 - sm, max(vx.x, vx.y)));
    return C;
}

fn draw(uv_in: vec2f, C_in: vec4f, T: f32, sm_in: f32, iTime: f32) -> vec4f {
    var C = C_in;
    var sm = sm_in;
    let sp = vec2f((1.0 - noise(vec2f(T * 0.1, 0.0))) * 15.0, 0.0);

    var uv = uv_in;
    let st = vec2f((uv.x + uv.y * 1.73), (uv.x - uv.y * 1.73));
    let sc = toSqr(st + sp) - uv + vec2f(0.0, 2.0 + noise(vec2f(iTime * 5.0, 0.0)) * 0.2);
    var vc = uv;

    if (length(vc + sc) < 3.0) {
        vc += sc;
        vc += vc * pow(length(vc * 0.35), 4.0) - sc;
        sm += 0.07;
    }
    vc += toSqr(vec2f(0.0, T));

    let id = floor(vec2f((vc.x + vc.y * 1.73), (vc.x - vc.y * 1.73)));
    let n = glsl_mod(id.x + id.y + 1.0, 2.0);

    let st_corr = vec2f((1.0 - n) * 0.5 - vc.x, vc.y * 1.73 - n * 0.5);
    let id_corr = floor(st_corr) * vec2f(1.0, 2.0) + vec2f(n * 0.5, n);
    var lc = fract(st_corr) - vec2f(0.5);
    lc.y *= 0.57804;

    let sh = array<vec2f, 7>(
        vec2f(0.0, -2.0), vec2f(0.5, -1.0), vec2f(-0.5, -1.0),
        vec2f(0.0, 0.0), vec2f(0.5, 1.0), vec2f(-0.5, 1.0),
        vec2f(0.0, 2.0)
    );

    for (var i: i32 = 0; i < 7; i++) {
        C = voxel(vc, id_corr, lc, sh[i], C, sp, T, sm, iTime);
    }

    uv += sc;

    if (length(uv) < 3.0) {
        let rot_pos = rot(-T * 0.15) * vec2f(-uv.x, (uv.y + uv.x / 1.73) * 0.86) * 1.5;
        C = mix(C, vec4f(0.0, 0.05, 0.15, 1.0), noise(rot_pos) * 0.4);
        C += vec4f(smoothstep(3.0, -10.0, uv.y) * length(uv) * 0.1);
    }

    C = mix(C, vec4f(0.0), smoothstep(0.02 + sm, 0.02 - sm, abs(length(uv) - 3.0)) * 0.25);
    return C;
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let resolution = view.viewport.zw;
    let g = vec2f(in.uv.x, 1.0 - in.uv.y) * resolution;
    let iTime = globals.time;

    var uv = (g * 2.0 - resolution) / -resolution.y;
    uv += vec2f(-0.5);
    uv *= 1.0 + sin(iTime * 0.3) * 0.25;

    let sm = 3.0 / resolution.y;
    let T = -iTime * 4.0 - ((sin(iTime * 0.5) + 1.0) * 5.0);

    var C = vec4f(0.0);
    C = draw(uv * 5.0, C, T, sm, iTime);

    // Gamma correction
    C = pow(C, vec4f(1.0 / 1.4));

    // High contrast and rich saturation pop per user preference
    var rgb = clamp(C.rgb, vec3f(0.0), vec3f(1.0));
    rgb = pow(rgb, vec3f(1.35)) * 1.3;
    rgb = clamp(rgb, vec3f(0.0), vec3f(1.0));

    return vec4f(rgb, C.a);
}
