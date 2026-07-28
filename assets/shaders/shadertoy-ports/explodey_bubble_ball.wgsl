// Fractured Buckyball Orb with Dispersion, Refraction & Filmic Tonemapping
// Ported from GLSL to WGSL for shadplay

#import bevy_sprite::mesh2d_view_bindings::globals 
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

const PI: f32 = 3.14159265359;
const PHI: f32 = 1.618033988749895;
const MAX_DISPERSE: f32 = 3.0;
const MAX_BOUNCE: f32 = 4.0;
const BGCOL: vec3f = vec3f(0.03, 0.08, 0.22);

fn pR(p: ptr<function, vec2f>, a: f32) {
    let c = cos(a);
    let s = sin(a);
    *p = c * (*p) + s * vec2f((*p).y, -(*p).x);
}

fn glsl_mod(x: f32, y: f32) -> f32 {
    return x - y * floor(x / y);
}

fn smax(a: f32, b: f32, r: f32) -> f32 {
    let u = max(vec2f(r + a, r + b), vec2f(0.0));
    return min(-r, max(a, b)) + length(u);
}

fn vmax2(v: vec2f) -> f32 {
    return max(v.x, v.y);
}

fn vmax3(v: vec3f) -> f32 {
    return max(max(v.x, v.y), v.z);
}

fn fBox2(p: vec2f, b: vec2f) -> f32 {
    let d = abs(p) - b;
    return length(max(d, vec2f(0.0))) + vmax2(min(d, vec2f(0.0)));
}

fn erot(p: vec3f, ax: vec3f, ro: f32) -> vec3f {
    return mix(dot(ax, p) * ax, p, cos(ro)) + sin(ro) * cross(ax, p);
}

fn pal(t: f32, a: vec3f, b: vec3f, c: vec3f, d: vec3f) -> vec3f {
    return a + b * cos(6.28318 * (c * t + d));
}

fn spectrum(n: f32) -> vec3f {
    return pal(n, vec3f(0.5), vec3f(0.5), vec3f(1.0), vec3f(0.0, 0.33, 0.67));
}

fn expImpulse(x: f32, k: f32) -> f32 {
    let h = k * x;
    return h * exp(1.0 - h);
}

fn boolSign(v: f32) -> f32 {
    return select(-1.0, 1.0, v >= 0.0);
}

fn boolSign3(v: vec3f) -> vec3f {
    return vec3f(
        select(-1.0, 1.0, v.x >= 0.0),
        select(-1.0, 1.0, v.y >= 0.0),
        select(-1.0, 1.0, v.z >= 0.0)
    );
}

fn icosahedronVertex(p: vec3f) -> vec3f {
    let ap = abs(p);
    var v = vec3f(PHI, 1.0, 0.0);
    if (ap.x + ap.z * PHI > dot(ap, v)) {
        v = vec3f(1.0, 0.0, PHI);
    }
    if (ap.z + ap.y * PHI > dot(ap, v)) {
        v = vec3f(0.0, PHI, 1.0);
    }
    return v * 0.52573111 * boolSign3(p);
}

fn dodecahedronVertex(p: vec3f) -> vec3f {
    let ap = abs(p);
    var v = vec3f(PHI);
    let v2 = vec3f(0.0, 1.0, PHI + 1.0);
    let v3 = v2.yzx;
    let v4 = v2.zxy;
    if (dot(ap, v2) > dot(ap, v)) { v = v2; }
    if (dot(ap, v3) > dot(ap, v)) { v = v3; }
    if (dot(ap, v4) > dot(ap, v)) { v = v4; }
    return v * 0.35682209 * boolSign3(p);
}

const OUTER: f32 = 0.35;
const INNER: f32 = 0.24;

fn object(p: vec3f) -> f32 {
    let d = length(p) - OUTER;
    return max(d, -d - (OUTER - INNER));
}

