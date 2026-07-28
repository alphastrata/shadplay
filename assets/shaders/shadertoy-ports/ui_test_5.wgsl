// 3D Sci-Fi HUD Interface & Ring Gyroscope
// Ported from GLSL to WGSL for shadplay

#import bevy_sprite::mesh2d_view_bindings::globals 
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

const MAX_STEPS: i32 = 64;

fn rot(a: f32) -> mat2x2f {
    let c = cos(a);
    let s = sin(a);
    return mat2x2f(vec2f(c, -s), vec2f(s, c));
}

fn glsl_mod(x: f32, y: f32) -> f32 {
    return x - y * floor(x / y);
}

fn glsl_mod2(p: vec2f, y: f32) -> vec2f {
    return p - y * floor(p / y);
}

fn antialiasing(n: f32, res: vec2f) -> f32 {
    return n / min(res.y, res.x);
}

fn S(d: f32, b: f32, res: vec2f) -> f32 {
    return smoothstep(antialiasing(1.0, res), b, d);
}

fn B(p: vec2f, s: vec2f) -> f32 {
    return max(abs(p.x) - s.x, abs(p.y) - s.y);
}

fn Tri(p: vec2f, s: vec2f, a: f32) -> f32 {
    let d1 = -dot(p, vec2f(cos(-a), sin(-a)));
    let d2 = dot(p, vec2f(cos(a), sin(a)));
    let d3 = max(abs(p.x) - s.x, abs(p.y) - s.y);
    return max(d1, max(d2, d3));
}

fn DF(a_in: vec2f, b: f32) -> vec2f {
    let angle = atan2(a_in.y, a_in.x);
    let step1 = 6.2831853 / (b * 8.0);
    let step2 = 6.2831853 / ((b * 8.0) * 0.5);
    let m = glsl_mod(angle + step1, step2) + (b - 1.0) * step1;
    let cos_v = cos(vec2f(m, m + 11.0));
    return length(a_in) * cos_v;
}

fn SkewX(a: f32) -> mat2x2f {
    return mat2x2f(vec2f(1.0, tan(a)), vec2f(0.0, 1.0));
}

fn Hash21(p_in: vec2f) -> f32 {
    var p = fract(p_in * vec2f(234.56, 789.34));
    p += vec2f(dot(p, p + vec2f(34.56)));
    return fract(p.x + p.y);
}

fn cubicInOut(t: f32) -> f32 {
    if (t < 0.5) {
        return 4.0 * t * t * t;
    } else {
        return 0.5 * pow(2.0 * t - 2.0, 3.0) + 1.0;
    }
}

fn getTime(t: f32, duration: f32) -> f32 {
    return clamp(t, 0.0, duration) / duration;
}

fn segBase(p_in: vec2f) -> f32 {
    var p = p_in;
    let prevP = p;

    let padding: f32 = 0.05;
    let w = padding * 3.0;
    let h = padding * 5.0;

    p = glsl_mod2(p, 0.05) - vec2f(0.025);
    let thickness: f32 = 0.005;
    let gridMask = min(abs(p.x) - thickness, abs(p.y) - thickness);

    p = prevP;
    var d = B(p, vec2f(w * 0.5, h * 0.5));
    let a = radians(45.0);
    p.x = abs(p.x) - 0.1;
    p.y = abs(p.y) - 0.05;
    let d2 = dot(p, vec2f(cos(a), sin(a)));
    d = max(d2, d);
    d = max(-gridMask, d);
    return d;
}

fn seg0(p: vec2f) -> f32 {
    var d = segBase(p);
    let size: f32 = 0.03;
    let mask = B(p, vec2f(size, size * 2.7));
    d = max(-mask, d);
    return d;
}

fn seg1(p_in: vec2f) -> f32 {
    var p = p_in;
    let prevP = p;
    var d = segBase(p);
    let size: f32 = 0.03;
    p.x += size;
    p.y += size;
    var mask = B(p, vec2f(size * 2.0, size * 3.7));
    d = max(-mask, d);

    p = prevP;
    p.x += size * 1.8;
    p.y -= size * 3.5;
    mask = B(p, vec2f(size));
    d = max(-mask, d);

    return d;
}

