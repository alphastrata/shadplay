/*
 This is a port of https://www.shadertoy.com/view/XfyXRV by mrange
*/

#import bevy_sprite::mesh2d_view_bindings::globals
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

// Configuration constants
const ROTATION_SPEED: f32 = 0.25;
const POLY_U: f32 = 1.0;
const POLY_V: f32 = 0.5;
const POLY_W: f32 = 1.0;
const POLY_TYPE: i32 = 3;
const POLY_ZOOM: f32 = 2.0;
const INNER_SPHERE: f32 = 1.0;
const REFR_INDEX: f32 = 0.9;
const MAX_BOUNCES: i32 = 6;

// Mathematical constants
const PI: f32 = 3.141592654;
const TAU: f32 = 2.0 * PI;
const NORM_OFF: f32 = 0.005;
const TOLERANCE: f32 = 0.0005;
const MAX_RAY_LENGTH: f32 = 10.0;
const MAX_RAY_MARCHES: i32 = 90;

// Pre-calculated normalised vectors
const POLY_COSPIN: f32 = cos(PI / f32(POLY_TYPE));
const POLY_SCOSPIN: f32 = sqrt(0.75 - POLY_COSPIN * POLY_COSPIN);
const POLY_NC: vec3<f32> = vec3<f32>(-0.5, -POLY_COSPIN, POLY_SCOSPIN);
const POLY_PAB: vec3<f32> = vec3<f32>(0.0, 0.0, 1.0);

const POLY_PBC_UNNORMALIZED: vec3<f32> = vec3<f32>(POLY_SCOSPIN, 0.0, 0.5);
const POLY_PBC_LENGTH: f32 = 0.9013878189;
const POLY_PBC: vec3<f32> = POLY_PBC_UNNORMALIZED / POLY_PBC_LENGTH;

const POLY_PCA_UNNORMALIZED: vec3<f32> = vec3<f32>(0.0, POLY_SCOSPIN, POLY_COSPIN);
const POLY_PCA_LENGTH: f32 = 0.9013878189;
const POLY_PCA: vec3<f32> = POLY_PCA_UNNORMALIZED / POLY_PCA_LENGTH;

// Colours
const SUN_COL: vec3<f32> = vec3<f32>(1.0, 0.6, 0.1) * 0.01;
const BOTTOM_BOX_COL: vec3<f32> = vec3<f32>(0.2, 0.4, 0.8) * 0.5;
const TOP_BOX_COL: vec3<f32> = vec3<f32>(0.3, 0.5, 1.0);
const GLOW_COL0: vec3<f32> = vec3<f32>(1.0, 0.4, 0.1) * 0.001;
const GLOW_COL1: vec3<f32> = vec3<f32>(1.0, 0.2, 0.8) * 0.001;
const BEER_COL: vec3<f32> = vec3<f32>(-2.0, -1.0, -0.5);

var<private> g_rot: mat3x3<f32>;
var<private> g_gd: vec2<f32>;

fn calculate_poly_p() -> vec3<f32> {
    let unnormalized = POLY_U * POLY_PAB + POLY_V * POLY_PBC + POLY_W * POLY_PCA;
    return normalize(unnormalized);
}

fn hsv_to_rgb(c: vec3<f32>) -> vec3<f32> {
    let K = vec4<f32>(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    let p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, vec3<f32>(0.0), vec3<f32>(1.0)), c.y);
}

fn rotation_matrix(d: vec3<f32>, z: vec3<f32>) -> mat3x3<f32> {
    let v = cross(z, d);
    let c = dot(z, d);
    let k = 1.0 / (1.0 + c);
    return mat3x3<f32>(v.x * v.x * k + c, v.y * v.x * k - v.z, v.z * v.x * k + v.y, v.x * v.y * k + v.z, v.y * v.y * k + c, v.z * v.y * k - v.x, v.x * v.z * k - v.y, v.y * v.z * k + v.x, v.z * v.z * k + c);
}

fn aces_approx(v: vec3<f32>) -> vec3<f32> {
    let v_clamped = max(v, vec3<f32>(0.0));
    let v_scaled = v_clamped * 0.6;
    let a = vec3<f32>(2.51);
    let b = vec3<f32>(0.03);
    let c = vec3<f32>(2.43);
    let d = vec3<f32>(0.59);
    let e = vec3<f32>(0.14);
    return clamp((v_scaled * (a * v_scaled + b)) / (v_scaled * (c * v_scaled + d) + e), vec3<f32>(0.0), vec3<f32>(1.0));
}

fn sphere_distance(p: vec3<f32>, r: f32) -> f32 {
    return length(p) - r;
}

fn box_distance(p: vec2<f32>, b: vec2<f32>) -> f32 {
    let d = abs(p) - b;
    return length(max(d, vec2<f32>(0.0))) + min(max(d.x, d.y), 0.0);
}