fn map_scene(p_in: vec3f, iTime: f32) -> vec2f {
    let scale: f32 = 2.5;
    var p = p_in / scale;

    let outerBound = length(p) - OUTER;
    let duration: f32 = 10.0 / 3.0;
    let time = glsl_mod(iTime / duration, 1.0);

    let spin = time * (PI / 2.0) - 0.15;
    var p_xz = p.xz;
    pR(&p_xz, spin);
    p = vec3f(p_xz.x, p.y, p_xz.y);

    var va = icosahedronVertex(p);
    var vb = dodecahedronVertex(p);

    let side = boolSign(dot(p, cross(va, vb)));
    let r = PI * 2.0 / 5.0 * side;
    var vc = erot(vb, va, r);
    var vd = erot(vb, va, -r);

    var d: f32 = 1e12;
    let pp = p;

    for (var i: i32 = 0; i < 4; i++) {
        let t = glsl_mod(time * 2.0 / 3.0 + 0.25 - dot(va.xy, vec2f(1.0, -1.0)) / 30.0, 1.0);
        let t2_raw = clamp(t * 5.0 - 1.7, 0.0, 1.0);
        var explode = 1.0 - pow(1.0 - t2_raw, 10.0);
        explode *= 1.0 - pow(t2_raw, 5.0);
        explode += (smoothstep(0.32, 0.34, t) - smoothstep(0.34, 0.5, t)) * 0.05;
        explode *= 1.4;

        let t2 = max(t - 0.53, 0.0) * 1.2;
        let wobble = sin(expImpulse(t2, 20.0) * 2.2 + pow(3.0 * t2, 1.5) * 2.0 * PI * 2.0 - PI) * smoothstep(0.4, 0.0, t2) * 0.2;
        let anim = wobble + explode;

        p -= va * anim / 2.8;

        let edgeA = dot(p, normalize(vb - va));
        let edgeB = dot(p, normalize(vc - va));
        let edgeC = dot(p, normalize(vd - va));
        let edge = max(max(edgeA, edgeB), edgeC) - 0.005;

        d = min(d, smax(object(p), edge, 0.002));
        p = pp;

        let va2 = va;
        va = vb;
        vb = vc;
        vc = vd;
        vd = va2;
    }

    let bound = outerBound - 0.002;
    if (bound * scale > 0.002) {
        d = min(d, bound);
    }

    return vec2f(d * scale, 1.0);
}

fn sphericalMatrix(tp: vec2f) -> mat3x3f {
    let theta = tp.x;
    let phi = tp.y;
    let cx = cos(theta);
    let cy = cos(phi);
    let sx = sin(theta);
    let sy = sin(phi);
    return mat3x3f(
        vec3f(cy, 0.0, sy),
        vec3f(-sy * -sx, cx, cy * -sx),
        vec3f(-sy * cx, sx, cy * cx)
    );
}

fn intersectPlane(rOrigin: vec3f, rayDir: vec3f, origin: vec3f, normal: vec3f, up: vec3f) -> vec3f {
    let d = dot(normal, (origin - rOrigin)) / dot(rayDir, normal);
    let point = rOrigin + d * rayDir - origin;
    let tangent = cross(normal, up);
    let bitangent = cross(normal, tangent);
    let uv = vec2f(dot(tangent, point), dot(bitangent, point));
    let hit = max(sign(d), 0.0);
    let l = smoothstep(0.75, 0.0, fBox2(uv, vec2f(0.5, 2.0)) - 1.0) * smoothstep(6.0, 0.0, length(uv));
    return vec3f(l) * hit;
}

fn light(origin_in: vec3f, rayDir_in: vec3f, envMat: mat3x3f) -> vec3f {
    let origin = -origin_in * envMat;
    let rayDir = -rayDir_in * envMat;
    let pos = vec3f(-6.0);
    return intersectPlane(origin, rayDir, pos, normalize(pos), normalize(vec3f(-1.0, 1.0, 0.0)));
}

fn env(origin_in: vec3f, rayDir_in: vec3f, envMat: mat3x3f) -> vec3f {
    let rayDir = -rayDir_in * envMat;
    let l = smoothstep(0.0, 1.7, dot(rayDir, vec3f(0.5, -0.3, 1.0))) * 0.4;
    return vec3f(l) * BGCOL;
}

fn normal(pos: vec3f, iTime: f32) -> vec3f {
    var n = vec3f(0.0);
    let e1 = vec3f(-0.5773, -0.5773, -0.5773);
    let e2 = vec3f(0.5773, -0.5773, 0.5773);
    let e3 = vec3f(-0.5773, 0.5773, 0.5773);
    let e4 = vec3f(0.5773, 0.5773, -0.5773);
    n += e1 * map_scene(pos + 0.001 * e1, iTime).x;
    n += e2 * map_scene(pos + 0.001 * e2, iTime).x;
    n += e3 * map_scene(pos + 0.001 * e3, iTime).x;
    n += e4 * map_scene(pos + 0.001 * e4, iTime).x;
    return normalize(n);
}

struct Hit {
    res: vec2f,
    p: vec3f,
    len: f32,
    steps: f32,
}