fn seg2(p_in: vec2f) -> f32 {
    var p = p_in;
    let prevP = p;
    var d = segBase(p);
    let size: f32 = 0.03;
    p.x += size;
    p.y -= 0.05;
    var mask = B(p, vec2f(size * 2.0, size));
    d = max(-mask, d);

    p = prevP;
    p.x -= size;
    p.y += 0.05;
    mask = B(p, vec2f(size * 2.0, size));
    d = max(-mask, d);

    return d;
}

fn seg3(p_in: vec2f) -> f32 {
    var p = p_in;
    let prevP = p;
    var d = segBase(p);
    let size: f32 = 0.03;
    p.y = abs(p.y);
    p.x += size;
    p.y -= 0.05;
    var mask = B(p, vec2f(size * 2.0, size));
    d = max(-mask, d);

    p = prevP;
    p.x += 0.05;
    mask = B(p, vec2f(size, size));
    d = max(-mask, d);

    return d;
}

fn seg4(p_in: vec2f) -> f32 {
    var p = p_in;
    let prevP = p;
    var d = segBase(p);
    let size: f32 = 0.03;

    p.x += size;
    p.y += 0.08;
    var mask = B(p, vec2f(size * 2.0, size * 2.0));
    d = max(-mask, d);

    p = prevP;
    p.y -= 0.08;
    mask = B(p, vec2f(size, size * 2.0));
    d = max(-mask, d);

    return d;
}

fn seg5(p_in: vec2f) -> f32 {
    var p = p_in;
    let prevP = p;
    var d = segBase(p);
    let size: f32 = 0.03;
    p.x -= size;
    p.y -= 0.05;
    var mask = B(p, vec2f(size * 2.0, size));
    d = max(-mask, d);

    p = prevP;
    p.x += size;
    p.y += 0.05;
    mask = B(p, vec2f(size * 2.0, size));
    d = max(-mask, d);

    return d;
}

fn seg6(p_in: vec2f) -> f32 {
    var p = p_in;
    let prevP = p;
    var d = segBase(p);
    let size: f32 = 0.03;
    p.x -= size;
    p.y -= 0.05;
    var mask = B(p, vec2f(size * 2.0, size));
    d = max(-mask, d);

    p = prevP;
    p.y += 0.05;
    mask = B(p, vec2f(size, size));
    d = max(-mask, d);

    return d;
}

fn seg7(p_in: vec2f) -> f32 {
    var p = p_in;
    var d = segBase(p);
    let size: f32 = 0.03;
    p.x += size;
    p.y += size;
    let mask = B(p, vec2f(size * 2.0, size * 3.7));
    d = max(-mask, d);
    return d;
}

fn seg8(p_in: vec2f) -> f32 {
    var p = p_in;
    var d = segBase(p);
    let size: f32 = 0.03;
    p.y = abs(p.y);
    p.y -= 0.05;
    let mask = B(p, vec2f(size, size));
    d = max(-mask, d);
    return d;
}

fn seg9(p_in: vec2f) -> f32 {
    var p = p_in;
    let prevP = p;
    var d = segBase(p);
    let size: f32 = 0.03;
    p.y -= 0.05;
    var mask = B(p, vec2f(size, size));
    d = max(-mask, d);

    p = prevP;
    p.x += size;
    p.y += 0.05;
    mask = B(p, vec2f(size * 2.0, size));
    d = max(-mask, d);

    return d;
}

fn segDecimalPoint(p_in: vec2f) -> f32 {
    var p = p_in;
    var d = segBase(p);
    let size: f32 = 0.028;
    p.y += 0.1;
    let mask = B(p, vec2f(size, size));
    d = max(mask, d);
    return d;
}

fn drawFont(p_in: vec2f, char: i32) -> f32 {
    let p = p_in * 2.0;
    var d: f32 = 10.0;
    if (char == 0) { d = seg0(p); }
    else if (char == 1) { d = seg1(p); }
    else if (char == 2) { d = seg2(p); }
    else if (char == 3) { d = seg3(p); }
    else if (char == 4) { d = seg4(p); }
    else if (char == 5) { d = seg5(p); }
    else if (char == 6) { d = seg6(p); }
    else if (char == 7) { d = seg7(p); }
    else if (char == 8) { d = seg8(p); }
    else if (char == 9) { d = seg9(p); }
    else if (char == 39) { d = segDecimalPoint(p); }
    return d;
}

