
#import bevy_sprite::mesh2d_view_bindings::globals
#import bevy_sprite::mesh2d_vertex_output::VertexOutput
#import shadplay::shader_utils::common::{PI, shader_toy_default, rotate2D}
#import bevy_render::view::View

@group(0) @binding(0) var<uniform> view: View;

// HG_SDF
fn pR(p: ptr<function, vec2<f32>>, a: f32) {
    *p = cos(a) * (*p) + sin(a) * vec2<f32>((*p).y, -(*p).x);
}

// https://iquilezles.org/articles/distfunctions/distfunctions.htm
fn sdBoundingBox(p: vec3<f32>, b: vec3<f32>, e: f32 ) -> f32 {
    let p_abs = abs(p) - b;
    let q = abs(p_abs + e) - e;
    return min(min(
        length(max(vec3<f32>(p_abs.x, q.y, q.z), vec3<f32>(0.0))) + min(max(p_abs.x, max(q.y, q.z)), 0.0),
        length(max(vec3<f32>(q.x, p_abs.y, q.z), vec3<f32>(0.0))) + min(max(q.x, max(p_abs.y, q.z)), 0.0)),
        length(max(vec3<f32>(q.x, q.y, p_abs.z), vec3<f32>(0.0))) + min(max(q.x, max(q.y, p_abs.z)), 0.0)
    );
}

struct Model {
    d: f32,
    col: vec3<f32>,
    id: i32,
};

var<private> t: f32;

fn map(p_in: vec3<f32>) -> Model {
    var p = p_in;
    let col_in = normalize(p) * 0.5 + 0.5;
    var col = col_in;

    p -= sin(p.y * 15.0 + t * PI * 2.0 * 3.0) * 0.05;

    let ps = p * mix(50.0, 100.0, smoothstep(-1.0, 1.0, p.y));
    p += (sin(ps.x) + sin(ps.z) + sin(ps.y)) * 0.02 * smoothstep(-1.0, 1.0, p.y);

    p += sin(p.y * 10.0 + t * PI * 2.0 * 3.0) * 0.05;
    p += sin(p * 8.0 + t * PI * 2.0) * 0.1;
    
    let r = 1.0;
    p -= r * 0.5;
    let o = floor(p / r + 0.5);
    let o_clamped = clamp(o, vec3<f32>(-1.0, -2.0, -1.0), vec3<f32>(0.0, 1.0, 0.0));
    p -= o_clamped * r;
    col = mix(col, normalize(p) * 0.5 + 0.5, 0.5);

    let d = sdBoundingBox(p, vec3<f32>(0.3), 0.5);
    return Model(d, col, 1);
}

// Dave_Hoskins https://www.shadertoy.com/view/4djSRW
fn hash22(p_in: vec2<f32>) -> vec2<f32> {
    var p = p_in;
    p += 1.61803398875; // fix artifacts when reseeding
    var p3 = fract(vec3<f32>(p.xyx) * vec3<f32>(0.1031, 0.1030, 0.0973));
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xx + p3.yz) * p3.zy);
}

const sqrt3 = 1.7320508075688772;

fn calcLookAtMatrix(ro: vec3<f32>, ta: vec3<f32>, up: vec3<f32>) -> mat3x3<f32> {
    let ww = normalize(ta - ro);
    let uu = normalize(cross(ww, up));
    let vv = normalize(cross(uu, ww));
    return mat3x3<f32>(uu, vv, ww);
}

fn draw(fragCoord: vec2<f32>, frame: i32) -> vec3<f32> {
    let resolution = view.viewport.zw;
    var p = (-resolution.xy + 2.0 * fragCoord.xy) / resolution.y;
        
    var seed = hash22(fragCoord + f32(frame) * sqrt3);
    
    p += 2.0 * (seed - vec2(0.5)) / resolution.xy;

    var camPos = vec3<f32>(0.0, 0.0, 8.0);
    
    var temp_yz = camPos.yz;
    pR(&temp_yz, PI * 0.2);
    camPos.y = temp_yz.x;
    camPos.z = temp_yz.y;

    var temp_xz = camPos.xz;
    pR(&temp_xz, PI * 0.25);
    camPos.x = temp_xz.x;
    camPos.z = temp_xz.y;

    let camMat = calcLookAtMatrix(camPos, vec3<f32>(0.0), vec3<f32>(0.0, 1.0, 0.0));
    
    let focalLength = 60.0;
    camPos *= focalLength / 3.0;
    let rayDir = normalize(camMat * vec3<f32>(p.xy, focalLength));
    let origin = camPos;
    
    var col = vec3<f32>(0.0);

    var rayPosition: vec3<f32>;
    var rayLength = 0.0;
    var model: Model;
        
    let maxlen = 10.0 * focalLength;
    let iter = 200;
    let eps = 0.00004;
    
    for (var i = 0; i < iter; i++) {
        rayPosition = origin + rayDir * rayLength;
        model = map(rayPosition);
        
        let d = max(eps, abs(model.d));
        rayLength += d * (1.0 - seed.x * 0.125);
        
        seed = hash22(seed);
 
        if (rayLength > maxlen) {
            break;
        }
        
        col += model.col / pow(d, 0.125) * 0.002;
    }

    return col;
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let fragCoord = in.uv * view.viewport.zw;
    t = fract(globals.time / 4.0);
    
    var col = vec4<f32>(0.0);
    let c = 4;
    // Approximate a frame count from time to seed the temporal accumulation.
    let frame_approx = i32(globals.time * 60.0);
    for (var i = 0; i < c; i = i + 1) {
        col += vec4<f32>(draw(fragCoord, frame_approx * c + i), 1.0);
    }
    col /= f32(c);

    return col;
}
