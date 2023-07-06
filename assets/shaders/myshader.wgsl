// The time since startup data is in the globals binding which is part of the mesh_view_bindings import
// #import shadplay::myshadertools rgb2hsb
#import bevy_pbr::mesh_view_bindings globals
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_pbr::utils PI
#import bevy_pbr::utils
#import bevy_core_pipeline::fullscreen_vertex_shader FullscreenVertexOutput
#import bevy_render::view View

// Notice how this EXACTLY matches the YourShader declared in main? This is how you Get data INTO a shader.
struct MyShaderColor {
    color: vec4<f32>,
};

@group(0) @binding(0)
var<uniform> view: View;

@group(1) @binding(0)
var<uniform> material: MyShaderColor;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    let uv: vec2<f32> = in.uv;
    // return fbm_lightning(uv);

    // Emergency:
    return vec4(uv.x, uv.y, (uv.y / uv.x), 0.002) + fbm_lightning(uv);
}

// Cover of https://www.shadertoy.com/view/dsXfDn
fn fbm_lightning(uv: vec2<f32>) -> vec4<f32> {
    // Make the centre of our cube == 0,0
    var uv = ((uv.xy) * 2.0) - 1.5;

    var time: f32 = globals.time;

    uv += fbm(uv + 0.004 * time, 120) ;

    var dist = uv.x;
    var col = vec3(0.3, 0.6, 0.8) * pow(mix(0.0, 0.05, h11(time)) / dist, 99.4);

    return vec4(col, 1.0);
}

fn h11(p: f32) -> f32 {
    var p = fract(p * .1031);
    p *= p + 33.33;
    p *= p + p;
    return fract(p);
}

fn h12(pp: vec2<f32>) -> f32 {
    var p3 = fract(vec3(pp.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

fn rotate2D(theta: f32) -> mat2x2<f32> {
    let c = cos(theta);
    let s = sin(theta);
    return mat2x2<f32>(c, - s, s, c);
}

fn noise21(pp: vec2<f32>) -> f32 {
    let ip = floor(pp);
    let fp = fract(pp);

    let a = h12(ip);
    let b = h12(ip + vec2(1., 0.));
    let c = h12(ip + vec2(0., 1.));
    let d = h12(ip + vec2(1., 1.));

    let t = smoothstep(vec2(0.0), vec2(1.0), fp);

    return mix(mix(a, b, t.x), mix(c, d, t.x), t.y);
}

fn fbm(pp: vec2<f32>, octave_count: i32) -> f32 {
    var value = 0.0;
    var pp = pp;
    var amp = 0.5;

    for (var i = 0; i < octave_count; i += 1) {
        value += amp * noise21(pp);
        pp *= rotate2D(0.99);
        pp *= pp;
        amp *= 0.2;
    }

    return value;
}