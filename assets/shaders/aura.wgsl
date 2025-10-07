#import bevy_pbr::forward_io::{VertexOutput, FragmentOutput};
#import bevy_pbr::mesh_view_bindings::globals
#import bevy_render::view::View

/// Keep up-to-date with the rust definition!
struct AuraMaterial {
    unused: f32,
}

@group(0) @binding(0)   var<uniform> view: View;
@group(3) @binding(100) var<uniform> aura_mat: AuraMaterial;

// Colour picker tells us the values of the original..
// Darkish
// #CEAA4F
const GOLD: vec3f = vec3f(0.807843, 0.666667, 0.309804);
const SPIKE_NUM: f32 = 9.0;
const SPIKE_LEN: f32 = 1.68;
const SPIKE_SPEED:f32 = 32.0;
const PI: f32 =  3.141592653589;

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    var uv = in.uv;
    uv = uv * 2.0 - 1.0; //normalise to 0 .. 1

    let time = globals.time;

    let feet_mask = sdCircle(uv, 0.25); // Get a mask for the area around our feet.

    // Move into polar coordinates.
    var pc = vec2f(atan2(uv.x, uv.y), length(uv));
    let x = (pc.x / PI) * SPIKE_NUM; // Divide the x coords by PI so they line up perfectly.

    // Make the spikes. 
    let f_x = fract(x);
    let f2_x = fract(1.0 - x);
    var m = min(f_x, f2_x);
    m = m * SPIKE_LEN - pc.y;
    
    // Draw the spikes:
    var c = smoothstep(0.03, 0.9, m);
    var col = vec3f(c);

    let rate:f32 = time * SPIKE_SPEED;

    let idx: f32 = rate % (SPIKE_NUM * 2.0) - (SPIKE_NUM - 1.0) ;
    var x_clamp = -floor(x);
    let is_focused_spike = step(0.5, abs(idx - x_clamp));
    col *= mix(GOLD / 0.15, GOLD * 0.54, is_focused_spike);       

    // Mask out the area around the character's feet..
    var out = vec4f(col, m);
    out *= smoothstep(0.0, 0.09, feet_mask);

    // TODO: the index in the original's colour splashes either side of the other two indicies..
    // we should brighten them too, have this spill available as const.
    return out;
}

fn sdCircle(p: vec2f, r: f32) -> f32 {
    return length(p) - r;
}



