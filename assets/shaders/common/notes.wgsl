

fn trace(origin: vec3f, r: vec3f) -> f32 {
    var t = 0.0;
    for (var i = 0; i < 64; i++) {
        let p = origin + r * t;
        let d = mmap(p);
        t += d * 0.22;
    }
    return t ;
}

fn mmap(p: vec3f) -> f32 {
    var p = p;
    var q = p;
    var qa = p;

    q = pmod3(q, vec3f(0.8, 1.0, 0.23));
    qa = pmod3(qa, vec3f(0.8, 1.0, 0.18));
    p.x = pmod1(p.x, 1.0);

    let s1 = sd_sphere(p, 0.75);
    let s2 = sd_sphere(q, 0.5);
    let s3 = sd_sphere(qa, 0.555);

    return min(min(s1, s2), s3);
}

fn pmod1(in: f32, size: f32) -> f32 {
    let halfsize = size * 0.5;
    return (in + halfsize % size) - halfsize;
}

fn pmod3(in: vec3f, size: vec3f) -> vec3f {
    let out = (in % size * 0.5) - (size * 0.5);

    return out;
}

fn sd_sphere(p: vec3f, radius: f32) -> f32 {
    return (length(p) - radius);
}


// fn fade(col: vec4f, uv: vec2f) {
//     let fade = max(abs(uv.x), abs(uv.y)) - 1.0 ; // This is really cool.
//     let col = col * (fade / (0.005 + fade));
//     return col;
// }

fn hsv2rgb(c: vec3f) -> vec3f {
    var rgb: vec3f = clamp(
        abs((c.x * 6.0 + vec3f(0.0, 4.0, 2.0)) % 6.0 - 3.0) - 1.0,
        vec3f(0.0),
        vec3f(1.0)
    );
    return c.z * mix(vec3f(1.0), rgb, c.y);
}

fn gradient(t: f32) -> vec3f {
    let h: f32 = 0.6666 * (1.0 - t * t);
    let s: f32 = 0.75;
    let v: f32 = 1.0 - 0.9 * (1.0 - t) * (1.0 - t);
    return hsv2rgb(vec3f(h, s, v));
}

/// MISC:
// License: MIT, author: Inigo Quilez, found: https://iquilezles.org/www/articles/distfunctions2d/distfunctions2d.htm
fn sd_hexagon(p: vec2f, r: f32) -> f32 {
    let k = vec3f(-0.866025404, 0.5, 0.577350269);
    var q: vec2f = abs(p);
    q = q - 2. * min(dot(k.xy, q), 0.) * k.xy;
    q = q - vec2f(clamp(q.x, -k.z * r, k.z * r), r);
    return length(q) * sign(q.y);
}

// Translate the GLSL hextile function to WGSL
fn hextile(p: vec2f) -> vec2f {
    // See Art of Code: Hexagonal Tiling Explained!
    // https://www.youtube.com/watch?v=VmrIDyYiJBA
    var p = p;

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

// NOTE: swapped the hash
// fn hash(pp: vec2<f32>) -> f32 { //NOTE: from some other tutorial/bevy code?
//     var p3 = fract(vec3(pp.xyx) * 0.1031);
//     p3 += dot(p3, p3.yzx + 33.33);
//     return fract((p3.x + p3.y) * p3.z);
// }
fn hash(co: vec2f) -> f32 {
    // Add a constant
    let co: vec2f = co + 1.234;

    // Calculate and return the fractal part of a sine function
    return fract(sin(dot(co.xy, vec2f(12.9898, 58.233))) * 13758.5453);
}


fn off6(n: f32) -> vec2<f32> {
    return vec2<f32>(1.0, 0.0) * rotate2D(n * TAU / 6.0);
}

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


fn coff(h: f32, time: f32) -> vec2<f32> {
    let h0: f32 = h;
    let h1: f32 = fract(h0 * 9677.0);
    let h2: f32 = fract(h0 * 8677.0);
    let t: f32 = mix(0.5, 1.0, h2 * h2) * time + 1234.5 * h0;
    return mix(vec2<f32>(0.1, 0.1), vec2<f32>(0.2, 0.2), h1 * h1) * sin(t * vec2<f32>(1.0, sqrt(0.5)));
}

fn aces_approx(v: vec3<f32>) -> vec3<f32> {
    var v = max(v, vec3<f32>(0.0, 0.0, 0.0));
    v *= 0.6;
    let a: f32 = 2.51;
    let b: f32 = 0.03;
    let c: f32 = 2.43;
    let d: f32 = 0.59;
    let e: f32 = 0.14;
    return clamp((v * (a * v + b)) / (v * (c * v + d) + e), vec3<f32>(0.0, 0.0, 0.0), vec3<f32>(1.0, 1.0, 1.0));
}

fn to_smith(p: vec2<f32>) -> vec2<f32> {
    let d: f32 = (1.0 - p.x) * (1.0 - p.x) + p.y * p.y;
    let x: f32 = (1.0 + p.x) * (1.0 - p.x) - p.y * p.y;
    let y: f32 = 2.0 * p.y;
    return vec2<f32>(x, y) / d;
}

fn from_smith(p: vec2<f32>) -> vec2<f32> {
    let d: f32 = (p.x + 1.0) * (p.x + 1.0) + p.y * p.y;
    let x: f32 = (p.x + 1.0) * (p.x - 1.0) + p.y * p.y;
    let y: f32 = 2.0 * p.y;
    return vec2<f32>(x, y) / d;
}


/// Clockwise by `theta`
fn rotate2D(theta: f32) -> mat2x2<f32> {
    let c = cos(theta);
    let s = sin(theta);
    return mat2x2<f32>(c, s, -s, c);
}


fn transform(p: vec2<f32>, TIME: f32) -> vec2<f32> {
    var p = p * 2.0;
    let sp0: vec2<f32> = to_smith(p - vec2<f32>(0.0, 0.0));
    let sp1: vec2<f32> = to_smith(p + vec2<f32>(1.0) * rotate2D(0.12 * TIME));
    let sp2: vec2<f32> = to_smith(p - vec2<f32>(1.0) * rotate2D(0.23 * TIME));
    p = from_smith(sp0 + sp1 - sp2);
    return p;
}
