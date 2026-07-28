// Created by Danil (2021+) https://github.com/danilw
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
// Self: https://www.shadertoy.com/view/NslGRN
// Ported from GLSL to WGSL for shadplay

#import bevy_sprite::mesh2d_view_bindings::globals 
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

const ROTATION_SPEED: f32 = 0.8999;
const FDIST: f32 = 0.7;
const PI: f32 = 3.14159265359;
const GROUNDSPACING: f32 = 0.5;
const GROUNDGRID: f32 = 0.05;
const BOXDIMS: vec3f = vec3f(0.75, 0.75, 1.25);
const IOR: f32 = 1.33;
const TSHIFT: f32 = 53.0;

fn rotx(a: f32) -> mat3x3f {
    let s = sin(a);
    let c = cos(a);
    return mat3x3f(
        vec3f(1.0, 0.0, 0.0),
        vec3f(0.0, c, s),
        vec3f(0.0, -s, c)
    );
}

fn roty(a: f32) -> mat3x3f {
    let s = sin(a);
    let c = cos(a);
    return mat3x3f(
        vec3f(c, 0.0, s),
        vec3f(0.0, 1.0, 0.0),
        vec3f(-s, 0.0, c)
    );
}

fn rotz(a: f32) -> mat3x3f {
    let s = sin(a);
    let c = cos(a);
    return mat3x3f(
        vec3f(c, s, 0.0),
        vec3f(-s, c, 0.0),
        vec3f(0.0, 0.0, 1.0)
    );
}

fn glsl_mod(x: f32, y: f32) -> f32 {
    return x - y * floor(x / y);
}

fn fcos1(x: vec3f, resolution_y: f32) -> vec3f {
    let w = fwidth(x);
    let lw = length(w);
    if (lw == 0.0 || lw != lw || lw > 1e10) {
        var tc = vec3f(0.0);
        for (var i: i32 = 0; i < 8; i++) {
            tc += cos(x + x * f32(i - 4) * (0.01 * 400.0 / resolution_y));
        }
        return tc / 8.0;
    }
    return cos(x) * smoothstep(vec3f(3.14 * 2.0), vec3f(0.0), w);
}

fn fcos(x: vec3f, resolution_y: f32) -> vec3f {
    return fcos1(x, resolution_y);
}

fn getColor(p_in: vec3f, resolution_y: f32) -> vec3f {
    var p = abs(p_in);
    p *= 1.25;
    p = 0.5 * p / dot(p, p);

    let t = 0.13 * length(p);
    var col = vec3f(0.3, 0.4, 0.5);
    col += 0.12 * fcos(6.28318 * t * 1.0 + vec3f(0.0, 0.8, 1.1), resolution_y);
    col += 0.11 * fcos(6.28318 * t * 3.1 + vec3f(0.3, 0.4, 0.1), resolution_y);
    col += 0.10 * fcos(6.28318 * t * 5.1 + vec3f(0.1, 0.7, 1.1), resolution_y);
    col += 0.10 * fcos(6.28318 * t * 17.1 + vec3f(0.2, 0.6, 0.7), resolution_y);
    col += 0.10 * fcos(6.28318 * t * 31.1 + vec3f(0.1, 0.6, 0.7), resolution_y);
    col += 0.10 * fcos(6.28318 * t * 65.1 + vec3f(0.0, 0.5, 0.8), resolution_y);
    col += 0.10 * fcos(6.28318 * t * 115.1 + vec3f(0.1, 0.4, 0.7), resolution_y);
    col += 0.10 * fcos(6.28318 * t * 265.1 + vec3f(1.1, 1.4, 2.7), resolution_y);
    return clamp(col, vec3f(0.0), vec3f(1.0));
}

struct CalcColorOutput {
    colx: vec4f,
    colsi: vec4f,
}

