//!
//! The default 3d Shader.
//!
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_pbr::utils PI
#import bevy_sprite::mesh2d_view_bindings globals 
#import shadplay::shader_utils::common NEG_HALF_PI, shader_toy_default, rotate2D

#import bevy_render::view  View
@group(0) @binding(0) var<uniform> view: View;

@group(1) @binding(1) var texture: texture_2d<f32>;
@group(1) @binding(2) var texture_sampler: sampler;

const SPEED:f32 = 1.0;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    // ensure our uv coords match shadertoy/the-lil-book-of-shaders
    let texture_uvs = in.uv;

    let tex: vec4f = texture_sample(texture, texture_sampler, texture_uvs); 
    return tex;

}    
    