fn ring0(p_in: vec2f, iTime: f32) -> f32 {
    var p = p_in;
    let prevP = p;
    p = rot(radians(-iTime * 30.0 + 50.0)) * p;
    p = DF(p, 16.0);
    p -= vec2f(0.35);
    var d = B(rot(radians(45.0)) * p, vec2f(0.005, 0.03));

    p = prevP;
    p = rot(radians(-iTime * 30.0 + 50.0)) * p;
    let deg: f32 = 165.0;
    var a = radians(deg);
    d = max(dot(p, vec2f(cos(a), sin(a))), d);
    a = radians(-deg);
    d = max(dot(p, vec2f(cos(a), sin(a))), d);

    p = prevP;
    p = rot(radians(iTime * 30.0 + 30.0)) * p;
    var d2 = abs(length(p) - 0.55) - 0.015;
    d2 = max(-(abs(p.x) - 0.4), d2);
    d = min(d, d2);

    p = prevP;
    d2 = abs(length(p) - 0.55) - 0.001;
    d = min(d, d2);

    p = prevP;
    p = rot(radians(-iTime * 50.0 + 30.0)) * p;
    p += sin(p * 25.0 - vec2f(radians(iTime * 80.0))) * 0.01;
    d2 = abs(length(p) - 0.65) - 0.0001;
    d = min(d, d2);

    p = prevP;
    a = radians(-sin(iTime * 1.2)) * 120.0 - radians(70.0);
    p.x += cos(a) * 0.58;
    p.y += sin(a) * 0.58;

    d2 = abs(Tri(rot(radians(90.0)) * (rot(-a) * p), vec2f(0.03), radians(45.0))) - 0.003;
    d = min(d, d2);

    p = prevP;
    a = radians(sin(iTime * 1.3)) * 100.0 - radians(10.0);
    p.x += cos(a) * 0.58;
    p.y += sin(a) * 0.58;

    d2 = abs(Tri(rot(radians(90.0)) * (rot(-a) * p), vec2f(0.03), radians(45.0))) - 0.003;
    d = min(d, d2);

    return d;
}

fn ring1(p_in: vec2f, iTime: f32) -> f32 {
    var p = p_in;
    let prevP = p;
    let size: f32 = 0.45;
    let deg: f32 = 140.0;
    let thickness: f32 = 0.02;
    var d = abs(length(p) - size) - thickness;

    p = rot(radians(iTime * 60.0)) * p;
    var a = radians(deg);
    d = max(dot(p, vec2f(cos(a), sin(a))), d);
    a = radians(-deg);
    d = max(dot(p, vec2f(cos(a), sin(a))), d);

    p = prevP;
    let d2 = abs(length(p) - size) - 0.001;
    return min(d, d2);
}

fn ring2(p_in: vec2f, iTime: f32) -> f32 {
    var p = p_in;
    let size: f32 = 0.3;
    let deg: f32 = 120.0;
    let thickness: f32 = 0.02;

    p = rot(-radians(sin(iTime * 2.0) * 90.0)) * p;
    var d = abs(length(p) - size) - thickness;
    var a = radians(-deg);
    d = max(dot(p, vec2f(cos(a), sin(a))), d);
    a = radians(deg);
    d = max(dot(p, vec2f(cos(a), sin(a))), d);

    var d2 = abs(length(p) - size) - thickness;
    a = radians(-deg);
    d2 = max(-dot(p, vec2f(cos(a), sin(a))), d2);
    a = radians(deg);
    d2 = max(-dot(p, vec2f(cos(a), sin(a))), d2);

    return min(d, d2);
}