fn calcColor(ro: vec3f, rd: vec3f, nor: vec3f, d: f32, len: f32, idx: i32, si: bool, td: f32, resolution_y: f32) -> CalcColorOutput {
    var out_val: CalcColorOutput;
    out_val.colx = vec4f(0.0);
    out_val.colsi = vec4f(0.0);

    var pos = ro + rd * d;
    let a = 1.0 - smoothstep(len - 0.15 * 0.5, len + 0.00001, length(pos));
    let col = getColor(pos, resolution_y);
    out_val.colx = vec4f(col, a);
    if (si) {
        pos = ro + rd * td;
        let ta = 1.0 - smoothstep(len - 0.15 * 0.5, len + 0.00001, length(pos));
        let col_si = getColor(pos, resolution_y);
        out_val.colsi = vec4f(col_si, ta);
    }
    return out_val;
}

struct BilinearResult {
    hit: bool,
    t: f32,
    norm: vec3f,
    si: bool,
    tsi: f32,
    normsi: vec3f,
    fade: f32,
    fadesi: f32,
}

fn iBilinearPatch(ro: vec3f, rd: vec3f, ps: vec4f, ph: vec4f, sz: f32) -> BilinearResult {
    var res: BilinearResult;
    res.hit = false;
    res.t = -1.0;
    res.tsi = -1.0;
    res.si = false;
    res.fade = 1.0;
    res.fadesi = 1.0;
    res.norm = vec3f(0.0, 1.0, 0.0);
    res.normsi = vec3f(0.0, 1.0, 0.0);

    let va = vec3f(0.0, 0.0, ph.x + ph.w - ph.y - ph.z);
    let vb = vec3f(0.0, ps.w - ps.y, ph.z - ph.x);
    let vc = vec3f(ps.z - ps.x, 0.0, ph.y - ph.x);
    let vd = vec3f(ps.xy, ph.x);

    let tmp = 1.0 / (vb.y * vc.x);
    let a = 0.0;
    let b = 0.0;
    let c = 0.0;
    let d = va.z * tmp;
    let e = 0.0;
    let f = 0.0;
    let g = (vc.z * vb.y - vd.y * va.z) * tmp;
    let h = (vb.z * vc.x - va.z * vd.x) * tmp;
    let i_val = -1.0;
    let j = (vd.x * vd.y * va.z + vd.z * vb.y * vc.x) * tmp - (vd.y * vb.z * vc.x + vd.x * vc.z * vb.y) * tmp;

    let p = dot(vec3f(a, b, c), rd.xzy * rd.xzy) + dot(vec3f(d, e, f), rd.xzy * rd.zyx);
    let q = dot(vec3f(2.0, 2.0, 2.0) * ro.xzy * rd.xyz, vec3f(a, b, c)) + dot(ro.xzz * rd.zxy, vec3f(d, d, e)) +
              dot(ro.yyx * rd.zxy, vec3f(e, f, f)) + dot(vec3f(g, h, i_val), rd.xzy);
    let r_val = dot(vec3f(a, b, c), ro.xzy * ro.xzy) + dot(vec3f(d, e, f), ro.xzy * ro.zyx) + dot(vec3f(g, h, i_val), ro.xzy) + j;

    if (abs(p) < 0.000001) {
        let tt = -r_val / q;
        if (tt <= 0.0) {
            return res;
        }
        res.t = tt;
        let pos = ro + res.t * rd;
        if (length(pos) > sz) {
            return res;
        }
        let grad = vec3f(2.0) * pos.xzy * vec3f(a, b, c) + pos.zxz * vec3f(d, d, e) + pos.yyx * vec3f(f, e, f) + vec3f(g, h, i_val);
        res.norm = -normalize(grad);
        res.hit = true;
        return res;
    } else {
        let sq = q * q - 4.0 * p * r_val;
        if (sq < 0.0) {
            return res;
        } else {
            let s = sqrt(sq);
            let t0 = (-q + s) / (2.0 * p);
            let t1 = (-q - s) / (2.0 * p);
            let v0 = select(t0, t1, t0 < 0.0);
            let v1 = select(t1, t0, t1 < 0.0);
            let tt1 = min(v0, v1);

            let u0 = select(t0, t1, t0 > 0.0);
            let u1 = select(t1, t0, t1 > 0.0);
            let tt2 = max(u0, u1);

            var tt0 = tt1;
            if (tt0 <= 0.0) {
                return res;
            }
            var pos = ro + tt0 * rd;
            let ru = step(sz, length(pos)) > 0.5;
            if (ru) {
                tt0 = tt2;
                pos = ro + tt0 * rd;
            }
            if (tt0 <= 0.0) {
                return res;
            }
            let ru2 = step(sz, length(pos)) > 0.5;
            if (ru2) {
                return res;
            }

            if ((tt2 > 0.0) && (!ru) && !(step(sz, length(ro + tt2 * rd)) > 0.5)) {
                res.si = true;
                res.fadesi = s;
                res.tsi = tt2;
                let tpos = ro + res.tsi * rd;
                let tgrad = vec3f(2.0) * tpos.xzy * vec3f(a, b, c) + tpos.zxz * vec3f(d, d, e) +
                             tpos.yyx * vec3f(f, e, f) + vec3f(g, h, i_val);
                res.normsi = -normalize(tgrad);
            }

            res.fade = s;
            res.t = tt0;
            let grad = vec3f(2.0) * pos.xzy * vec3f(a, b, c) + pos.zxz * vec3f(d, d, e) + pos.yyx * vec3f(f, e, f) + vec3f(g, h, i_val);
            res.norm = -normalize(grad);
            res.hit = true;
            return res;
        }
    }
}

