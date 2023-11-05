#import bevy_pbr::mesh_view_bindings globals 
#import bevy_pbr::forward_io::VertexOutput

// If you're passing this in from bevy declare them over there.
struct DottedLineShader {
    tint: vec4<f32>,
    line_width: f32,
    segments: f32,
    phase: f32,
    line_spacing: f32,
};

@group(1) @binding(0)
var<uniform> material: DottedLineShader;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    var uv: vec2<f32> = (in.uv * 2.0) - 1.0; // normalize uvs to [-1..1]
    let t = globals.time; //TODO: animate.
    var col: vec4<f32> = vec4(0.0); // Initialize to transparent
       
    // draw x line
    if abs(uv.x) < 0.025{
        uv += t * 0.5;
        // segment the line, only tint the areas we want
        var uv_segmented: vec2<f32> = fract(uv * 3.0) * 0.05;
        let step_y: f32 = step(0.025, abs(uv_segmented.y));
        col += vec4f(0.23, 0.88, 0.238, 1.0)* step_y;
    }

    return col;
}
