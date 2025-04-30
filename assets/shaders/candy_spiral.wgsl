#import bevy_sprite::mesh2d_view_bindings::globals 
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let position = (2.0 * in.uv - 1.0) * vec2(1.0, view.viewport.w / view.viewport.z);
    
    
    let angle = atan2(position.y, position.x) + globals.time;
    let radius = length(position);
    let spiral = sin(angle * 5.0 + radius * 20.0 - globals.time * 2.0);
    
    return vec4f(
        spiral * 0.5 + 0.5,
        radius,
        1.0 - radius,
        1.0
    );
}