fn dot2(v: vec3f) -> f32 {
    return dot(v, v);
}

fn segShadow(ro: vec3f, rd: vec3f, pa: vec3f, sh_in: f32) -> f32 {
    var sh = sh_in;
    let dm = dot(rd.yz, rd.yz);
    let k1 = (ro.x - pa.x) * dm;
    let k2 = (ro.x + pa.x) * dm;
    let k5 = (ro.yz + pa.yz) * dm;
    let k3 = dot(ro.yz + pa.yz, rd.yz);
    let k4 = (pa.yz + pa.yz) * rd.yz;
    let k6 = (pa.yz + pa.yz) * dm;

    for (var i: i32 = 0; i < 4; i++) {
        let s = vec2f(f32(i & 1), f32(i >> 1));
        let t = dot(s, k4) - k3;
        if (t > 0.0) {
            let val = dot2(vec3f(clamp(-rd.x * t, k1, k2), k5 - k6 * s) + rd * t) / (t * t);
            sh = min(sh, val);
        }
    }
    return sh;
}

fn boxSoftShadow(ro: vec3f, rd: vec3f, rad: vec3f, sk: f32) -> f32 {
    let rd_adj = rd + 0.0001 * (1.0 - abs(sign(rd)));
    let rdd = rd_adj;
    let roo = ro;

    let m = 1.0 / rdd;
    let n = m * roo;
    let k = abs(m) * rad;

    let t1 = -n - k;
    let t2 = -n + k;

    let tN = max(max(t1.x, t1.y), t1.z);
    let tF = min(min(t2.x, t2.y), t2.z);

    if (tN < tF && tF > 0.0) {
        return 0.0;
    }

    var sh = 1.0;
    sh = segShadow(roo.xyz, rdd.xyz, rad.xyz, sh);
    sh = segShadow(roo.yzx, rdd.yzx, rad.yzx, sh);
    sh = segShadow(roo.zxy, rdd.zxy, rad.zxy, sh);
    sh = clamp(sk * sqrt(sh), 0.0, 1.0);
    return sh * sh * (3.0 - 2.0 * sh);
}

struct BoxResult {
    t: f32,
    nn: vec3f,
}

