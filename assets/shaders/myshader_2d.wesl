/// ***************************** ///
/// THIS IS THE DEFAULT 2D SHADER ///
/// You can always get back to this with `uv run scripts/reset-2d.py` ///
/// ***************************** ///

import bevy_sprite_render::mesh2d::view_bindings::globals;
import shadplay::shader_utils::common::{NEG_HALF_PI, shader_toy_default, rotate2D};
import bevy_render::view::View;
import bevy_sprite_render::mesh2d::vertex_output::VertexOutput;

@group(0) @binding(0) var<uniform> view: View;

const SPEED: f32 = 1.0;

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    // ensure our uv coords match shadertoy/the-lil-book-of-shaders
    var uv = in.uv;
    uv = (uv * 2.0) - 1.0;
    let resolution = view.viewport.zw;
    let t = globals.time * SPEED;
    uv.x *= resolution.x / resolution.y;
    uv *= rotate2D(NEG_HALF_PI);

    return vec4f(shader_toy_default(t, uv), 0.3);
}