fn poly_fold(p: ptr<function, vec3<f32>>) {
    for (var i: i32 = 0; i < POLY_TYPE; i++) {
        var temp: vec3<f32> = *p;
        temp = vec3<f32>(abs(temp.xy), temp.z);
        *p = temp - 2.0 * min(0.0, dot(temp, POLY_NC)) * POLY_NC;
    }
}

fn poly_plane_distance(p: vec3<f32>) -> f32 {
    let d0 = dot(p, POLY_PAB);
    let d1 = dot(p, POLY_PBC);
    let d2 = dot(p, POLY_PCA);
    return max(max(d0, d1), d2);
}

fn poly_corner_distance(p: vec3<f32>) -> f32 {
    return length(p) - 0.0125;
}

fn poly_edge_distance(p: vec3<f32>) -> f32 {
    let dla = dot(p - min(0.0, p.x) * vec3<f32>(1.0, 0.0, 0.0), p - min(0.0, p.x) * vec3<f32>(1.0, 0.0, 0.0));
    let dlb = dot(p - min(0.0, p.y) * vec3<f32>(0.0, 1.0, 0.0), p - min(0.0, p.y) * vec3<f32>(0.0, 1.0, 0.0));
    let dlc = dot(p - min(0.0, dot(p, POLY_NC)) * POLY_NC, p - min(0.0, dot(p, POLY_NC)) * POLY_NC);
    return sqrt(min(min(dla, dlb), dlc)) - 0.002;
}

fn shape_distance(p: vec3<f32>) -> vec3<f32> {
    var pos = p * g_rot;
    pos /= POLY_ZOOM;
    poly_fold(&pos);
    pos -= calculate_poly_p();
    return vec3<f32>(poly_plane_distance(pos), poly_edge_distance(pos), poly_corner_distance(pos)) * POLY_ZOOM;
}

fn render_environment(ro: vec3<f32>, rd: vec3<f32>) -> vec3<f32> {
    var col = vec3<f32>(0.0);

    let srd = sign(rd.y);
    let tp = -(ro.y - 6.0) / abs(rd.y);

    // Bottom
    if (srd < 0.0) {
        let hit_pos = ro + tp * rd;
        col += BOTTOM_BOX_COL * exp(-0.5 * length(hit_pos.xz));
    }

    // Top
    if (srd > 0.0) {
        let pos = ro + tp * rd;
        let pp = pos.xz;
        let db = box_distance(pp, vec2<f32>(5.0, 9.0)) - 3.0;

        col += TOP_BOX_COL * rd.y * rd.y * smoothstep(0.25, 0.0, db);
        col += 0.2 * TOP_BOX_COL * exp(-0.5 * max(db, 0.0));
        col += 0.05 * sqrt(TOP_BOX_COL) * max(-db, 0.0);
    }

    // Sun
    let sun_dir = normalize(-ro);
    col += SUN_COL / (1.001 - dot(sun_dir, rd));

    return col;
}

// Distance function for outer surface
fn df_outer(p: vec3<f32>) -> f32 {
    let ds = shape_distance(p);
    g_gd = min(g_gd, ds.yz);
    let d0 = min(ds.x, min(ds.y, ds.z));
    return d0;
}

// Distance function for inner reflections
fn df_inner(p: vec3<f32>) -> f32 {
    let ds = shape_distance(p);
    let d2 = ds.y - 0.005;
    let d0 = min(-ds.x, d2);
    let d1 = sphere_distance(p, INNER_SPHERE);
    g_gd = min(g_gd, vec2<f32>(d2, d1));
    return min(d0, d1);
}

fn ray_march_outer(ro: vec3<f32>, rd: vec3<f32>, t_init: f32) -> f32 {
    var t = t_init;
    for (var i: i32 = 0; i < MAX_RAY_MARCHES; i++) {
        let d = df_outer(ro + rd * t);
        if (d < TOLERANCE || t > MAX_RAY_LENGTH) {
            break;
        }
        t += d;
    }
    return t;
}

fn ray_march_inner(ro: vec3<f32>, rd: vec3<f32>, t_init: f32) -> f32 {
    var t = t_init;
    for (var i: i32 = 0; i < 50; i++) {
        let d = df_inner(ro + rd * t);
        if (d < TOLERANCE) {
            break;
        }
        t += d;
    }
    return t;
}

fn calculate_normal_outer(pos: vec3<f32>) -> vec3<f32> {
    let eps = vec2<f32>(NORM_OFF, 0.0);
    let nor = vec3<f32>(df_outer(pos + eps.xyy) - df_outer(pos - eps.xyy), df_outer(pos + eps.yxy) - df_outer(pos - eps.yxy), df_outer(pos + eps.yyx) - df_outer(pos - eps.yyx));
    return normalize(nor);
}