fn box_intersect(ro: vec3f, rd: vec3f, r_val: vec3f, entering: bool) -> BoxResult {
    var res: BoxResult;
    res.t = -1.0;
    res.nn = vec3f(0.0);

    let rd_adj = rd + 0.0001 * (1.0 - abs(sign(rd)));
    let dr = 1.0 / rd_adj;
    let n = ro * dr;
    let k = r_val * abs(dr);

    let pin = -k - n;
    let pout = k - n;
    let tin = max(pin.x, max(pin.y, pin.z));
    let tout = min(pout.x, min(pout.y, pout.z));
    if (tin > tout) {
        return res;
    }
    if (entering) {
        res.nn = -sign(rd_adj) * step(pin.zxy, pin.xyz) * step(pin.yzx, pin.xyz);
    } else {
        res.nn = sign(rd_adj) * step(pout.xyz, pout.zxy) * step(pout.xyz, pout.yzx);
    }
    res.t = select(tout, tin, entering);
    return res;
}

fn bgcol(rd: vec3f) -> vec3f {
    return mix(vec3f(0.01), vec3f(0.336, 0.458, 0.668), 1.0 - pow(abs(rd.z + 0.25), 1.3));
}

struct BgResult {
    col: vec3f,
    alpha: f32,
}

fn background(ro: vec3f, rd: vec3f, l_dir: vec3f) -> BgResult {
    var res: BgResult;
    res.alpha = 0.0;
    let bgc = bgcol(rd);
    let t = (-BOXDIMS.z - ro.z) / rd.z;
    if (t < 0.0) {
        res.col = bgc;
        return res;
    }
    let uv = ro.xy + t * rd.xy;
    let l_dir_rot = (l_dir + vec3f(0.0, 0.0, 1.0)) * rotz(PI * 0.65);
    let shad = boxSoftShadow(ro + t * rd, normalize(l_dir_rot), BOXDIMS, 1.5);
    var aofac = smoothstep(-0.95, 0.75, length(abs(uv) - min(abs(uv), vec2f(0.45))));
    aofac = min(aofac, smoothstep(-0.65, 1.0, shad));
    let l_dir_rot2 = (l_dir - vec3f(0.0, 0.0, 1.0)) * rotz(PI * 0.65);
    let lght = max(dot(normalize(ro + t * rd + vec3f(0.0, 0.0, -5.0)), normalize(l_dir_rot2)), 0.0);
    let col = mix(vec3f(0.4), vec3f(0.71, 0.772, 0.895), lght * lght * aofac + 0.05) * aofac;
    res.alpha = 1.0 - smoothstep(7.0, 10.0, length(uv));
    res.col = mix(col * length(col) * 0.8, bgc, smoothstep(7.0, 10.0, length(uv)));
    return res;
}

struct InsidesResult {
    color: vec4f,
    tout: f32,
}

