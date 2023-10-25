//! Showing how to use a texture, drag-n-drop for you own texture will be supported soon.

#import bevy_pbr::mesh_vertex_output      MeshVertexOutput

@group(1) @binding(1) var texture: texture_2d<f32>;
@group(1) @binding(2) var texture_sampler: sampler;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    // ensure our uv coords match shadertoy/the-lil-book-of-shaders
    let texture_uvs = in.uv;

    let tex: vec4f = texture_sample(texture, texture_sampler, texture_uvs); 

    return tex;
}    
    
