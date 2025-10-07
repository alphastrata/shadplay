#import bevy_pbr::forward_io::VertexOutput
#import bevy_pbr::mesh_view_bindings::globals
#import bevy_render::view::View

@group(0) @binding(0) var<uniform> view: View;

@group(3) @binding(100)var<uniform> color: vec4f;
@group(3) @binding(101) var texture: texture_2d<f32>;
@group(3) @binding(102) var texture_sampler: sampler;

const SPEED: f32 = 1.0;

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let texture_uvs = in.uv;
    let tex: vec4f = textureSample(texture, texture_sampler, texture_uvs);
    return tex;
}