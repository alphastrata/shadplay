
#import bevy_sprite::mesh2d_view_bindings::globals
#import bevy_sprite::mesh2d_vertex_output::VertexOutput
#import shadplay::shader_utils::common::{PI, TWO_PI, rotate2D}
#import bevy_render::view::View

@group(0) @binding(0) var<uniform> view: View;

// Controls
const SPEED: f32 = 0.2;
const CAMERA_DISTANCE: f32 = 4.0;
const MAX_STEPS: i32 = 64;
const MAX_DIST: f32 = 100.0;
const MIN_DIST: f32 = 0.001;

// Rotation matrices for 3D rotation
fn rot_x(a: f32) -> mat3x3<f32> {
    let s = sin(a);
    let c = cos(a);
    return mat3x3<f32>(
        1.0, 0.0, 0.0,
        0.0, c, -s,
        0.0, s, c
    );
}

fn rot_y(a: f32) -> mat3x3<f32> {
    let s = sin(a);
    let c = cos(a);
    return mat3x3<f32>(
        c, 0.0, s,
        0.0, 1.0, 0.0,
        -s, 0.0, c
    );
}

// Distance function for a torus
fn torus_dist(p: vec3<f32>, r: vec2<f32>) -> f32 {
    let q = vec2<f32>(length(p.xz) - r.x, p.y);
    return length(q) - r.y;
}

// Distance function for the scene
fn dist(p: vec3<f32>) -> f32 {
    var p_mut = p;
    p_mut = p_mut * rot_y(p.y * 0.2);
    p_mut.z = abs(p_mut.z) - 2.0;
    p_mut = p_mut * rot_y(globals.time * SPEED);
    p_mut.xy = p_mut.xy * rot_y(p_mut.z * 0.5).xz;
    let torus = torus_dist(p_mut, vec2<f32>(0.5, 0.1));
    return torus;
}

// Raymarch the scene
fn raymarch(ro: vec3<f32>, rd: vec3<f32>) -> f32 {
    var d = 0.0;
    for (var i = 0; i < MAX_STEPS; i++) {
        let p = ro + rd * d;
        let ds = dist(p);
        d += ds;
        if (d > MAX_DIST || ds < MIN_DIST) {
            break;
        }
    }
    return d;
}

// Get the normal of the surface
fn get_normal(p: vec3<f32>) -> vec3<f32> {
    let e = vec2<f32>(1.0, -1.0) * 0.5773 * 0.0005;
    return normalize(
        e.xyy * dist(p + e.xyy) + 
        e.yyx * dist(p + e.yyx) + 
        e.yxy * dist(p + e.yxy) + 
        e.xxx * dist(p + e.xxx)
    );
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    var uv = (in.uv - 0.5) * 2.0;
    uv.x *= view.viewport.z / view.viewport.w;

    let time = globals.time * SPEED;

    // Camera setup
    let ro = vec3<f32>(0.0, 0.0, -CAMERA_DISTANCE);
    let rd = normalize(vec3<f32>(uv, 1.0));

    // Raymarch
    let d = raymarch(ro, rd);

    var col = vec3<f32>(0.0);

    if (d < MAX_DIST) {
        let p = ro + rd * d;
        let n = get_normal(p);
        let r = reflect(rd, n);

        // Lighting
        let light_pos = vec3<f32>(2.0, 2.0, -3.0);
        let l = normalize(light_pos - p);
        let diff = max(dot(n, l), 0.0);
        let spec = pow(max(dot(r, l), 0.0), 32.0);

        // Color based on position and lighting
        col = vec3<f32>(0.2, 0.3, 0.8) * diff + vec3<f32>(1.0) * spec;
        col += sin(p * 2.0 + time) * 0.1;
    }

    // Fog
    col = mix(col, vec3<f32>(0.0), smoothstep(0.0, MAX_DIST, d));

    return vec4<f32>(col, 1.0);
}