fn ring3(p_in: vec2f, iTime: f32) -> f32 {
    var p = rot(radians(-iTime * 80.0 - 120.0)) * p_in;
    let prevP = p;
    let deg: f32 = 140.0;

    p = DF(p, 6.0);
    p -= vec2f(0.3);
    var d = abs(B(rot(radians(45.0)) * p, vec2f(0.03, 0.025))) - 0.003;

    p = prevP;
    var a = radians(-deg);
    d = max(dot(p, vec2f(cos(a), sin(a))), d);
    a = radians(deg);
    d = max(dot(p, vec2f(cos(a), sin(a))), d);

    p = prevP;
    p = DF(p, 6.0);
    p -= vec2f(0.3);
    var d2 = abs(B(rot(radians(45.0)) * p, vec2f(0.03, 0.025))) - 0.003;

    p = prevP;
    a = radians(-deg);
    d2 = max(-dot(p, vec2f(cos(a), sin(a))), d2);
    a = radians(deg);
    d2 = max(-dot(p, vec2f(cos(a), sin(a))), d2);

    return min(d, d2);
}

fn ring4(p_in: vec2f, iTime: f32) -> f32 {
    var p = rot(radians(iTime * 75.0 - 220.0)) * p_in;
    let deg: f32 = 20.0;

    var d = abs(length(p) - 0.25) - 0.01;

    p = DF(p, 2.0);
    p -= vec2f(0.1);

    var a = radians(-deg);
    d = max(-dot(p, vec2f(cos(a), sin(a))), d);
    a = radians(deg);
    d = max(-dot(p, vec2f(cos(a), sin(a))), d);

    return d;
}

fn ring5(p_in: vec2f, iTime: f32) -> f32 {
    var p = rot(radians(-iTime * 70.0 + 170.0)) * p_in;
    let prevP = p;
    let deg: f32 = 150.0;

    var d = abs(length(p) - 0.16) - 0.02;

    var a = radians(-deg);
    d = max(dot(p, vec2f(cos(a), sin(a))), d);
    a = radians(deg);
    d = max(dot(p, vec2f(cos(a), sin(a))), d);

    p = prevP;
    p = rot(radians(-30.0)) * p;
    var d2 = abs(length(p) - 0.136) - 0.02;

    let deg2: f32 = 60.0;
    a = radians(-deg2);
    d2 = max(-dot(p, vec2f(cos(a), sin(a))), d2);
    a = radians(deg2);
    d2 = max(-dot(p, vec2f(cos(a), sin(a))), d2);

    d = min(d, d2);
    return d;
}

fn ring6(p_in: vec2f, iTime: f32) -> f32 {
    var p = p_in;
    let prevP = p;
    p = rot(radians(iTime * 72.0 + 110.0)) * p;

    var d = abs(length(p) - 0.95) - 0.001;
    d = max(-(abs(p.x) - 0.4), d);
    d = max(-(abs(p.y) - 0.4), d);

    p = prevP;
    p = rot(radians(-iTime * 30.0 + 50.0)) * p;
    p = DF(p, 16.0);
    p -= vec2f(0.6);
    var d2 = B(rot(radians(45.0)) * p, vec2f(0.02, 0.03));

    p = prevP;
    p = rot(radians(-iTime * 30.0 + 50.0)) * p;
    let deg: f32 = 155.0;
    var a = radians(deg);
    d2 = max(-dot(p, vec2f(cos(a), sin(a))), d2);
    a = radians(-deg);
    d2 = max(-dot(p, vec2f(cos(a), sin(a))), d2);

    return min(d, d2);
}

fn bg(p_in: vec2f, iTime: f32) -> f32 {
    var p = p_in;
    p.y -= iTime * 0.1;
    let prevP = p;

    p *= 2.8;
    var gv = fract(p) - vec2f(0.5);
    let gv2 = fract(p * 3.0) - vec2f(0.5);
    let id = floor(p);

    var d = min(B(gv2, vec2f(0.02, 0.09)), B(gv2, vec2f(0.09, 0.02)));

    let n = Hash21(id);
    gv += vec2f(0.166, 0.17);
    var d2 = abs(B(gv, vec2f(0.169))) - 0.004;

    if (n < 0.3) {
        gv = rot(radians(iTime * 60.0)) * gv;
        d2 = max(-(abs(gv.x) - 0.08), d2);
        d2 = max(-(abs(gv.y) - 0.08), d2);
        d = min(d, d2);
    } else if (n >= 0.3 && n < 0.6) {
        gv = rot(radians(-iTime * 60.0)) * gv;
        d2 = max(-(abs(gv.x) - 0.08), d2);
        d2 = max(-(abs(gv.y) - 0.08), d2);
        d = min(d, d2);
    } else if (n >= 0.6 && n < 1.0) {
        gv = rot(radians(iTime * 60.0) + n) * gv;
        d2 = abs(length(gv) - 0.1) - 0.025;
        d2 = max(-(abs(gv.x) - 0.03), d2);
        d = min(d, abs(d2) - 0.003);
    }

    p = prevP;
    p = glsl_mod2(p, 0.02) - vec2f(0.01);
    d2 = B(p, vec2f(0.001));
    d = min(d, d2);

    return d;
}

