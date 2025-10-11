//
// Port of a "Fireball" shader.
// Original source: https://www.shadertoy.com/view/XtGGRt by boywonder
//

#import bevy_sprite::mesh2d_view_bindings::globals
#import bevy_sprite::mesh2d_vertex_output::VertexOutput
#import bevy_render::view::View
#import shadplay::shader_utils::common::{PI, TAU, sdBox, rotate2D_clockwise, fbm_fireball}

@group(0) @binding(0) var<uniform> view: View;
// TODO: Mouse input is not yet fully handled in this port.
// To enable mouse rotation, you would need to:
// 1. Ensure the necessary mouse data (position and button state) is sent to the shader.
// 2. Uncomment the mouse uniform binding below.
// 3. Uncomment the mouse rotation logic in the fragment shader's main loop.
// #import shadplay::shader_utils::common::YourShader2D
// @group(3) @binding(0) var<uniform> mouse: YourShader2D;

const EPSILON: f32 = 1e-6;

// A private global variable to accumulate color during raymarching.
// This is a common pattern in Shadertoy ports where functions have side effects.
var<private> col: vec3<f32>;

// --- Helper Functions ---

/// Macro replacement for `(sin(v)*.5+.5)` from the original shader.
fn s1(v: vec3<f32>) -> vec3<f32> {
    return sin(v) * 0.5 + 0.5;
}

/// The main Signed Distance Function for the fireball scene.
fn sdFireBall(p: vec3<f32>) -> f32 {
  var p_mut = p;
  p_mut.y -= -1.0;
  var q = p_mut;
  
  let T = globals.time;
  let h = 5.0;
  let range = smoothstep(-h, h, p_mut.y);
  let w = range * 4.0 + 1.0;
  let thick = range * 4.0 + 1.0;
  
  let new_xz = rotate2D_clockwise(q.y * 1.0 - T * 2.0) * q.xz;
  q.x = new_xz.x;
  q.z = new_xz.y;

  var d = sdBox(q, vec3<f32>(w, h, thick));
  let d1 = sdBox(q - vec3<f32>(0.0, 1.0, 0.0), vec3<f32>(w, h, thick) * vec3<f32>(0.7, 2.0, 0.7));
  d = max(d, -d1);
  
  d += fbm_fireball(p_mut * 3.0, T) * 0.5;

  d = abs(d) * 0.1 + 0.01;

  let c = s1(vec3<f32>(3.0, 2.0, 1.0) + (p_mut.y + p_mut.z) * 0.5 - T * 2.0);
  // Accumulate color as a side effect.
  col += pow(1.3 / d, 2.0) * c;

  return d;
}


// --- Main Fragment Shader ---

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let R = view.viewport.zw;
    // Normalize UVs to -1.0 to 1.0, accounting for aspect ratio.
    var uv = (in.uv * R * 2.0 - R) / R.y;
    uv.y *= -1.0; // Invert Y-axis to correct orientation.
    // let m = (mouse.mouse_pos * 2.0 - R) / R * PI * 2.0;

    // Reset the global color accumulator for this fragment.
    col = vec3<f32>(0.0);
    var O: vec4<f32>;

    // Setup camera ray origin and direction.
    var ro = vec3<f32>(0.0, 0.0, -10.0);
    let rd = normalize(vec3<f32>(uv, 1.0));

    // Raymarch the scene.
    let zMax = 20.0;
    var z = 0.1;

    for(var i = 0.0; i < 100.0; i = i + 1.0) {
        var p = ro + rd * z;

        // Mouse interaction is disabled for now.
        // if (mouse.button_pressed > 0.0) {
        //     let m_x_rot = rotate2D_clockwise(m.x);
        //     let new_xz = m_x_rot * p.xz;
        //     p.x = new_xz.x;
        //     p.z = new_xz.y;

        //     let m_y_rot = rotate2D_clockwise(m.y);
        //     let new_yz = m_y_rot * p.yz;
        //     p.y = new_yz.x;
        //     p.z = new_yz.y;
        // }

        let d = sdFireBall(p);
        
        if(d < EPSILON || z > zMax) {
            break;
        }
        z += d;
    }

    // Final color processing (tonemapping).
    col = tanh(col / 9e4);
    O = vec4<f32>(col, 1.0);
    return O;
}