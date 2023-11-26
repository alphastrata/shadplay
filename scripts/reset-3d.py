THREE3_SHADER_STARTER = """//!
//! The default 3d Shader.
//!
#import bevy_pbr::forward_io::VertexOutput
#import bevy_pbr::mesh_view_bindings::globals;
#import bevy_pbr::utils PI
#import shadplay::shader_utils::common NEG_HALF_PI, shader_toy_default, rotate2D

@group(0) @binding(0) var<uniform> view: View;

@group(1) @binding(1) var texture: texture_2d<f32>;
@group(1) @binding(2) var texture_sampler: sampler;

const SPEED:f32 = 1.0;

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    // ensure our uv coords match shadertoy/the-lil-book-of-shaders
    let texture_uvs = in.uv;

    let tex: vec4f = textureSample(texture, texture_sampler, texture_uvs); // textureSample is provided by wgsl?
    return tex;

}"""

# Define the file path
file_path = "./assets/shaders/myshader.wgsl"

# Open the file in write mode and replace its contents
with open(file_path, "w") as file:
    file.write(THREE3_SHADER_STARTER)

print(f"Content in {file_path} has been replaced with the provided shader code.")
