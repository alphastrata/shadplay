/// This is a port of 'total noob' by dynamite
/// Source material: https://www.shadertoy.com/view/XdlSDs
/// Authour: https://www.shadertoy.com/user/dynamite
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_sprite::mesh2d_view_bindings globals 
#import shadplay::shader_utils::common NEG_HALF_PI, shader_toy_default, rotate2D, TAU, PI

#import bevy_render::view  View
@group(0) @binding(0) var<uniform> view: View;

const SPEED:f32 = 1.0;
const CIRCLE_SIZE:f32 = 0.4;
const BEAM_ROT_SPEED:f32 = 0.2; 

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    // ensure our uv coords match shadertoy/the-lil-book-of-shaders
    var uv = in.uv;
    uv *= rotate2D(PI);
    uv = (in.uv * 2.0) - 1.0;
    let resolution:vec2f = view.viewport.zw;
    uv.x *= resolution.x / resolution.y;

    let t = globals.time * SPEED;
    var angle = atan2(uv.y, uv.x);

    return circle_charge_beam(uv,resolution, angle, t);
}    

fn circle_charge_beam(uv: vec2f, resolution: vec2f, angle: f32, t: f32) -> vec4<f32> {
    let uv_l = uv;
    var uv = uv; // so we can mutate the uvs locally.

    var rad = length(uv) * CIRCLE_SIZE; // circle radius setter
    uv = vec2(angle / TAU * 2.0 , rad);

    // 'get' a colour:
    var x_colour: f32 = (uv.x - (t * BEAM_ROT_SPEED)) * 3.0;  // QUESTION: what happens when this is not a multiple of PI?
    x_colour = x_colour % 3.0; 
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

    // BUG: somewhere in this lies the solution to the lhs sharp, black line.
    if uv.x > 9.0 {
        hor_colour += 990.0;
    }

    var coefficient_1 = 0.7;
    var coefficient_2 = 0.5;
    var uv_x = uv.x;
    var uv_x_constant = uv_x * 3.20 * PI * 0.85;
    // var uv_x_constant = PI * 0.85;

    var floor_value = floor(PI + cos(t));
    var clamped_value = clamp(floor_value, 0.0, 10.0);
    var abs_uv_y_denominator = 90.0 * uv.y;
    var abs_uv_y = abs(1.0 / abs_uv_y_denominator);

    // Recombine to calculate beam_width:
    var beam_width:f32 = (coefficient_1 + coefficient_2 * cos(uv_x_constant * clamped_value)) * abs_uv_y;
    

    var hor_beam = vec3f(beam_width / PI);

    return vec4f((hor_beam * hor_colour), 1.0);
}
    
 
