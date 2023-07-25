#import bevy_pbr::mesh_view_bindings globals view
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_pbr::utils PI HALF_PI
#import bevy_pbr::mesh_functions 

/// This is a cover/port of https://www.shadertoy.com/view/WtGXDD, Martijn is awesome!

const GRID_RATIO:f32 = 40.;
const MAX_STEPS: i32 = 100;
const MAX_DIST: f32 = 100.;
const SURF_DIST: f32 = 0.001;
const TAU: f32 = 6.283185;

/// Clockwise by `theta`
fn rotate2D(theta: f32) -> mat2x2<f32> {
    let c = cos(theta);
    let s = sin(theta);
    return mat2x2<f32>(c, - s, s, c);
}

/// Sighned distance field for a 2dBox
fn sd_box(point: vec3<f32>, sign: vec3<f32>) -> f32 {
    let p = abs(point) - sign;
    let positive_part = max(p, vec3<f32>(0.0));
    let max_component = max(p.x, max(p.y, p.z));
    return length(positive_part) + min(max_component, 0.0);
}

/// Returns the distance to a point
fn get_dist(point: vec3<f32>) -> f32 {
    return sd_box(point, vec3(1.));
}

/// Raymarch in direction, return the distance to what we hit (from origin...).
fn ray_march(ray_origin: vec3<f32>, ray_dir: vec3<f32>, sign: f32) -> f32 {
    var dO: f32 = 0.0;

    for (var i: i32 = 0; i < MAX_STEPS; i = i + 1) {
        var p: vec3<f32> = ray_origin + ray_dir * dO;
        var dS: f32 = get_dist(p) * sign;
        dO = dO + dS;
        if dO > MAX_DIST || abs(dS) < SURF_DIST {
            break;
        }
    }

    return dO;
}

fn get_ray_dir(uv: vec2<f32>, point: vec3<f32>, l: vec3<f32>, depth: f32) -> vec3<f32> {
    let f = normalize(l - point);
    let r = normalize(cross(vec3(0.0, 1.0, 0.0), f));
    let u = cross(f, r);
    let c: vec3<f32> = f * depth;
    let i = c + uv.x * r + uv.y * u;

    return normalize(i);
}

fn get_normal(point: vec3<f32>) -> vec3<f32> {
    let e = vec2(0.001, 0.);
    //delta - xyy, delta - yxy, delta -  yyx
    let norm = get_dist(point) - vec3(get_dist(point - e.xyy), get_dist(point - e.yxy), get_dist(point - e.yyx));

    return normalize(norm);
}

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    let t = globals.time;
    var uv = in.uv - 0.5;
    var col = vec3(0.0);

    let ro = vec3(0., 0., 0.);
    let rd = get_ray_dir(uv, ro, vec3(0., 0., 0.), 1.0);
    let dist_outer = ray_march(ro, rd, 1.0);

    let IOR = 1.45;

    if dist_outer < MAX_DIST {
        let p = ro + rd * dist_outer;
        let norm = get_normal(p);
        let r = reflect(rd, norm);


        let entry_point = p - norm * SURF_DIST * 3.0;
        let refract_dir = refract(rd, norm, 1.0 / IOR);
        let dist_inner = ray_march(p, refract_dir, -1.0);

        col = refract_dir;
    }



    col = pow(col, vec3(0.4545)); // gamma correction
    return vec4<f32>(col, 1.0);
}
