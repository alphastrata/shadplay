#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_sprite::mesh2d_view_bindings globals 
#import bevy_pbr::utils PI

#import bevy_render::view  View
@group(0) @binding(0) var<uniform> view: View;

const HEIGHT:f32 = 4.128;
const INTENSITY:f32 = 5.0;
const NUM_LINES:f32 = 4.0;
const SPEED:f32 = 1.0;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    // ensure our uv coords match shadertoy/the-lil-book-of-shaders
    var uv = (in.uv.xy * 2.0) - 1.0;
    let resolution = view.viewport.zw;
    uv.x *= resolution.x / resolution.y;

    uv *= rotate2D(PI / -2.0);


    var col = vec4f(0.0);

    let  pt = uv.xy;
    let radius = 0.725;

    let circle = -1.0 * sdCircle(pt, radius);
    col.a += circle;
    col.b += circle;


    return col;
}

fn sdCircle(pt: vec2f, radius: f32) -> f32 {
    return length(pt) - radius;
}


/// Clockwise by `theta`
fn rotate2D(theta: f32) -> mat2x2<f32> {
    let c = cos(theta);
    let s = sin(theta);
    return mat2x2<f32>(c, s, -s, c);
}