fn numberWithCircleUI(p_in: vec2f, iTime: f32) -> f32 {
    var p = p_in;
    let prevP = p;

    p = SkewX(radians(-15.0)) * p;
    var num = i32(glsl_mod(iTime * 6.0, 10.0));
    var d = drawFont(p - vec2f(-0.16, 0.0), num);
    num = i32(glsl_mod(iTime * 3.0, 10.0));
    var d2 = drawFont(p - vec2f(-0.08, 0.0), num);
    d = min(d, d2);
    d2 = drawFont(p - vec2f(-0.02, 0.0), 39);
    d = min(d, d2);

    p *= 1.5;
    num = i32(glsl_mod(iTime * 10.0, 10.0));
    d2 = drawFont(p - vec2f(0.04, -0.03), num);
    d = min(d, d2);
    num = i32(glsl_mod(iTime * 15.0, 10.0));
    d2 = drawFont(p - vec2f(0.12, -0.03), num);
    d = abs(min(d, d2)) - 0.002;

    p = prevP;

    p.x -= 0.07;
    p = rot(radians(-iTime * 50.0)) * p;
    p = DF(p, 4.0);
    p -= vec2f(0.085);
    d2 = B(rot(radians(45.0)) * p, vec2f(0.015, 0.018));
    p = prevP;
    d2 = max(-B(p, vec2f(0.13, 0.07)), d2);
    d = min(d, abs(d2) - 0.0005);

    return d;
}

fn blockUI(p_in: vec2f, iTime: f32) -> f32 {
    var p = p_in;
    let prevP = p;
    p.x += iTime * 0.05;
    p.y = abs(p.y) - 0.02;
    p.x = glsl_mod(p.x, 0.04) - 0.02;
    var d = B(p, vec2f(0.0085));
    p = prevP;
    p.x += iTime * 0.05 + 0.02;
    p.x = glsl_mod(p.x, 0.04) - 0.02;
    let d2 = B(p, vec2f(0.0085));
    d = min(d, d2);
    p = prevP;
    d = max((abs(p.x) - 0.2), d);
    return abs(d) - 0.0002;
}

fn smallCircleUI(p_in: vec2f, iTime: f32) -> f32 {
    var p = p_in * 1.1;
    let prevP = p;

    let deg: f32 = 20.0;

    p = rot(radians(sin(iTime * 3.0) * 50.0)) * p;
    var d = abs(length(p) - 0.1) - 0.003;

    p = DF(p, 0.75);
    p -= vec2f(0.02);

    var a = radians(-deg);
    d = max(-dot(p, vec2f(cos(a), sin(a))), d);
    a = radians(deg);
    d = max(-dot(p, vec2f(cos(a), sin(a))), d);

    p = prevP;
    p = rot(radians(-sin(iTime * 2.0) * 80.0)) * p;
    var d2 = abs(length(p) - 0.08) - 0.001;
    d2 = max(-p.x, d2);
    d = min(d, d2);

    p = prevP;
    p = rot(radians(-iTime * 50.0)) * p;
    d2 = abs(length(p) - 0.05) - 0.015;
    let deg2: f32 = 170.0;
    a = radians(deg2);
    d2 = max(-dot(p, vec2f(cos(a), sin(a))), d2);
    a = radians(-deg2);
    d2 = max(-dot(p, vec2f(cos(a), sin(a))), d2);
    d = min(d, abs(d2) - 0.0005);

    return d;
}

