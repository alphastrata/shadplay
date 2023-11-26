/// ***************************** ///
/// This is a prot of WaterPool by rubaotree, on shadertoy: https://www.shadertoy.com/view/ctcBRn
/// ***************************** ///

#import bevy_sprite::mesh2d_view_bindings::globals 
#import shadplay::shader_utils::common::{NEG_HALF_PI, rotate2D, TWO_PI}
#import bevy_render::view::View
#import bevy_pbr::forward_io::VertexOutput;

@group(0) @binding(0) var<uniform> view: View;

const SPEED:f32 = 0.25;

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    // ensure our uv coords match shadertoy/the-lil-book-of-shaders
    var uv = (in.uv * 2.0) - 1.0;
    let resolution = view.viewport.zw;
    let t = globals.time * SPEED;
    uv.x *= resolution.x / resolution.y;

    // // Adapted shader code
    let uvt = vec3<f32>(uv.x * 1.6, uv.y * 2.0 + t * 0.3, t * 0.3);
    let height:f32 = get_height(uvt);
    let shake:vec3f = get_gradient(uvt * 0.4) * 0.005;
    let dlight:vec3f = normalize(vec3<f32>(0.0, -0.8, 0.9));
    let normal:vec3f  = normalize(vec3<f32>(get_gradient(uvt * 2.0)));
    let lightness:f32 = dot(dlight, normal);

    var col = poolColor((uv + shake.xy) * 0.5 + 0.25); 
    // NOTE: The above in the original is uv+shake, is that shake.x+uv.x ... every combo?

    let vorValue = voronoi(vec3<f32>(uv.x * 0.8, uv.y, t * 0.5), 4.0);
    let cutValue = voronoi_cut(vorValue);
    col += cutValue * 0.3;

    col += vec3<f32>(1.0) * step(1.2, lightness + height) * 0.9;
    col += vec3<f32>(clamp(height - 0.3, -0.3, 1.0) * 0.5);

    return vec4<f32>(col, 1.0);
}    
  
fn ring_curve(t: f32) -> f32 {
    return convex_and_clip((abs(1.0 / sin(t)) - 1.0) * 0.05, 1.0);
}

fn light_mix(col: vec3<f32>, lightness: f32) -> vec3<f32> {
    return col * (lightness * 1.2 + 0.3);
}

fn coord_to_uv(coord: vec2<f32>, iResolution: vec2<f32>) -> vec2<f32> {
    return coord / max(iResolution.x, iResolution.y);
}

fn voronoi(p: vec3<f32>, density: f32) -> f32 {
    var id = floor(p * density);
    var min_dist = 1.0; 

    for (var dy: i32 = -1; dy <= 1; dy++) {
        for (var dx: i32 = -1; dx <= 1; dx++) {
            var neighbor = id + vec3<f32>(f32(dx), f32(dy), 0.0);
            var point = neighbor + random2to3(neighbor); // Assuming a random2to3 function
            var dist = length(point - p * density);
            min_dist = min(min_dist, dist);
        }
    }
    return min_dist;
}

fn voronoi_cut(t: f32) -> f32 {
    return t * 1.4;
}

fn convex_and_clip(t: f32, ind: f32) -> f32 {
    if (t <= 0.0) { return 0.0; }
    if (t >= 1.0) { return 1.0; }
    return 1.0 - abs(pow(t - 1.0, ind));
}

// Dummy random function (replace with a better one)
fn random2to3(p: vec3<f32>) -> vec3<f32> {
    return fract(sin(vec3<f32>(dot(p, vec3<f32>(127.1, 311.7, 74.7)), 
                          dot(p, vec3<f32>(269.5, 183.3, 246.1)), 
                          dot(p, vec3<f32>(113.5, 271.9, 124.6)))) * 43758.5453);
}

fn poolColor(uv: vec2<f32>) -> vec3<f32> {
    return vec3<f32>(uv.x, uv.y, 1.0 - uv.x * uv.y);
}

