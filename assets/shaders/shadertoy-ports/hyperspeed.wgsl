// Highway / Traffic Shader by Shadertoy
// Ported from GLSL to WGSL for shadplay

#import bevy_sprite::mesh2d_view_bindings::globals 
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

const PI: f32 = 3.14159265359;
const LEN: f32 = 400.0;
const FAR: f32 = 600.0;
const STEPS: i32 = 88;
const LAYERS: i32 = 5;
const FOGK: f32 = 0.0040;
const INTENS: f32 = 2.4;
const WAMP: f32 = 1.00;
const WAMPY: f32 = 1.00;
const WSPD: f32 = 0.50;

const BG: vec3f = vec3f(0.070, 0.038, 0.125);
const ASP: vec3f = vec3f(0.045, 0.026, 0.080);

fn nsin(x: f32) -> f32 {
    return sin(x) * 0.5 + 0.5;
}

fn glsl_mod(x: f32, y: f32) -> f32 {
    return x - y * floor(x / y);
}

fn dXr(p: f32, iTime: f32) -> f32 {
    let T = iTime * WSPD;
    let a = cos(PI * p * 4.0 + T);
    let b = cos(PI * p * 8.0 + T * 2.0);
    return (a * 25.0 + b * b * 5.0) * WAMP;
}

fn dYr(p: f32, iTime: f32) -> f32 {
    let T = iTime * WSPD;
    let a = nsin(PI * p * 8.0 + T);
    let b = nsin(PI * p + T / 8.0);
    let b2 = b * b;
    return (-a * 10.0 - b2 * b2 * b * 10.0) * WAMP * WAMPY;
}

fn dX(p: f32, refx: f32, iTime: f32) -> f32 {
    return dXr(p, iTime) - refx;
}

fn dY(p: f32, refy: f32, iTime: f32) -> f32 {
    return dYr(p, iTime) - refy;
}

fn hash22(p: vec2f) -> vec2f {
    var p3 = fract(vec3f(p.xyx) * vec3f(0.1031, 0.1030, 0.0973));
    p3 += dot(p3, p3.yzx + vec3f(33.33));
    return fract((p3.xx + p3.yz) * p3.zy);
}

fn kern(d: f32, R: f32) -> f32 {
    let x = d / R;
    let y = max(0.0, 1.0 - x * x * 0.25);
    return y * y * y;
}

fn carColor(h: f32, side: f32) -> vec3f {
    if (side < 0.0) {
        if (h < 0.34) { return vec3f(1.000, 0.243, 0.784); }
        if (h < 0.67) { return vec3f(0.698, 0.235, 0.902); }
        return vec3f(0.482, 0.310, 0.878);
    }
    if (h < 0.34) { return vec3f(0.180, 0.902, 0.902); }
    if (h < 0.67) { return vec3f(0.227, 0.435, 0.878); }
    return vec3f(0.169, 0.247, 0.620);
}

