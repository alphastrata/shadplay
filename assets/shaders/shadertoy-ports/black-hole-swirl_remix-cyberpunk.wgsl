// Remix #1: Dynamic Neon / Cyberpunk Color Palette & Energy Shift
// Ref - https://x.com/cmzw_/status/1787147460772864188 (celestianmaze)
// Ported & Remixed for shadplay

#import bevy_sprite::mesh2d_view_bindings::globals 
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

fn glsl_mod(x: vec4f, y: f32) -> vec4f {
    return x - y * floor(x / y);
}

fn glsl_mod3(x: vec3f, y: f32) -> vec3f {
    return x - y * floor(x / y);
}

fn permute_3d(x: vec4f) -> vec4f {
    return glsl_mod((x * 34.0 + vec4f(1.0)) * x, 289.0);
}

fn taylorInvSqrt3d(r: vec4f) -> vec4f {
    return vec4f(1.79284291400159) - 0.85373472095314 * r;
}

fn simplexNoise3d(v: vec3f) -> f32 {
    let C = vec2f(1.0 / 6.0, 1.0 / 3.0);
    let D = vec4f(0.0, 0.5, 1.0, 2.0);

    var i = floor(v + vec3f(dot(v, vec3f(C.y))));
    let x0 = v - i + vec3f(dot(i, vec3f(C.x)));

    let g = step(x0.yzx, x0.xyz);
    let l = vec3f(1.0) - g;
    let i1 = min(g.xyz, l.zxy);
    let i2 = max(g.xyz, l.zxy);

    let x1 = x0 - i1 + vec3f(C.x);
    let x2 = x0 - i2 + 2.0 * vec3f(C.x);
    let x3 = x0 - vec3f(1.0) + 3.0 * vec3f(C.x);

    i = glsl_mod3(i, 289.0);
    let p = permute_3d(permute_3d(permute_3d(i.z + vec4f(0.0, i1.z, i2.z, 1.0)) + i.y + vec4f(0.0, i1.y, i2.y, 1.0)) + i.x + vec4f(0.0, i1.x, i2.x, 1.0));

    let n_ = 1.0 / 7.0;
    let ns = n_ * vec3f(D.w, D.y, D.z) - vec3f(D.x, D.z, D.x);

    let j = p - 49.0 * floor(p * ns.z * ns.z);

    let x_ = floor(j * ns.z);
    let y_ = floor(j - 7.0 * x_);

    let x = x_ * ns.x + vec4f(ns.y);
    let y = y_ * ns.x + vec4f(ns.y);
    let h = vec4f(1.0) - abs(x) - abs(y);

    let b0 = vec4f(x.xy, y.xy);
    let b1 = vec4f(x.zw, y.zw);

    let s0 = floor(b0) * 2.0 + vec4f(1.0);
    let s1 = floor(b1) * 2.0 + vec4f(1.0);
    let sh = -step(h, vec4f(0.0));

    let a0 = b0.xzyw + s0.xzyw * sh.xxyy;
    let a1 = b1.xzyw + s1.xzyw * sh.zzww;

    var p0 = vec3f(a0.xy, h.x);
    var p1 = vec3f(a0.zw, h.y);
    var p2 = vec3f(a1.xy, h.z);
    var p3 = vec3f(a1.zw, h.w);

    let norm = taylorInvSqrt3d(vec4f(dot(p0, p0), dot(p1, p1), dot(p2, p2), dot(p3, p3)));
    p0 *= norm.x;
    p1 *= norm.y;
    p2 *= norm.z;
    p3 *= norm.w;

    var m = max(vec4f(0.6) - vec4f(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3)), vec4f(0.0));
    m = m * m;
    return 42.0 * dot(m * m, vec4f(dot(p0, x0), dot(p1, x1), dot(p2, x2), dot(p3, x3)));
}

fn fbm3d(x_in: vec3f, it: i32) -> f32 {
    var v: f32 = 0.0;
    var a: f32 = 0.5;
    let shift = vec3f(100.0);
    var x = x_in;

    for (var i: i32 = 0; i < 32; i++) {
        if (i < it) {
            v += a * simplexNoise3d(x);
            x = x * 2.0 + shift;
            a *= 0.5;
        }
    }
    return v;
}

fn rotateZ(v: vec3f, angle: f32) -> vec3f {
    let cosAngle = cos(angle);
    let sinAngle = sin(angle);
    return vec3f(
        v.x * cosAngle - v.y * sinAngle,
        v.x * sinAngle + v.y * cosAngle,
        v.z
    );
}

fn facture(vector: vec3f) -> f32 {
    let normalizedVector = normalize(vector);
    return max(max(normalizedVector.x, normalizedVector.y), normalizedVector.z);
}

// Cosine color palette for dynamic cyberpunk / neon shifting
fn palette(t: f32) -> vec3f {
    let a = vec3f(0.5, 0.5, 0.5);
    let b = vec3f(0.5, 0.5, 0.5);
    let c = vec3f(1.0, 1.0, 1.0);
    let d = vec3f(0.0, 0.333, 0.667);
    return a + b * cos(6.28318 * (c * t + d));
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let resolution = view.viewport.zw;
    let fragCoord = vec2f(in.uv.x, 1.0 - in.uv.y) * resolution;
    let iTime = globals.time;

    let uv = (fragCoord * 2.0 - resolution) / resolution.y;

    var color = vec3f(uv.xy, 0.0);
    color.z += 0.5;

    color = normalize(color);
    color -= 0.2 * vec3f(0.0, 0.0, iTime);

    let angle = -log2(length(uv));

    color = rotateZ(color, angle);

    let frequency: f32 = 1.4;
    let distortion: f32 = 0.01;
    color.x = fbm3d(color * frequency + vec3f(0.0), 5) + distortion;
    color.y = fbm3d(color * frequency + vec3f(1.0), 5) + distortion;
    color.z = fbm3d(color * frequency + vec3f(2.0), 5) + distortion;

    var noiseColor = color;
    noiseColor *= 2.0;
    noiseColor -= vec3f(0.1);
    noiseColor *= 0.188;
    noiseColor += vec3f(uv.xy, 0.0);

    var noiseColorLength = length(noiseColor);
    noiseColorLength = 0.770 - noiseColorLength;
    noiseColorLength *= 4.2;
    noiseColorLength = pow(max(0.0, noiseColorLength), 1.0);

    // REMIX #1: Dynamic Neon Palette shifting over time & noise length
    let dynamicColor = palette(noiseColorLength * 0.5 + iTime * 0.1);
    let emissionColor = dynamicColor * (noiseColorLength * 0.8 + 0.2);

    var fac = length(uv) - facture(color + vec3f(0.32));
    fac += 0.1;
    fac *= 3.0;

    color = mix(emissionColor, vec3f(fac), fac + 1.2);

    return vec4f(color, 1.0);
}
