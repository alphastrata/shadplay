/// A shadertoy port of 'Cosmic' https://www.shadertoy.com/view/msjXRK, by Xor.
/// I have sligthly adjusted the colours, and used a smoothstep to improve the contrast too.
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_sprite::mesh2d_view_bindings globals 
#import shadplay::shader_utils::common NEG_HALF_PI, rotate2D

#import bevy_render::view  View
@group(0) @binding(0) var<uniform> view: View;


@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    var uv = (in.uv *2.0) - 1.0;
    uv *= 220.; // equivalent of zooming out.
    uv *= rotate2D(NEG_HALF_PI);
    let resolution = view.viewport.zw;
    uv.x *= resolution.x / resolution.y;

    let col = cosmic(uv, resolution);

    // I like the bumped contrast to enhance the glow.
    // I also like the glow being strongest on the red
    let contrast_bumped = vec4f(
        smoothstep(0.10, 0.95, col.r),
        smoothstep(0.10, 0.85, col.g),
        smoothstep(0.10, 0.85, col.b),
        1.0// Assuming you want to keep the alpha channel unchanged
    );
    return contrast_bumped;

    
}    

 
// Generates a visual effect based on pixel coordinates and time
fn cosmic(uv: vec2f, r: vec2f) -> vec4f {
    var p: vec2f = uv * mat2x2<f32>(vec2<f32>(1.0, -1.0), vec2<f32>(1.3, 5.0));
    
    var col: vec4f = vec4f(0.0, 0.0, 0.0, 0.0);

    for (var i: f32 = 0.0; i < 30.0; i = i + 1.0) {
        var tmp_uv: vec2f = p / -(r + r - p).y;
        var a: f32 = atan2(tmp_uv.y, tmp_uv.x) * ceil(i * 0.1) + globals.time * sin(i * i) + i * i;
        col += 0.2 / (abs(length(tmp_uv) * 80.0 - i) + 40.0 / r.y) *
            clamp(cos(a), 0.0, 0.6) *
            (cos(a - i + vec4f(0.3, 2.0, 2.8, 0.0)) + 1.0);
    }

    return col;
}
