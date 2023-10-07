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
    var col = vec4(0.0);

    var gv = fract(uv * 2.0) - 0.5;

    let ray_origin = vec3f(0., 0., CAM_DISTANCE); // The camera is at -2.0 
    let ray_dir = vec3f(gv.y, gv.x, 0.0) - ray_origin; //NOTE: due to our Rotate2D above we need to flip here.

    let pt_dist = vec3(sin(t), sin(t) / 2.0, cos(t) + 1.0);
    var dist = distLine(ray_origin, ray_dir, pt_dist);
    dist = smoothstep(0.1, 0.09, dist);
    col = vec4(dist);

    let a = smoothstep(gv.x - 0.25, gv.y + 0.25, gv.x);
    let b = smoothstep(gv.x + 0.25, gv.y - 0.25, gv.y);
    col *= (a-b);


    return col;
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
