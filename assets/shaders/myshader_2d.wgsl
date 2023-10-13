/// This is a port of 'total noob' by dynamite
/// Source material: https://www.shadertoy.com/view/XdlSDs
/// Authour: https://www.shadertoy.com/user/dynamite
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_sprite::mesh2d_view_bindings globals 
#import shadplay::shader_utils::common NEG_HALF_PI, shaderToyDefault, rotate2D, TAU

#import bevy_render::view  View
@group(0) @binding(0) var<uniform> view: View;

const SPEED:f32 = 1.0;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    // ensure our uv coords match shadertoy/the-lil-book-of-shaders
    var uv = (in.uv * 2.0) - 1.0;
    let resolution = view.viewport.zw;
    let t = globals.time * SPEED;
    uv.x *= resolution.x / resolution.y;
    // uv *= rotate2D(NEG_HALF_PI);

    return circle_charge_beam(uv, t);
}    

fn circle_charge_beam(uv: vec2f, t: f32) -> vec4<f32> {
    let uv_l = uv;
    var uv = uv; // so we can mutate the uvs locally.

    var a = atan2(uv.x, uv.y);
    var rad = length(uv) * 0.75; // circle radius setter
    uv = vec2(a / TAU*2.0, rad);

    // 'get' a colour:
    var x_colour: f32 = uv.x - (globals.time / 3.0) * 3.0;

    x_colour = x_colour % 3.0; // 
    var hor_colour = vec3(0.25);

    if x_colour < 1.0 {
        hor_colour.r = 1.0 - x_colour;
        hor_colour.g += x_colour;
    } else if x_colour < 2.0 {
        x_colour -= 1.0;
        hor_colour.g = 1.0 - x_colour;
        hor_colour.b += x_colour;
    } else {
        x_colour -= 2.0;
        hor_colour.b = 1.0 - x_colour;
        hor_colour.r += x_colour;
    }


    uv = (uv * 2.0) - 1.0; // resetting the earlier offsets we made to the uvs.
    // draw the beam:
    // our uvs have already had that calc...
    var beam_width:f32 = (0.7 + 0.5 * cos(uv.x * 10.0 * (TAU*2.0) * 0.15 * clamp(floor(5.0 + 10.0 * cos(t)), 0.0, 10.0))) * abs(1.0 / (30.0 * uv.y)); // TODO: break this out...

    var hor_beam = vec3f(beam_width/2.0);

    return vec4f((hor_beam + hor_colour), 1.0);
}
    
 