fn get_gradient(uvt: vec3<f32>) -> vec3<f32> {
    return normalize(vec3<f32>(sin(uvt.x), cos(uvt.y), sin(uvt.z)));
}

fn get_height(uvt: vec3<f32>) -> f32 {
    return sin(uvt.x * 10.0) * cos(uvt.y * 10.0) * 0.5;
}


fn hash11(_p: f32) -> f32 {
    var p = fract(_p * 0.1031);
    p *= p + 33.33;
    p *= p + p;
    return fract(p);
}
fn hash21(_p: vec2<f32>) -> f32 {
    var p3 = fract(vec3<f32>(_p.x, _p.y, _p.x) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}
fn hash31(_p3: vec3<f32>) -> f32 {
    var p = fract(_p3 * 0.1031);
    p += dot(p, p.zyx + 31.32);
    return fract((p.x + p.y) * p.z);
}

fn hash12(_p: f32) -> vec2<f32> {
    var p3 = fract(vec3<f32>(_p) * vec3<f32>(0.1031, 0.1030, 0.0973));
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xx + p3.yz) * p3.zy);
}

fn hash22(_p: vec2<f32>) -> vec2<f32> {
    var p3 = fract(vec3<f32>(_p.x, _p.y, _p.x) * vec3<f32>(0.1031, 0.1030, 0.0973));
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xx + p3.yz) * p3.zy);
}

fn hash32(_p3: vec3<f32>) -> vec2<f32> {
    var p = fract(_p3 * vec3<f32>(0.1031, 0.1030, 0.0973));
    p += dot(p, p.yzx + 33.33);
    return fract((p.xx + p.yz) * p.zy);
}

fn luminance(_col: vec3<f32>) -> f32 {
    return dot(vec3<f32>(0.2125, 0.7154, 0.0721), _col);
}

fn rgb2hsv(_col: vec3<f32>) -> vec3<f32> {
    let min_val = min(min(_col.r, _col.g), _col.b);
    let max_val = max(max(_col.r, _col.g), _col.b);
    var h: f32 = 0.0;
    var s: f32 = 0.0;
    let v: f32 = max_val;

    let delta = max_val - min_val;
    if (max_val != 0.0) {
        s = delta / max_val;
    } else {
        // r = g = b = 0
        s = 0.0;
        h = -1.0;
        return vec3<f32>(h, s, v);
    }

    if (_col.r == max_val) {
        h = (_col.g - _col.b) / delta;
    } else if (_col.g == max_val) {
        h = 2.0 + (_col.b - _col.r) / delta;
    } else {
        h = 4.0 + (_col.r - _col.g) / delta;
    }

    h *= 60.0;
    if (h < 0.0) {
        h += 360.0;
    }

    return vec3<f32>(h / 360.0, s, v);
}

fn hsv2rgb(_c: vec3<f32>) -> vec3<f32> {
    let K = vec4<f32>(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    var p = abs(fract(vec3<f32>(_c.x) + K.xyz) * 6.0 - K.www);
    p = clamp(p - K.xxx, vec3<f32>(0.0, 0.0, 0.0), vec3<f32>(1.0, 1.0, 1.0));    
    return _c.z * mix(K.xxx, p, _c.y);
}


fn smooth_curve(_x: f32) -> f32 {
    return 6.0 * _x * _x * _x * _x * _x - 15.0 * _x * _x * _x * _x + 10.0 * _x * _x * _x;
}

fn Gauss(_dist: f32) -> f32 {
    return exp(-10.0 * _dist * _dist);
}

fn Gauss_sq(_dist_sq: f32) -> f32 {
    return exp(-10.0 * _dist_sq);
}

fn palette(_t: f32, _a: vec3<f32>, _b: vec3<f32>, _c: vec3<f32>, _d: vec3<f32>) -> vec3<f32> {
    return _a + _b * cos(6.28318 * (_c * _t + _d));
}
















