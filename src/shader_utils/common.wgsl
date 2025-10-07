#define_import_path shadplay::shader_utils::common

// The circle family
const PI:f32  =         3.14159265359;
const HALF_PI: f32 =         1.57079632679;
const NEG_HALF_PI: f32 =    -1.57079632679;
const NEG_QUARTER_PI: f32 = -0.78539816339;
const QUARTER_PI: f32 =     0.78539816339;  // Fixed: was negative but should be positive
const TAU:f32 =         6.28318530718;

// Euler's number / Napier's constant
const E: f32 =          2.71828182845;

// Pythagoras' constants
const SQRT_OF_2:f32 =   1.41421356237;
const SQRT_OF_3:f32 =   1.73205080756;

// The golden ratio
const PHI:f32 =         1.61803398874;

/// Turn your `uv` coords into polar coords
fn intoPolar(uv: vec2<f32>)-> vec2<f32>{
    return vec2f(atan2(uv.x, uv.y), length(uv));
}

/// Clockwise by `theta`
fn rotate2D(theta: f32) -> mat2x2<f32> {
    let c = cos(theta);
    let s = sin(theta);
    return mat2x2<f32>(c, s, -s, c);
}

/// Move from the HueSaturationValue to RedGreenBlue
fn hsv2rgb(c: vec3f) -> vec3f {
    var rgb: vec3f = clamp(
        abs((c.x * 6.0 + vec3f(0.0, 4.0, 2.0)) % 6.0 - 3.0) - 1.0,
        vec3f(0.0),
        vec3f(1.0)
    );
    return c.z * mix(vec3f(1.0), rgb, c.y);
}

// Signed distance field for a 2D circle
fn sd_circle(pt: vec2f, radius: f32) -> f32 {
    return length(pt) - radius;
}

/// This is the default (and rather pretty) shader you start with in ShaderToy
fn shader_toy_default(t: f32, uv: vec2f) -> vec3f {
    var col = vec3f(0.0);
    let v = vec3(t) + vec3(uv.xyx) + vec3(0., 2., 4.);
    return 0.5 + 0.5 * cos(v);
}

fn dist_line(ray_origin: vec3f, ray_dir: vec3f, pt: vec3f) -> f32 {
    return length(cross(pt - ray_origin, ray_dir)) / length(ray_dir);
}

fn sd_capsule(p: vec3f, a: vec3f, b: vec3f, r: f32) -> f32 {
    let pa = p - a;
    let ba = b - a;
    let h = clamp(dot(pa, ba) / dot(ba, ba), 0., 1.);
    return length(pa - ba * h) - r;
}

fn sd_capped_cylinder(p: vec3f, h: vec2f) -> f32 {
    let d: vec2f = abs(vec2f(length(p.xz), p.y)) - h;
    return min(max(d.x, d.y), 0.0) + length(max(d, vec2f(0.0)));
}

fn sd_torus(p: vec3f, t: vec2f) -> f32 {
    let q: vec2f = vec2f(length(p.xz) - t.x, p.y);
    return length(q) - t.y;
}

// License: MIT, author: Inigo Quilez, found: https://iquilezles.org/www/articles/distfunctions2d/distfunctions2d.htm
fn sd_hexagon(p: vec2f, r: f32) -> f32 {
    let k = vec3f(-0.866025404, 0.5, 0.577350269);
    var q: vec2f = abs(p);
    q = q - 2. * min(dot(k.xy, q), 0.) * k.xy;
    q = q - vec2f(clamp(q.x, -k.z * r, k.z * r), r);
    return length(q) * sign(q.y);
}

/// Signed distance field for a Sphere (3d)
fn sd_sphere(p: vec3f, radius: f32) -> f32 {
    return (length(p) - radius);
}

// Hexagonal tiling
fn hextile(_p: vec2f) -> vec2f {
    // See Art of Code: Hexagonal Tiling Explained!
    // https://www.youtube.com/watch?v=VmrIDyYiJBA
    var p = _p;

    // Define constants
    let sz: vec2f = vec2f(1.0, sqrt(3.0));
    let hsz: vec2f = 0.5 * sz;

    // Calculate p1 and p2
    let p1: vec2f = (p % sz) - hsz;
    let p2: vec2f = ((p - hsz) % sz) - hsz;

    // Choose p3 based on dot product
    var p3: vec2f = vec2(0.);
    if dot(p1, p1) < dot(p2, p2) {
        p3 = p1;
    } else {
        p3 = p2;
    }

    // Calculate n
    var n: vec2f = ((p3 - p + hsz) / sz);
    p = p3;

    // Adjust n and round for well-behaved hextile 0,0
    n -= vec2(0.5);
    return round(n * 2.0) * 0.5;
} 

// From : https://www.shadertoy.com/view/tsBXW3
fn hash(x: f32) -> f32 {
    return (fract(sin(x) * 152754.742));
}

/// Signed distance field for a Bezier curve.
fn sd_bezier(p: vec2f, A: vec2f, B: vec2f, C: vec2f) -> vec2f {
    let a = B - A;
    let b = A - 2. * B + C;
    let c = a * 2.;
    let d = A - p;
    let kk = 1. / dot(b, b);
    let kx = kk * dot(a, b);
    let ky = kk * (2. * dot(a, a) + dot(d, b)) / 3.;
    let kz = kk * dot(d, a);

    let p1 = ky - kx * kx;
    let p3 = p1 * p1 * p1;
    let q = kx * (2.0 * kx * kx - 3.0 * ky) + kz;
    var h: f32 = q * q + 4. * p3;

    var res: vec2f;
    if h >= 0. {
        h = sqrt(h);
        let x = (vec2f(h, -h) - q) / 2.;
        let uv = sign(x) * pow(abs(x), vec2f(1. / 3.));
        let t = clamp(uv.x + uv.y - kx, 0., 1.);
        let f = d + (c + b * t) * t;
        res = vec2f(dot(f, f), t);
    } else {
        let z = sqrt(-p1);
        let v = acos(q / (p1 * z * 2.)) / 3.;
        let m = cos(v);
        let n = sin(v) * 1.732050808;
        let t = clamp(vec2f(m + m, -n - m) * z - kx, vec2f(0.0), vec2f(1.0));
        let f = d + (c + b * t.x) * t.x;
        var dis: f32 = dot(f, f);
        res = vec2f(dis, t.x);

        let g = d + (c + b * t.y) * t.y;
        dis = dot(g, g);
        res = select(res, vec2f(dis, t.y), dis < res.x);
    }
    res.x = sqrt(res.x);
    return res;
}


/// coff
fn coff(h: f32, time: f32) -> vec2<f32> {
    let h0: f32 = h;
    let h1: f32 = fract(h0 * 9677.0);
    let h2: f32 = fract(h0 * 8677.0);
    let t: f32 = mix(0.5, 1.0, h2 * h2) * time + 1234.5 * h0;
    return mix(vec2<f32>(0.1, 0.1), vec2<f32>(0.2, 0.2), h1 * h1) * sin(t * vec2<f32>(1.0, sqrt(0.5)));
}

/// approx aces colour-space
fn aces_approx(_v: vec3<f32>) -> vec3<f32> {
    var v = max(_v, vec3<f32>(0.0, 0.0, 0.0));
    v *= 0.6;
    let a: f32 = 2.51;
    let b: f32 = 0.03;
    let c: f32 = 2.43;
    let d: f32 = 0.59;
    let e: f32 = 0.14;
    return clamp((v * (a * v + b)) / (v * (c * v + d) + e), vec3<f32>(0.0, 0.0, 0.0), vec3<f32>(1.0, 1.0, 1.0));
}