fn smallCircleUI2(p_in: vec2f, iTime: f32) -> f32 {
    var p = p_in;
    var d = abs(length(p) - 0.04) - 0.0001;
    var d2 = length(p) - 0.03;

    p = rot(radians(iTime * 30.0)) * p;
    let deg: f32 = 140.0;
    var a = radians(deg);
    d2 = max(-dot(p, vec2f(cos(a), sin(a))), d2);
    a = radians(-deg);
    d2 = max(-dot(p, vec2f(cos(a), sin(a))), d2);
    d = min(d, d2);

    d2 = length(p) - 0.03;
    a = radians(deg);
    d2 = max(dot(p, vec2f(cos(a), sin(a))), d2);
    a = radians(-deg);
    d2 = max(dot(p, vec2f(cos(a), sin(a))), d2);
    d = min(d, d2);

    d = max(-(length(p) - 0.02), d);
    return d;
}

fn rectUI(p_in: vec2f, iTime: f32) -> f32 {
    var p = rot(radians(45.0)) * p_in;
    let prevP = p;
    var d = abs(B(p, vec2f(0.12))) - 0.003;
    p = rot(radians(iTime * 60.0)) * p;
    d = max(-(abs(p.x) - 0.05), d);
    d = max(-(abs(p.y) - 0.05), d);
    p = prevP;
    var d2 = abs(B(p, vec2f(0.12))) - 0.0005;
    d = min(d, d2);

    d2 = abs(B(p, vec2f(0.09))) - 0.003;
    p = rot(radians(-iTime * 50.0)) * p;
    d2 = max(-(abs(p.x) - 0.03), d2);
    d2 = max(-(abs(p.y) - 0.03), d2);
    d = min(d, d2);
    p = prevP;
    d2 = abs(B(p, vec2f(0.09))) - 0.0005;
    d = min(d, d2);

    p = rot(radians(-45.0)) * p;
    p.y = abs(p.y) - 0.07 - sin(iTime * 3.0) * 0.01;
    d2 = Tri(p, vec2f(0.02), radians(45.0));
    d = min(d, d2);

    p = prevP;
    p = rot(radians(45.0)) * p;
    p.y = abs(p.y) - 0.07 - sin(iTime * 3.0) * 0.01;
    d2 = Tri(p, vec2f(0.02), radians(45.0));
    d = min(d, d2);

    p = prevP;
    p = rot(radians(45.0)) * p;
    d2 = abs(B(p, vec2f(0.025))) - 0.0005;
    d2 = max(-(abs(p.x) - 0.01), d2);
    d2 = max(-(abs(p.y) - 0.01), d2);
    d = min(d, d2);

    return d;
}

fn graphUI(p_in: vec2f, iTime: f32) -> f32 {
    var p = p_in;
    let prevP = p;
    p.x += 0.5;
    p.y -= iTime * 0.25;
    p *= vec2f(1.0, 100.0);

    let gv = fract(p) - vec2f(0.5);
    let id = floor(p);

    let n = Hash21(vec2f(id.y)) * 2.0;
    let w = (abs(sin(iTime * n) + 0.25) * 0.03) * n * 0.5;
    var d = B(gv, vec2f(w, 0.1));

    p = prevP;
    d = max((abs(p.x) - 0.2), d);
    d = max((abs(p.y) - 0.2), d);

    return d;
}

fn staticUI(p_in: vec2f) -> f32 {
    var p = p_in;
    let prevP = p;
    var d = B(p, vec2f(0.005, 0.13));
    p -= vec2f(0.02, -0.147);
    p = rot(radians(-45.0)) * p;
    var d2 = B(p, vec2f(0.005, 0.028));
    d = min(d, d2);
    p = prevP;
    d2 = B(p - vec2f(0.04, -0.2135), vec2f(0.005, 0.049));
    d = min(d, d2);
    p -= vec2f(0.02, -0.28);
    p = rot(radians(45.0)) * p;
    d2 = B(p, vec2f(0.005, 0.03));
    d = min(d, d2);
    p = prevP;
    d2 = length(p - vec2f(0.0, 0.13)) - 0.012;
    d = min(d, d2);
    d2 = length(p - vec2f(0.0, -0.3)) - 0.012;
    d = min(d, d2);
    return d;
}