fn insides(ro_in: vec3f, rd_in: vec3f, nor_c: vec3f, l_dir_in: vec3f, resolution_y: f32) -> InsidesResult {
    var res: InsidesResult;
    res.tout = -1.0;
    var ro = ro_in;
    var rd = rd_in;
    var l_dir = l_dir_in;

    let pi: f32 = 3.1415926;

    if (abs(nor_c.x) > 0.5) {
        rd = rd.xzy * nor_c.x;
        ro = ro.xzy * nor_c.x;
    } else if (abs(nor_c.z) > 0.5) {
        l_dir = l_dir * roty(pi);
        rd = rd.yxz * nor_c.z;
        ro = ro.yxz * nor_c.z;
    } else if (abs(nor_c.y) > 0.5) {
        l_dir = l_dir * rotz(-pi * 0.5);
        rd = rd * nor_c.y;
        ro = ro * nor_c.y;
    }

    let curvature: f32 = 0.5;
    let bil_size: f32 = 1.0;
    let ps = vec4f(-bil_size, -bil_size, bil_size, bil_size) * curvature;
    let ph = vec4f(-bil_size, bil_size, bil_size, -bil_size) * curvature;

    var colx: array<vec4f, 3> = array<vec4f, 3>(vec4f(0.0), vec4f(0.0), vec4f(0.0));
    var dx: array<vec3f, 3> = array<vec3f, 3>(vec3f(-1.0), vec3f(-1.0), vec3f(-1.0));
    var colxsi: array<vec4f, 3> = array<vec4f, 3>(vec4f(0.0), vec4f(0.0), vec4f(0.0));
    var order: array<i32, 3> = array<i32, 3>(0, 1, 2);

    for (var i: i32 = 0; i < 3; i++) {
        if (abs(nor_c.x) > 0.5) {
            ro = ro * rotz(-pi * (1.0 / 3.0));
            rd = rd * rotz(-pi * (1.0 / 3.0));
        } else if (abs(nor_c.z) > 0.5) {
            ro = ro * rotz(pi * (1.0 / 3.0));
            rd = rd * rotz(pi * (1.0 / 3.0));
        } else if (abs(nor_c.y) > 0.5) {
            ro = ro * rotx(pi * (1.0 / 3.0));
            rd = rd * rotx(pi * (1.0 / 3.0));
        }

        let patch_res = iBilinearPatch(ro, rd, ps, ph, bil_size);
        if (patch_res.hit && patch_res.t > 0.0) {
            let col_calc = calcColor(ro, rd, patch_res.norm, patch_res.t, bil_size, i, patch_res.si, patch_res.tsi, resolution_y);
            var tcol = col_calc.colx;
            var tcolsi = col_calc.colsi;

            if (tcol.a > 0.0) {
                let si_f = select(0.0, 1.0, patch_res.si);
                dx[i] = vec3f(patch_res.t, si_f, patch_res.tsi);

                var dif = clamp(dot(patch_res.norm, l_dir), 0.0, 1.0);
                var amb = clamp(0.5 + 0.5 * dot(patch_res.norm, l_dir), 0.0, 1.0);

                let shad = vec3f(0.32, 0.43, 0.54) * amb + vec3f(1.0, 0.9, 0.7) * dif;
                let tcr = vec3f(1.0, 0.21, 0.11);

                let ta = clamp(length(tcol.rgb), 0.0, 1.0);
                tcol = clamp(tcol * tcol * 2.0, vec4f(0.0), vec4f(1.0));
                var tvalx = vec4f(tcol.rgb * shad * 1.4 + 3.0 * (tcr * tcol.rgb) * clamp(1.0 - (amb + dif), 0.0, 1.0), min(tcol.a, ta));
                tvalx = vec4f(clamp(2.0 * tvalx.rgb * tvalx.rgb, vec3f(0.0), vec3f(1.0)), tvalx.a);
                tvalx *= min(patch_res.fade * 5.0, 1.0);
                colx[i] = tvalx;

                if (patch_res.si) {
                    dif = clamp(dot(patch_res.normsi, l_dir), 0.0, 1.0);
                    amb = clamp(0.5 + 0.5 * dot(patch_res.normsi, l_dir), 0.0, 1.0);
                    let shad_si = vec3f(0.32, 0.43, 0.54) * amb + vec3f(1.0, 0.9, 0.7) * dif;
                    let ta_si = clamp(length(tcolsi.rgb), 0.0, 1.0);
                    tcolsi = clamp(tcolsi * tcolsi * 2.0, vec4f(0.0), vec4f(1.0));
                    var tvalx_si = vec4f(tcolsi.rgb * shad_si + 3.0 * (tcr * tcolsi.rgb) * clamp(1.0 - (amb + dif), 0.0, 1.0), min(tcolsi.a, ta_si));
                    tvalx_si = vec4f(clamp(2.0 * tvalx_si.rgb * tvalx_si.rgb, vec3f(0.0), vec3f(1.0)), tvalx_si.a);
                    tvalx_si = vec4f(tvalx_si.rgb * min(patch_res.fadesi * 5.0, 1.0), tvalx_si.a);
                    colxsi[i] = tvalx_si;
                }
            }
        }
    }

    var a_val: f32 = 1.0;
    if (dx[0].x < dx[1].x) {
        let tmp_d = dx[0]; dx[0] = dx[1]; dx[1] = tmp_d;
        let tmp_o = order[0]; order[0] = order[1]; order[1] = tmp_o;
    }
    if (dx[1].x < dx[2].x) {
        let tmp_d = dx[1]; dx[1] = dx[2]; dx[2] = tmp_d;
        let tmp_o = order[1]; order[1] = order[2]; order[2] = tmp_o;
    }
    if (dx[0].x < dx[1].x) {
        let tmp_d = dx[0]; dx[0] = dx[1]; dx[1] = tmp_d;
        let tmp_o = order[0]; order[0] = order[1]; order[1] = tmp_o;
    }

    res.tout = max(max(dx[0].x, dx[1].x), dx[2].x);

    if (dx[0].y < 0.5) {
        a_val = colx[order[0]].a;
    }

    let rul = array<bool, 3>(
        (dx[0].y > 0.5) && (dx[1].x <= 0.0),
        (dx[1].y > 0.5) && (dx[0].x > dx[1].z),
        (dx[2].y > 0.5) && (dx[1].x > dx[2].z)
    );

    for (var k: i32 = 0; k < 3; k++) {
        if (rul[k]) {
            let idx_k = order[k];
            let tcolxsi = colxsi[idx_k];
            let tcolx = colx[idx_k];

            let tvalx = mix(tcolxsi, tcolx, vec4f(tcolx.a));
            colx[idx_k] = tvalx;

            let tvalx2 = mix(vec4f(0.0), tvalx, vec4f(max(tcolx.a, tcolxsi.a)));
            colx[idx_k] = tvalx2;
        }
    }

    var a1: f32 = 1.0;
    if (dx[1].y < 0.5) {
        a1 = colx[order[1]].a;
    } else if (dx[1].z > dx[0].x) {
        a1 = colx[order[1]].a;
    }

    var a2: f32 = 1.0;
    if (dx[2].y < 0.5) {
        a2 = colx[order[2]].a;
    } else if (dx[2].z > dx[1].x) {
        a2 = colx[order[2]].a;
    }

    let col_blend = mix(mix(colx[order[0]].rgb, colx[order[1]].rgb, vec3f(a1)), colx[order[2]].rgb, vec3f(a2));
    let final_a = max(max(a_val, a1), a2);

    res.color = vec4f(col_blend, final_a);
    return res;
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let resolution = view.viewport.zw;
    let fragCoord = vec2f(in.uv.x, 1.0 - in.uv.y) * resolution;
    let iTime = globals.time;

    var l_dir = normalize(vec3f(0.0, 1.0, 0.0));
    l_dir = l_dir * rotz(0.5);

    let mouseY = PI * 0.49 - smoothstep(0.0, 8.5, glsl_mod((iTime + TSHIFT) * 0.33, 25.0)) * (1.0 - smoothstep(14.0, 24.0, glsl_mod((iTime + TSHIFT) * 0.33, 25.0))) * 0.55 * PI;
    let mouseX = -2.0 * PI - 0.25 * (iTime * ROTATION_SPEED + TSHIFT);

    let eye = 4.0 * vec3f(cos(mouseX) * cos(mouseY), sin(mouseX) * cos(mouseY), sin(mouseY));
    let w = normalize(-eye);
    let up = vec3f(0.0, 0.0, 1.0);
    let u = normalize(cross(w, up));
    let v = cross(u, w);

    let uv = (fragCoord - 0.5 * resolution) / resolution.x;
    let rd = normalize(w * FDIST + uv.x * u + uv.y * v);

    let b_res = box_intersect(eye, rd, BOXDIMS, true);
    let t = b_res.t;
    let ni = b_res.nn;
    let ro = eye + t * rd;

    if (t > 0.0) {
        let coords = ro.xy * ni.z / BOXDIMS.xy + ro.yz * ni.x / BOXDIMS.yz + ro.zx * ni.y / BOXDIMS.zx;
        let fadeborders = (1.0 - smoothstep(0.915, 1.05, abs(coords.x))) * (1.0 - smoothstep(0.915, 1.05, abs(coords.y)));

        let R0_val = (IOR - 1.0) / (IOR + 1.0);
        let R0 = R0_val * R0_val;

        let theta = vec2f(0.0);
        let n = vec3f(cos(theta.x) * sin(theta.y), sin(theta.x) * sin(theta.y), cos(theta.y));

        let nr = n.zxy * ni.x + n.yzx * ni.y + n.xyz * ni.z;
        let rdr = reflect(rd, nr);
        let bg_res = background(ro, rdr, l_dir);
        let reflcol = bg_res.col;

        var rd2 = refract(rd, nr, 1.0 / IOR);

        var accum: f32 = 1.0;
        var no2 = ni;
        var ro_refr = ro;

        var colo: array<vec4f, 2> = array<vec4f, 2>(vec4f(0.0), vec4f(0.0));

        for (var j: i32 = 0; j < 2; j++) {
            let coords2 = ro_refr.xy * no2.z + ro_refr.yz * no2.x + ro_refr.zx * no2.y;
            let eye2 = vec3f(coords2, -1.0);
            var rd2trans = rd2.yzx * no2.x + rd2.zxy * no2.y + rd2.xyz * no2.z;
            rd2trans.z = -rd2trans.z;

            let ins_res = insides(eye2, rd2trans, no2, l_dir, resolution.y);
            let tb = ins_res.tout;
            var internalcol = ins_res.color;
            if (tb > 0.0) {
                internalcol = vec4f(internalcol.rgb * accum, internalcol.a);
                colo[j] = internalcol;
            }

            if (tb <= 0.0 || internalcol.a < 1.0) {
                let box2 = box_intersect(ro_refr, rd2, BOXDIMS, false);
                let tout = box2.t;
                no2 = box2.nn;
                no2 = n.zyx * no2.x + n.xzy * no2.y + n.yxz * no2.z;
                let rout = ro_refr + tout * rd2;
                let rdout = refract(rd2, -no2, IOR);
                let fresnel2 = R0 + (1.0 - R0) * pow(1.0 - dot(rdout, no2), 1.3);
                rd2 = reflect(rd2, -no2);

                ro_refr = rout;
                ro_refr.z = max(ro_refr.z, -0.999);

                accum *= fresnel2;
            }
        }
        let fresnel = R0 + (1.0 - R0) * pow(1.0 - dot(-rd, nr), 5.0);
        var col = mix(mix(colo[1].rgb * colo[1].a, colo[0].rgb, vec3f(colo[0].a)) * fadeborders, reflcol, vec3f(pow(fresnel, 1.5)));
        col = clamp(col, vec3f(0.0), vec3f(1.0));

        let cineshader_alpha = clamp(0.15 * dot(eye, ro), 0.0, 1.0);
        var fragColor = vec4f(col, cineshader_alpha);
        fragColor = vec4f(clamp(fragColor.rgb, vec3f(0.0), vec3f(1.0)), fragColor.a);
        return fragColor;
    } else {
        let bg_res = background(eye, rd, l_dir);
        var fragColor = vec4f(bg_res.col, 0.15);
        fragColor = vec4f(clamp(fragColor.rgb, vec3f(0.0), vec3f(1.0)), fragColor.a);
        return fragColor;
    }
}
