//!
//! The default 3d Shader.
//!
import bevy_pbr::render::forward_io::VertexOutput;

@group(constants::MATERIAL_BIND_GROUP) @binding(100) var<uniform> color: vec4f;
@group(constants::MATERIAL_BIND_GROUP) @binding(101) var texture: texture_2d<f32>;
@group(constants::MATERIAL_BIND_GROUP) @binding(102) var texture_sampler: sampler;

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    return textureSample(texture, texture_sampler, in.uv);
}