fn arrowUI(p_in: vec2f, iTime: f32) -> f32 {
    var p = p_in;
    let prevP = p;
    p.x *= -1.0;
    p.x -= iTime * 0.12;
    p.x = glsl_mod(p.x, 0.07) - 0.035;
    p.x -= 0.0325;

    p *= vec2f(0.9, 1.5);
    p = rot(radians(90.0)) * p;
    var d = Tri(p, vec2f(0.05), radians(45.0));
    d = max(-Tri(p - vec2f(0.0, -0.03), vec2f(0.05), radians(45.0)), d);
    d = abs(d) - 0.0005;
    p = prevP;
    d = max(abs(p.x) - 0.15, d);
    return d;
}

fn sideLine(p_in: vec2f) -> f32 {
    var p = p_in;
    p.x *= -1.0;
    let prevP = p;
    p.y = abs(p.y) - 0.17;
    p = rot(radians(45.0)) * p;
    var d = B(p, vec2f(0.035, 0.01));
    p = prevP;
    let d2 = B(p - vec2f(0.0217, 0.0), vec2f(0.01, 0.152));
    d = min(d, d2);
    return abs(d) - 0.0005;
}

fn sideUI(p_in: vec2f) -> f32 {
    var p = p_in;
    let prevP = p;
    p.x *= -1.0;
    p.x += 0.025;
    var d = sideLine(p);
    p = prevP;
    p.y = abs(p.y) - 0.275;
    let d2 = sideLine(p);
    d = min(d, d2);
    return d;
}

fn overlayUI(p_in: vec2f, iTime: f32) -> f32 {
    var p = p_in;
    let prevP = p;

    var d = numberWithCircleUI(p - vec2f(0.56, -0.34), iTime);
    p.x = abs(p.x) - 0.56;
    p.y -= 0.45;
    var d2 = blockUI(p, iTime);
    d = min(d, d2);
    p = prevP;

    p.x = abs(p.x) - 0.72;
    p.y -= 0.35;
    d2 = smallCircleUI2(p, iTime);
    d = min(d, d2);
    p = prevP;
    d2 = smallCircleUI2(p - vec2f(-0.39, -0.42), iTime);
    d = min(d, d2);

    p = prevP;
    p.x -= 0.58;
    p.y -= 0.07;
    p.y = abs(p.y) - 0.12;
    d2 = smallCircleUI(p, iTime);
    d = min(d, d2);

    p = prevP;
    d2 = rectUI(p - vec2f(-0.58, -0.3), iTime);
    d = min(d, d2);

    p -= vec2f(-0.58, 0.1);
    p.x = abs(p.x) - 0.05;
    d2 = graphUI(p, iTime);
    d = min(d, d2);
    p = prevP;

    p.x = abs(p.x) - 0.72;
    p.y -= 0.13;
    d2 = staticUI(p);
    d = min(d, d2);
    p = prevP;

    p.x = abs(p.x) - 0.51;
    p.y -= 0.35;
    d2 = arrowUI(p, iTime);
    d = min(d, d2);
    p = prevP;

    p.x = abs(p.x) - 0.82;
    d2 = sideUI(p);
    d = min(d, d2);

    return d;
}

fn GetDist(p_in: vec3f, iTime: f32) -> f32 {
    var p = p_in;

    p.z += 0.7;
    let maxThick: f32 = 0.03;
    let minThick: f32 = 0.007;
    var thickness: f32 = maxThick;
    let frame = glsl_mod(iTime, 30.0);
    var time = frame;

    if (frame >= 10.0 && frame < 20.0) {
        time = getTime(time - 10.0, 1.5);
        thickness = (maxThick + minThick) - cubicInOut(time) * maxThick;
    } else if (frame >= 20.0) {
        time = getTime(time - 20.0, 1.5);
        thickness = minThick + cubicInOut(time) * maxThick;
    }

    var d = ring0(p.xy, iTime);
    d = max((abs(p.z) - thickness), d);

    p.z -= 0.2;
    var d2 = ring1(p.xy, iTime);
    d2 = max((abs(p.z) - thickness), d2);
    d = min(d, d2);

    p.z -= 0.2;
    d2 = ring2(p.xy, iTime);
    d2 = max((abs(p.z) - thickness), d2);
    d = min(d, d2);

    p.z -= 0.2;
    d2 = ring3(p.xy, iTime);
    d2 = max((abs(p.z) - thickness), d2);
    d = min(d, d2);

    p.z -= 0.2;
    d2 = ring4(p.xy, iTime);
    d2 = max((abs(p.z) - thickness), d2);
    d = min(d, d2);

    p.z -= 0.2;
    d2 = ring5(p.xy, iTime);
    d2 = max((abs(p.z) - thickness), d2);
    d = min(d, d2);

    p.z -= 0.2;
    d2 = ring6(p.xy, iTime);
    d2 = max((abs(p.z) - thickness), d2);
    d = min(d, d2);

    return d;
}

