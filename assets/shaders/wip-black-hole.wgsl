/// Spin a sphere..
/// Trying to understand rotating something I draw in its 3d space, rotate2D is very useful, I want to rotate3D now.

#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_sprite::mesh2d_view_bindings globals 
#import bevy_pbr::utils PI

#import bevy_render::view  View
@group(0) @binding(0) var<uniform> view: View;

const HEIGHT:f32 = 4.128;
const INTENSITY:f32 = 5.0;
const NUM_LINES:f32 = 4.0;
const SPEED:f32 = 0.20;
const CAM_DISTANCE: f32 = -2.;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    // ensure our uv coords match shadertoy/the-lil-book-of-shaders
    var uv = (in.uv * 2.0) - 1.0;
    let resolution = view.viewport.zw;
    let t = globals.time * SPEED;
    uv.x *= resolution.x / resolution.y;
    uv *= rotate2D(PI / -2.0);

    // BlackHole starts here:
    var pp: vec2<f32> = uv.xy / resolution.xy;
    pp = -1.0 + 2.0 * pp;
    pp.x *= resolution.x / resolution.y;

    let lookAt: vec3<f32> = vec3<f32>(0.0, -0.1, 0.0);

    let eyer: f32 = 2.0;
    let eyea: f32 = PI * 2.0;
    let eyea2: f32 = 0.24 * PI * 2.0;

    let ro: vec3<f32> = vec3<f32>(
        eyer * cos(eyea) * sin(eyea2),
        eyer * cos(eyea2),
        eyer * sin(eyea) * sin(eyea2)
    ); // camera position

    let front: vec3<f32> = normalize(lookAt - ro);
    let left: vec3<f32> = normalize(cross(normalize(vec3<f32>(0.0, 1.0, -0.1)), front));
    let up: vec3<f32> = normalize(cross(front, left));
    let rd: vec3<f32> = normalize(front * 1.5 + left * pp.x + up * pp.y); // rect vector

    let bh: vec3<f32> = vec3<f32>(0.0, 0.0, 0.0);
    let bhr: f32 = 0.1;
    var bhmass: f32 = 5.0;
    bhmass *= 0.001; // premul G

    var p: vec3<f32> = ro;
    var pv: vec3<f32> = rd;
    let dt: f32 = 0.02;

    var col: vec3<f32> = vec3<f32>(0.0);

    var noncaptured: f32 = 1.0;

    let c1: vec3<f32> = vec3<f32>(0.5, 0.46, 0.4);
    let c2: vec3<f32> = vec3<f32>(1.0, 0.8, 0.6);

    for (var t: f32 = 0.0; t < 1.0; t += 0.005) {
        p += pv * dt * noncaptured;

        // gravity
        let bhv: vec3<f32> = bh - p;
        let r: f32 = dot(bhv, bhv);
        pv += normalize(bhv) * (bhmass / r);

        noncaptured = smoothstep(0.0, 0.666, sdSphere(p - bh, bhr));

        // Texture for the accretion disc
        let dr: f32 = length(bhv.xz);
        let da: f32 = atan2(bhv.x, bhv.z);
        var ra: vec2<f32> = vec2<f32>(dr, da * (0.01 + (dr - bhr) * 0.002) + 2.0 * PI + t * 0.005);
        ra *= vec2<f32>(10.0, 20.0);


        // let dcol: vec3<f32> = mix(c2, c1, pow(length(bhv) - bhr, 2.0));

        // col += max(vec3<f32>(0.0), dcol * smoothstep(0.0, 1.0, -sdTorus((p * vec3<f32>(1.0, 25.0, 1.0)) - bh, vec2<f32>(0.8, 0.99))) * noncaptured);

        let torusPosition: vec3<f32> = (p * vec3<f32>(1.0, 25.0, 1.0)) - bh;
        let torusDistance: f32 = -sdTorus(torusPosition, vec2<f32>(0.8, 0.99));
        let torusSmoothStep: f32 = smoothstep(0.0, 1.0, torusDistance);
        let torusMaxed: vec3<f32> = max(vec3<f32>(0.0), vec3f(0.812)* torusSmoothStep);
        col += torusMaxed * noncaptured;
        // col += max(vec3<f32>(0.0), dcol * smoothstep(0.0, 1.0, -sdTorus((p * vec3<f32>(1.0, 25.0, 1.0)) - bh, vec2<f32>(0.8, 0.99))) * noncaptured);

        // col += dcol * (1.0 / dr) * noncaptured * 0.001;

        // Glow
        col += vec3<f32>(1.0, 0.9, 0.85) * (1.0 / vec3<f32>(dot(bhv, bhv))) * 0.0033 * noncaptured;
    }

    // BG
    // col += pow(texture(iChannel0, pv).rgb, vec3<f32>(3.0)) * noncaptured;

    // Final color
    let fragColor = vec4<f32>(col, 1.0);
    return fragColor;
}

fn distLine(ray_origin: vec3f, ray_dir: vec3f, pt: vec3f) -> f32 {
    return length(cross(pt - ray_origin, ray_dir)) / length(ray_dir);
}

fn sdCapsule(p: vec3f, a: vec3f, b: vec3f, r: f32) -> f32 {
    let pa = p - a;
    let ba = b - a;
    let h = clamp(dot(pa, ba) / dot(ba, ba), 0., 1.);
    return length(pa - ba * h) - r;
}
fn sdSphere(pt: vec3f, radius: f32) -> f32 {
    return length(pt) - radius;
}


/// Clockwise by `theta`
fn rotate2D(theta: f32) -> mat2x2<f32> {
    let c = cos(theta);
    let s = sin(theta);
    return mat2x2<f32>(c, s, -s, c);
}

fn sdCappedCylinder(p: vec3f, h: vec2f) -> f32 {
    let d: vec2f = abs(vec2f(length(p.xz), p.y)) - h;
    return min(max(d.x, d.y), 0.0) + length(max(d, vec2f(0.0)));
}

fn sdTorus(p: vec3f, t: vec2f) -> f32 {
    let q: vec2f = vec2f(length(p.xz) - t.x, p.y);
    return length(q) - t.y;
}