fn calculate_normal_inner(pos: vec3<f32>) -> vec3<f32> {
    let eps = vec2<f32>(NORM_OFF, 0.0);
    let nor = vec3<f32>(df_inner(pos + eps.xyy) - df_inner(pos - eps.xyy), df_inner(pos + eps.yxy) - df_inner(pos - eps.yxy), df_inner(pos + eps.yyx) - df_inner(pos - eps.yyx));
    return normalize(nor);
}

fn render_inner_reflections(ro: vec3<f32>, rd: vec3<f32>, db: f32) -> vec3<f32> {
    var agg = vec3<f32>(0.0);
    var ragg = 1.0;
    var tagg = 0.0;
    var current_ro = ro;
    var current_rd = rd;
    var current_db = db;

    for (var bounce: i32 = 0; bounce < MAX_BOUNCES; bounce++) {
        if (ragg < 0.1) {
            break;
        }

        g_gd = vec2<f32>(1000.0);
        let t2 = ray_march_inner(current_ro, current_rd, min(current_db + 0.05, 0.3));
        let gd2 = g_gd;
        tagg += t2;

        let p2 = current_ro + current_rd * t2;
        let n2 = calculate_normal_inner(p2);
        let r2 = reflect(current_rd, n2);
        let rr2 = refract(current_rd, n2, 1.0 / REFR_INDEX);
        let fre2 = 1.0 + dot(n2, current_rd);

        let beer = ragg * exp(0.2 * BEER_COL * tagg);
        agg += GLOW_COL1 * beer * ((1.0 + tagg * tagg * 0.04) * 6.0 / max(gd2.x, 0.0005 + tagg * tagg * 0.0002 / ragg));

        let ocol = 0.2 * beer * render_environment(p2, rr2);

        if (gd2.y <= TOLERANCE) {
            ragg *= 1.0 - 0.9 * fre2;
        } else {
            agg += ocol;
            ragg *= 0.8;
        }

        current_ro = p2;
        current_rd = r2;
        current_db = gd2.x;
    }

    return agg;
}

fn render_scene(ray_origin: vec3<f32>, ray_dir: vec3<f32>) -> vec3<f32> {
    let sky_col = render_environment(ray_origin, ray_dir);
    var col = sky_col;

    g_gd = vec2<f32>(1000.0);
    let t1 = ray_march_outer(ray_origin, ray_dir, 0.1);
    let gd1 = g_gd;

    if (t1 < MAX_RAY_LENGTH) {
        let p1 = ray_origin + t1 * ray_dir;
        let n1 = calculate_normal_outer(p1);
        let r1 = reflect(ray_dir, n1);
        let rr1 = refract(ray_dir, n1, REFR_INDEX);
        var fre1 = 1.0 + dot(ray_dir, n1);
        fre1 *= fre1;

        // Outer reflection
        col = render_environment(p1, r1) * (0.5 + 0.5 * fre1);

        // Inner reflections
        if (gd1.x > TOLERANCE && gd1.y > TOLERANCE && length(rr1) > 0.0) {
            let icol = render_inner_reflections(p1, rr1, gd1.x);
            col += icol * (1.0 - 0.75 * fre1);
        }
    }

    // Glow effect
    col += GLOW_COL0 / max(gd1.x, 0.0003);

    return col;
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let time = globals.time;
    let resolution = view.viewport.zw;

    var uv = in.uv * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;

    // Set up camera
    let ray_origin = vec3<f32>(0.0, 1.0, -5.0);
    let look_at = vec3<f32>(0.0);
    let up = vec3<f32>(0.0, 1.0, 0.0);

    // Calculate rotation
    let angle = time * ROTATION_SPEED;
    let r0 = vec3<f32>(1.0, sin(vec2<f32>(sqrt(0.5), 1.0) * angle));
    let r1 = vec3<f32>(cos(vec2<f32>(sqrt(0.5), 1.0) * 0.913 * angle), 1.0);
    g_rot = rotation_matrix(normalize(r0), normalize(r1));

    // Calculate ray direction
    let ww = normalize(look_at - ray_origin);
    let uu = normalize(cross(up, ww));
    let vv = normalize(cross(ww, uu));
    let fov = 2.0;
    let ray_dir = normalize(-uv.x * uu + uv.y * vv + fov * ww);

    // Render scene
    var colour = render_scene(ray_origin, ray_dir);

    // Post-processing
    colour -= 0.02 * vec3<f32>(2.0, 3.0, 1.0) * (length(uv) + 0.25);
    colour = aces_approx(colour);
    colour = sqrt(colour);

    return vec4<f32>(colour, 1.0);
}