fn RayMarch(ro: vec3f, rd: vec3f, stepnum: i32, iTime: f32) -> vec3f {
    var steps: f32 = 0.0;
    var alpha: f32 = 0.0;

    let tmax: f32 = 5.0;
    var t: f32 = 0.0;

    let glowVal: f32 = 0.003;

    for (var i: f32 = 0.0; i < f32(stepnum); i += 1.0) {
        steps = i;
        let p = ro + rd * t;
        let d = GetDist(p, iTime);
        let absd = abs(d);

        if (t > tmax) { break; }

        alpha += 1.0 - smoothstep(0.0, glowVal, d);
        t += max(0.0001, absd * 0.6);
    }
    if (steps > 0.0) {
        alpha /= steps;
    }

    return alpha * vec3f(1.5);
}

fn R_cam(uv: vec2f, p: vec3f, l: vec3f, z: f32) -> vec3f {
    let f = normalize(l - p);
    let r = normalize(cross(vec3f(0.0, 1.0, 0.0), f));
    let u = cross(f, r);
    let c = p + f * z;
    let i = c + uv.x * r + uv.y * u;
    return normalize(i - p);
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let resolution = view.viewport.zw;
    let fragCoord = vec2f(in.uv.x, 1.0 - in.uv.y) * resolution;
    let iTime = globals.time;

    let uv = (fragCoord - 0.5 * resolution) / resolution.y;

    var YZ: f32 = 45.0;
    var ogRXZ: f32 = 50.0;
    var animRXZ: f32 = 20.0;

    let frame = glsl_mod(iTime, 30.0);
    var time = frame;

    if (frame >= 10.0 && frame < 20.0) {
        time = getTime(time - 10.0, 1.5);
        YZ = 45.0 - cubicInOut(time) * 45.0;
        ogRXZ = 50.0 - cubicInOut(time) * 50.0;
        animRXZ = 20.0 - cubicInOut(time) * 20.0;
    } else if (frame >= 20.0) {
        time = getTime(time - 20.0, 1.5);
        YZ = cubicInOut(time) * 45.0;
        ogRXZ = cubicInOut(time) * 50.0;
        animRXZ = cubicInOut(time) * 20.0;
    }

    var ro = vec3f(0.0, 0.0, -2.1);
    ro = vec3f(ro.x, (rot(radians(YZ)) * ro.yz).x, (rot(radians(YZ)) * ro.yz).y);

    let angle_xz = radians(sin(iTime * 0.3) * animRXZ + ogRXZ);
    let ro_xz = rot(angle_xz) * ro.xz;
    ro = vec3f(ro_xz.x, ro.y, ro_xz.y);

    let rd = R_cam(uv, ro, vec3f(0.0, 0.0, 0.0), 1.0);
    let d = RayMarch(ro, rd, MAX_STEPS, iTime);

    var col = vec3f(0.0);
    let bd = bg(uv, iTime);
    col = mix(col, vec3f(1.0), S(bd, 0.0, resolution));

    col = mix(col, d, 0.7);

    // Gamma correction
    col = pow(col, vec3f(0.9545));

    let d2 = overlayUI(uv, iTime);
    col = mix(col, vec3f(1.0), S(d2, 0.0, resolution));

    // High contrast tuning: crisp deep blacks and glowing neon highlights
    var rgb = clamp(col, vec3f(0.0), vec3f(1.0));
    rgb = pow(rgb, vec3f(1.3)) * 1.25;
    rgb = clamp(rgb, vec3f(0.0), vec3f(1.0));

    return vec4f(rgb, 1.0);
}
