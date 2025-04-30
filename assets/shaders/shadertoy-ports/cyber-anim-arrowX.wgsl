///
/// This is a port of CyberAnimArrowX by float1987 
/// Source: https://www.shadertoy.com/view/DsjfDt
/// Authour: https://www.shadertoy.com/user/float1987
///
#import bevy_sprite::mesh2d_view_bindings::globals 
#import bevy_sprite::mesh2d_vertex_output::VertexOutput
#import shadplay::shader_utils::common::{rotate2D, QUARTER_PI}

#import bevy_render::view::View
@group(0) @binding(0) var<uniform> view: View;

const SPEED:f32 = 0.2;    //Global Speed multiplier
const NUM_ARROWS = 3.0;   // Number of arrows spawned (see the for-loop below)
const COLOUR_TEMP = 0.02; // The 'intensity' of the red channel in the arrows.

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    var uv = (in.uv * 2.0) - 1.0;        //      |
    let resolution = view.viewport.zw;   //      |
    uv.x *= resolution.x / resolution.y; // normalising uvs.

    let t = globals.time * SPEED; 

    uv *= rotate2D(t); // Play with the time to adjust the speed at which the arrows rotate, or commen out to prevent spin entirely.
                       // what happens is you put the negative -QUARTER_PI in here?

    return cyber_anim_arror_x(uv, t);
}    
    
fn cyber_anim_arror_x(uv: vec2f, t: f32) -> vec4f {
    var out = vec3f(0.0);

    for (var i: f32 = 0.0; i < NUM_ARROWS; i += 1.0) {
        // HOMEWORK IDEA 1: 
        // there's several colour pallete creators in this codebase, kishimisu, shaderToyDefault etc (grep for them),
        // maybe you can add your own colour and multiply the sdf_arrow by that?
        out += draw_arrow(uv, i) * vec3f(COLOUR_TEMP, abs(cos(t)), abs(sin(t) * cos(t)));

        // HOMEWORK IDEA 2: 
        // the dradraw_arrow() function is really just an sdf shape, maybe you can swap it out with some others https://gist.github.com/munrocket/30e645d584b5300ee69295e54674b3e4#bobbly-cross---exact
    }

    return vec4f(out, 1.0);
}

/// Draws an sdf_arrow, by manipulating a square
fn draw_arrow(uv_in: vec2f, offset: f32) -> f32 {
    var uv = uv_in;
    var sign_x = sign(uv.x);

    uv.y = abs(uv.y);
    uv.x += sign_x * (uv.y - fract(globals.time) + offset); // Comment this out and you get a square.

    var a = QUARTER_PI;// There are more constants in the common.wgsl -- try some others!
    uv *= rotate2D(a); // rotating our uvs by angle 'a', naming your 'angles' a1, a2, a3 etc seems to be very common.

    var t1 = smoothstep(0.3, 0.29, abs(uv.x) + abs(uv.y));
    var t2 = smoothstep(0.29, 0.28, abs(uv.x) + abs(uv.y));
    var t = step(0.1, t1 - t2);

    return t;
}

