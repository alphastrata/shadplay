#import bevy_pbr::forward_io::VertexOutput
#import bevy_sprite::mesh2d_view_bindings globals  // for 2D
#import bevy_render::view View
#import bevy_pbr::utils PI

@group(0) @binding(0) var<uniform> view: View;

const SPEED:f32 = 0.22;

// Working out how to use the vec2f[idx] indexing with loops.
@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    var uv = in.uv.xy;

    var col = vec4f(0.0);
    col.a = 1.0;

    // Write over these v[idx] by idx we tick in a loop:
    var v = vec3f(1.0);
    for (var idx = 0; idx < 3; idx += 1) {
        v[idx] = fract(globals.time * SPEED);
    }

    col.r = v.r;
    col.b = v.b;
    col.g = v.g;

    return col;
}