fn march(origin: vec3f, rayDir: vec3f, invert: f32, maxDist: f32, understep: f32, iTime: f32) -> Hit {
    var p = origin;
    var len: f32 = 0.0;
    var dist: f32 = 0.0;
    var res = vec2f(0.0);
    var steps: f32 = 0.0;

    for (var i: f32 = 0.0; i < 150.0; i += 1.0) {
        len += dist * understep;
        p = origin + len * rayDir;
        let candidate = map_scene(p, iTime);
        dist = candidate.x * invert;
        steps += 1.0;
        res = candidate;
        if (dist < 0.001) { break; }
        if (len >= maxDist) {
            len = maxDist;
            res.y = 0.0;
            break;
        }
    }
    return Hit(res, p, len, steps);
}

fn hash12(p: vec2f) -> f32 {
    return fract(sin(dot(p, vec2f(12.9898, 78.233))) * 43758.5453);
}

fn renderBuckyball(fragCoord: vec2f, resolution: vec2f, iTime: f32) -> vec4f {
    let envMat = sphericalMatrix(((vec2f(81.5, 119.0) / vec2f(187.0)) * 2.0 - vec2f(1.0)) * 2.0);
    let uv = (2.0 * fragCoord - resolution) / resolution.y;

    let camOrigin = vec3f(0.0, 0.0, 9.5);
    let camDir = normalize(vec3f(uv * 0.168, -1.0));

    var invert: f32 = 1.0;
    let maxDist: f32 = 15.0;

    let firstHit = march(camOrigin, camDir, invert, maxDist, 0.8, iTime);
    let firstLen = firstHit.len;

    var col = vec3f(0.0);
    let bgCol = BGCOL;

    for (var disperse: f32 = 0.0; disperse < MAX_DISPERSE; disperse += 1.0) {
        invert = 1.0;
        var sam = vec3f(0.0);

        var origin = camOrigin;
        var rayDir = camDir;
        var extinctionDist: f32 = 0.0;
        var wavelength = disperse / MAX_DISPERSE;

        let rand = hash12(fragCoord + vec2f(floor(iTime * 60.0) * 10.0));
        wavelength += (rand * 2.0 - 1.0) * (0.5 / MAX_DISPERSE);

        var bounceCount: f32 = 0.0;

        for (var bounce: f32 = 0.0; bounce < MAX_BOUNCE; bounce += 1.0) {
            var hit: Hit;
            if (bounce == 0.0) {
                hit = firstHit;
            } else {
                hit = march(origin, rayDir, invert, maxDist / 2.0, 1.0, iTime);
            }

            let res = hit.res;
            let p = hit.p;

            if (invert < 0.0) {
                extinctionDist += hit.len;
            }

            if (res.y == 0.0) { break; }

            let nor = normal(p, iTime) * invert;
            let refl_dir = reflect(rayDir, nor);

            sam += light(p, refl_dir, envMat) * 0.5;
            sam += pow(max(1.0 - abs(dot(rayDir, nor)), 0.0), 5.0) * 0.1;
            sam *= vec3f(0.85, 0.85, 0.98);

            let ior_base = mix(1.2, 1.8, wavelength);
            let ior = select(1.0 / ior_base, ior_base, invert < 0.0);
            let raf = refract(rayDir, nor, ior);
            let tif = length(raf) == 0.0;
            rayDir = select(raf, refl_dir, tif);

            let offset = 0.01 / abs(dot(rayDir, nor));
            origin = p + offset * rayDir;
            invert *= -1.0;
            bounceCount = bounce;
        }

        sam += select(env(camOrigin, rayDir, envMat), bgCol, bounceCount == 0.0);

        if (bounceCount == 0.0) {
            col += sam * MAX_DISPERSE / 2.0;
            break;
        } else {
            col += sam * spectrum(-wavelength + 0.25);
        }
    }

    col /= MAX_DISPERSE;
    let depth = clamp((firstLen - 4.0) / 8.0, 0.0, 1.0);
    return vec4f(col, depth);
}

fn tonemap2(texColor_in: vec3f) -> vec3f {
    var texColor = texColor_in * 2.5;
    let x = max(vec3f(0.0), texColor - vec3f(0.004));
    return (x * (vec3f(6.2) * x + vec3f(0.5))) / (x * (vec3f(6.2) * x + vec3f(1.7)) + vec3f(0.06));
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let resolution = view.viewport.zw;
    let fragCoord = vec2f(in.uv.x, 1.0 - in.uv.y) * resolution;
    let iTime = globals.time;

    let renderRes = renderBuckyball(fragCoord, resolution, iTime);
    var col = renderRes.rgb;

    col = tonemap2(col);

    // Moody contrast: deep dark space with rich crystalline jewel highlights
    var rgb = clamp(col, vec3f(0.0), vec3f(1.0));
    rgb = pow(rgb, vec3f(1.2)) * 0.95;
    rgb = clamp(rgb, vec3f(0.0), vec3f(1.0));

    return vec4f(rgb, 1.0);
}
