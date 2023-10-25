/// ***************************** ///
/// This is a port of 'Sailing beyond' by patu https://www.shadertoy.com/view/4t2cR1
/// ***************************** ///

#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_sprite::mesh2d_view_bindings globals 
#import shadplay::shader_utils::common rotate2D, PI, TAU

#import bevy_render::view  View
@group(0) @binding(0) var<uniform> view: View;

const FAR: f32 = 1e3;
const INFINITY: f32 = 1e32;
const MAX_ITERATIONS: i32 = 1000;
const FOV: f32 = 38.0;
const FOG: f32 = 0.6;
const PHI: f32 = 1.618033988749895;

struct Geometry {
    dist: f32,
    hit: vec3<f32>,
    iterations: i32,
}

// Converts degrees to radians
fn d2r(angle: f32) -> f32 {
    return angle * PI / 180.0;
}

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    let resolution = view.viewport.zw;
    var uv = (in.uv * 2.0) - 1.0;

    uv *= tan(d2r(FOV) / 2.0) * 4.0;

    let vuv: vec3<f32> = normalize(vec3<f32>(cos(globals.time), sin(globals.time * 0.11), sin(globals.time * 0.41))); // up
    var ro: vec3<f32> = vec3<f32>(0.0, 30.0 + globals.time * 100.0, -0.1);

    ro.x += yC(ro.y * 0.1) * 3.0;
    ro.z -= yC(ro.y * 0.01) * 4.0;

    var vrp: vec3<f32> = vec3<f32>(0.0, 50.0 + globals.time * 100.0, 2.0);

    vrp.x += yC(vrp.y * 0.1) * 3.0;
    vrp.z -= yC(vrp.y * 0.01) * 4.0;

    let vpn: vec3<f32> = normalize(vrp - ro);
    let u: vec3<f32> = normalize(cross(vuv, vpn));
    let v: vec3<f32> = cross(vpn, u);
    let vcv: vec3<f32> = ro + vpn;
    let scrCoord: vec3<f32> = vcv + uv.x * u * resolution.x / resolution.y + uv.y * v;
    let rd: vec3<f32> = normalize(scrCoord - ro);
    let oro: vec3<f32> = ro;

    var sceneColor: vec3<f32> = vec3<f32>(0.0);

    var tr: Geometry = trace(ro, rd);

    tr.hit = ro + rd * tr.dist;

    var col: vec3<f32> = vec3<f32>(1.0, 0.5, 0.4) * fbm(tr.hit.xzy * 0.01) * 20.0;
    col.b *= fbm(tr.hit * 0.01) * 10.0;

    sceneColor += min(0.8, f32(tr.iterations) / 90.0) * col + col * 0.03;
    sceneColor *= 1.0 + 0.9 * (abs(fbm(tr.hit * 0.002 + 3.0) * 10.0) * fbm(vec3<f32>(0.0, 0.0, globals.time * 0.05) * 2.0)) * 1.0;
    sceneColor = pow(sceneColor, vec3<f32>(1.0)) * 0.6; // Adjusted the iChannelTime logic

    var steamColor1: vec3<f32> = vec3<f32>(0.0, 0.4, 0.5);
    var rro: vec3<f32> = oro;

    ro = tr.hit;

    var distC: f32 = tr.dist;
    var f: f32 = 0.0;
    let st: f32 = 0.9;

    for (var i: i32 = 0; i < 24; i = i + 1) {
        rro = ro - rd * distC;
        f += fbm(rro * vec3<f32>(0.1, 0.1, 0.1) * 0.3) * 0.1;
        distC -= 3.0;
        if (distC < 3.0) {
            break;
        }
    }

    steamColor1 *= 1.0; 
    sceneColor += steamColor1 * pow(abs(f * 1.5), 3.0) * 4.0;

    var fragColor: vec4<f32> = vec4<f32>(clamp(sceneColor * (1.0 - length(uv) / 2.0), vec3<f32>(0.0, 0.0, 0.0), vec3<f32>(1.0, 1.0, 1.0)), 1.0);
    fragColor = pow(abs(fragColor / tr.dist * 130.0), vec4<f32>(0.8));
    return fragColor;
}

// Hash 2 into 1
fn hash12(p: vec2<f32>) -> f32 {
    let h: f32 = dot(p, vec2<f32>(127.1, 311.7));
    return fract(sin(h) * 43758.5453123);
}