fn layerLights(u: f32, z: f32, li: f32, px: f32, iTime: f32) -> vec3f {
    var e = vec3f(0.0);
    let sc = max(z, 1.0);
    let R = 0.010 * sc;
    let R2 = 0.035 * sc;
    let reach = 2.0 * R2 + 2.63;

    for (var i: i32 = 0; i < 8; i++) {
        let fi = f32(i);
        let side = select(1.0, -1.0, fi < 4.0);
        let ln = select(fi - 4.0, fi, fi < 4.0);
        let laneX = side * 6.0 + (ln * 2.5 - 3.75);

        if (abs(u - laneX) <= reach) {
            let dir = select(1.0, -1.0, side < 0.0);

            let hs = hash22(vec2f(fi * 1.7 + 3.0, li * 2.9 + 11.0));
            let spd = select(80.0 + hs.x * 26.0, 40.0 + hs.x * 14.0, side < 0.0);
            let per = 160.0 + hs.y * 80.0;
            let ph = fract(hs.x * 91.7) * 400.0;

            let q = z + iTime * spd * dir + ph;
            let cc = q / per;
            let id = floor(cc);
            let f = (cc - id) * per;

            let h1 = hash22(vec2f(id, fi + li * 17.0));
            let h2 = hash22(vec2f(id + 53.0, fi * 2.3 + li * 7.0));

            let len = 12.0 + h1.x * 68.0;
            let m = smoothstep(0.0, len * 0.08, f) * smoothstep(len, len * 0.25, f);

            if (m > 0.0) {
                let rad = 0.05 + h1.y * 0.09;
                let cw = (0.3 + h2.x * 0.2) * 2.5;
                let cx = laneX + (fract(h2.x * 7.1) - 0.5) * 4.0;
                let col = carColor(fract(h1.y * 5.1), side);

                let w = max(rad, px * 1.6);
                let k = rad / w;
                let d1 = abs(u - cx + cw * 0.5);
                let d2 = abs(u - cx - cw * 0.5);

                let core = smoothstep(w * 1.8, w * 0.45, d1) + smoothstep(w * 1.8, w * 0.45, d2);

                let dl = min(max(0.0, f - len), max(0.0, per - f));
                let lum = dot(col, vec3f(0.2125, 0.7154, 0.0721));
                let on = smoothstep(0.30, 0.44, lum) * k;

                let bloom = (kern(d1, R) + kern(d2, R)) * kern(dl, R * 3.0);
                let flash = (kern(d1, R2) + kern(d2, R2)) * kern(dl, R2 * 2.0) * smoothstep(60.0, 5.0, z);

                e += col * m * k * core;
                e += col * on * m * (bloom * 0.50 + flash * 0.25);
            }
        }
    }

    let sq = glsl_mod(z + iTime * 80.0, 20.0);
    let step_li = select(0.0, 1.0, li <= 1.7);
    e += vec3f(0.180, 0.902, 0.902)
       * smoothstep(1.5, 0.0, sq) * step_li
       * smoothstep(0.45, 0.0, abs(u + 11.0))
       * smoothstep(190.0, 70.0, z);

    return e;
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let resolution = view.viewport.zw;
    let fragCoord = vec2f(in.uv.x, 1.0 - in.uv.y) * resolution;
    let iTime = globals.time;

    let refx = dXr(0.0125, iTime);
    let refy = dYr(0.0125, iTime);

    let uv = (2.0 * fragCoord - resolution) / resolution.y;

    let ex = dX(0.0, refx, iTime) - dX(0.007, refx, iTime);
    let ey = dY(0.0, refy, iTime) - dY(0.007, refy, iTime);

    let cam = vec3f(0.0, 8.0, -5.0);
    let fwd = normalize(vec3f(ex * -2.0, ey * -5.0, -10.0));
    let rgt = normalize(cross(fwd, vec3f(0.0, 1.0, 0.0)));
    let upv = cross(rgt, fwd);
    let rd = normalize(fwd + rgt * uv.x + upv * uv.y);

    var lit = vec3f(0.0);
    var surf = BG;
    var tp: f32 = 0.0;
    var zp: f32 = 5.0;
    var up_val: f32 = 0.0;
    var vp: f32 = 8.0;

    for (var i: i32 = 1; i <= STEPS; i++) {
        let xf = f32(i) / f32(STEPS);
        let t = FAR * xf * sqrt(xf);
        let P = cam + rd * t;
        let z = -P.z;
        if (z > FAR) { break; }

        if (rd.y >= 0.0 && P.y + refy > 5.5) { break; }

        let u_val = P.x - dX(z / LEN, refx, iTime);
        let v_val = P.y - dY(z / LEN, refy, iTime);

        let tm = 0.5 * (tp + t);
        let Pm = cam + rd * tm;
        let vm = Pm.y - dY(-Pm.z / LEN, refy, iTime);

        for (var s: i32 = 0; s < 2; s++) {
            let ta = select(tm, tp, s == 0);
            let tb = select(t, tm, s == 0);
            let va = select(vm, vp, s == 0);
            let vb = select(v_val, vm, s == 0);

            for (var j: i32 = 0; j < LAYERS; j++) {
                let hL = 0.4 + f32(j) * 1.05;
                if ((va - hL) * (vb - hL) < 0.0) {
                    let fr = (va - hL) / (va - vb);
                    let tc = mix(ta, tb, fr);
                    let Pc = cam + rd * tc;
                    let zc = -Pc.z;
                    if (zc > 0.0) {
                        let pc = zc / LEN;
                        let uc = Pc.x - dX(pc, refx, iTime);
                        let dyp = (dYr(pc + 0.002, iTime) - dYr(pc - 0.002, iTime)) / (0.004 * LEN);
                        let grz = smoothstep(0.004, 0.020, abs(rd.y + dyp * rd.z));
                        let win = smoothstep(17.0, 13.5, abs(uc)) * smoothstep(FAR, FAR * 0.45, zc);
                        if (win > 0.0) {
                            lit += layerLights(uc, zc, f32(j), tc * 2.0 / resolution.y, iTime)
                                 * exp(-tc * FOGK) * grz * win;
                        }
                    }
                }
            }
        }

        if (v_val < 0.0 && vp > 0.0) {
            let fr = vp / (vp - v_val);
            let uc = mix(up_val, u_val, fr);
            let zc = mix(zp, z, fr);
            let tc = mix(tp, t, fr);
            let rw = smoothstep(11.8, 10.4, abs(uc)) * smoothstep(FAR, FAR * 0.5, zc);
            if (rw > 0.0) {
                let fg = exp(-tc * 0.0055);
                let island = smoothstep(1.15, 0.85, abs(uc));
                surf = mix(BG, mix(ASP, ASP * 1.30, island), fg * rw);
                break;
            }
        }

        tp = t; zp = z; up_val = u_val; vp = v_val;
    }

    var col = min(surf * 0.7 + (vec3f(1.0) - exp(-lit * 3.0)), vec3f(1.0));
    col = pow(clamp(col, vec3f(0.0), vec3f(1.0)), vec3f(1.5)) * 1.15;
    let finalColor = clamp(col, vec3f(0.0), vec3f(1.0));
    return vec4f(finalColor, 1.0);
}
