
//! Showing how to use a texture, drag-n-drop for you own texture will be supported soon.

#import bevy_pbr::mesh_vertex_output      MeshVertexOutput

@group(1) @binding(1) var texture: texture_2d<f32>;
@group(1) @binding(2) var texture_sampler: sampler;



@group(3) @binding(0) var mouse: vec2f;


@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    let texture_uvs = in.uv;

    let tex: vec4f = textureSample(texture, texture_sampler, texture_uvs); 

    return tex;
}    
    