// 3D noise function
fn noise_3(p: vec3<f32>) -> f32 {
    let i: vec3<f32> = floor(p);
    var f: vec3<f32> = fract(p);
    f -= vec3<f32>(1.0, 1.0, 1.0); // Decrement each component of the vector by 1
    var u: vec3<f32> = 1.0 - f * f * f * f * -f;

    let ii: vec2<f32> = i.xy + i.z * vec2<f32>(5.0, 5.0);
    let a: f32 = hash12(ii + vec2<f32>(0.0, 0.0));
    let b: f32 = hash12(ii + vec2<f32>(1.0, 0.0));
    let c: f32 = hash12(ii + vec2<f32>(0.0, 1.0));
    let d: f32 = hash12(ii + vec2<f32>(1.0, 1.0));
    let v1: f32 = mix(mix(a, b, u.x), mix(c, d, u.x), u.y);

    let new_ii: vec2<f32> = ii + vec2<f32>(5.0, 5.0);
    let a_new: f32 = hash12(new_ii + vec2<f32>(0.0, 0.0));
    let b_new: f32 = hash12(new_ii + vec2<f32>(1.0, 0.0));
    let c_new: f32 = hash12(new_ii + vec2<f32>(0.0, 1.0));
    let d_new: f32 = hash12(new_ii + vec2<f32>(1.0, 1.0));
    let v2: f32 = mix(mix(a_new, b_new, u.x), mix(c_new, d_new, u.x), u.y);

    return max(mix(v1, v2, u.z), 0.0);
}

// Computes the Fractional Brownian Motion value
fn fbm(position: vec3<f32>) -> f32 {
    var result: f32 = 0.0;
    var weight: f32 = 1.0;
    var scale: f32 = 1.0;
    for (var i: i32 = 0; i < 4; i = i + 1) {
        weight *= 0.25;
        scale *= 3.0;
        result += weight * noise_3(scale * position);
    }
    return result;
}

// Computes the y-coordinate based on x
fn yC(x: f32) -> f32 {
    let cosine_val: f32 = cos(x * -0.134);
    let sine_val: f32 = sin(x * 0.13);
    let fbm_val: f32 = fbm(vec3<f32>(x * 0.1, 0.0, 0.0) * 55.4);
    return cosine_val * 1.0 * sine_val * 15.0 + fbm_val;
}

// Rotates a 2D point by an angle
fn pR(out_point: vec2<f32>, angle: f32) -> vec2f {
    var point = out_point;
    point = cos(angle) * point + sin(angle) * vec2<f32>(point.y, -point.x);
    return point;
}

// Computes the distance to an infinite cylinder
fn f_cylinder_inf(p: vec3<f32>, r: f32) -> f32 {
    return length(vec2<f32>(p.x, p.z)) - r;
}

// Maps the geometry based on the input position
fn map(p: vec3<f32>) -> Geometry {
    var position = p;
    position.x -= yC(position.y * 0.1) * 3.0;
    position.z += yC(position.y * 0.01) * 4.0;

    let noise_val: f32 = pow(abs(fbm(position * 0.06)) * 12.0, 1.3);
    let s: f32 = fbm(position * 0.01 + vec3<f32>(0.0, globals.time * 0.14, 0.0)) * 128.0;

    var obj: Geometry;

    obj.dist = max(0.0, -f_cylinder_inf(position, s + 18.0 - noise_val));

    position.x -= sin(position.y * 0.02) * 34.0 + cos(position.z * 0.01) * 62.0;

    obj.dist = max(obj.dist, -f_cylinder_inf(position, s + 28.0 + noise_val * 2.0));

    return obj;
}

// Traces the geometry based on the input origin and direction
fn trace(o: vec3<f32>, d: vec3<f32>) -> Geometry {
    let t_min: f32 = 10.0;
    let t_max: f32 = FAR;
    var omega: f32 = 1.3;
    var t: f32 = t_min;
    var candidate_error: f32 = INFINITY;
    var candidate_t: f32 = t_min;
    var previousRadius: f32 = 0.0;
    var stepLength: f32 = 0.0;
    let pixelRadius: f32 = 1.0 / 1000.0;

    var mp: Geometry = map(o);

    var functionSign: f32;
    if mp.dist < 0.0 {
        functionSign = -1.0;
    } else {
        functionSign = 1.0;
    };

    var minDist: f32 = FAR;

    for (var i: i32 = 0; i < MAX_ITERATIONS; i = i + 1) {
        mp = map(d * t + o);
        mp.iterations = i;

        let signedRadius: f32 = functionSign * mp.dist;
        let radius: f32 = abs(signedRadius);
        let sorFail: bool = omega > 1.0 && (radius + previousRadius) < stepLength;

        if sorFail {
            stepLength -= omega * stepLength;
            omega = 1.0;
        } else {
            stepLength = signedRadius * omega;
        }
        previousRadius = radius;
        let error: f32 = radius / t;

        if !sorFail && error < candidate_error {
            candidate_t = t;
            candidate_error = error;
        }

        if !sorFail && error < pixelRadius || t > t_max {
            break;
        }

        t += stepLength * 0.5;
    }

    mp.dist = candidate_t;

    if t > t_max || candidate_error > pixelRadius {
        mp.dist = INFINITY;
    }

    return mp;
}
