#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_sprite::mesh2d_view_bindings globals 
#import shadplay::shader_utils::common NEG_HALF_PI, sdCircle, shaderToyDefault, rotate2D

#import bevy_render::view  View
@group(0) @binding(0) var<uniform> view: View;

const HEIGHT:f32 = 4.128;
const SPEED:f32 = 1.80;
const CAM_DISTANCE: f32 = -2.;
const SIZE: f32 = 1.2;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    // ensure our uv coords match shadertoy/the-lil-book-of-shaders
    var uv = (in.uv * 2.0) - 1.0;
    let resolution = view.viewport.zw;
    let t = globals.time * SPEED;
    uv.x *= resolution.x / resolution.y;
    uv *= rotate2D(NEG_HALF_PI);

    // Create some colour, do nothing with it.
    var col = vec4f(0.0);
    var base_colour = shaderToyDefault(t, uv);

    // sdf for a 2D circle
    uv /= SIZE; // Make uvs bigger 
    let d = -1.0 * sdCircle(uv, 0.3); // -1 to flip it so we're drawing the circle in colour, not the space around it.
    
    base_colour *= smoothstep(0.02, 0.09, d); // use the smoothstep to colour BY the circle's sdf.
    col = vec4f(base_colour, d); // use the circle's sdf to, in the same way it supplies values to the smoothstep above, also be the alpha values -- so our 'background' is transparent.

    return col;
}
