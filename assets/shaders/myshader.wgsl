#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_sprite::mesh2d_view_bindings globals 
#import bevy_pbr::utils PI

#import bevy_render::view  View
@group(0) @binding(0) var<uniform> view: View;

const TAU:f32 =  6.28318530718;
const HEIGHT:f32 = 4.0;
const INTENSITY:f32 = 5.0;
const NUM_LINES:f32 = 4.0;
const SPEED:f32 = 8.0;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    var uv = (in.uv * 2.0) - 1.0;
    let resolution = view.viewport.zw;
    let t = globals.time * SPEED;
    let n = in.world_normal;
    uv.x *= resolution.x / resolution.y;
    uv *= rotate2D(-1.0 * PI);

    var col = vec3f(0.0);

    let sphere = abs(sdSphere(vec3f(1.5), 0.0));
    
    col *= smoothstep(1., 0.7, sphere);


    return vec4f(col, 1.0);
}

fn sdSphere(p: vec3f, radius: f32) -> f32 {
    return (length(p) - radius);
}

/// This is the default (and rather pretty) shader you start with in ShaderToy
fn shaderToyDefault(t: f32, uv: vec2f)-> vec3f{
    var col = vec3f(0.0);
    let v = vec3(t) + vec3(uv.xyx) + vec3(0., 2., 4.);
    return 0.5 + 0.5 * cos(v);
}

/// Clockwise by `theta`
fn rotate2D(theta: f32) -> mat2x2<f32> {
    let c = cos(theta);
    let s = sin(theta);
    return mat2x2<f32>(c, s, -s, c);
}
