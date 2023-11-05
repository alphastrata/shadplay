#import bevy_pbr::mesh_vertex_output    MeshVertexOutput
#import bevy_pbr::mesh_view_bindings    view
#import bevy_pbr::pbr_types             STANDARD_MATERIAL_FLAGS_DOUBLE_SIDED_BIT
#import bevy_core_pipeline::tonemapping tone_mapping
#import bevy_pbr::pbr_functions as fns

@group(1) @binding(0) var my_array_texture: texture_2d_array<f32>;
@group(1) @binding(1) var my_array_texture_sampler: sampler;

@fragment
fn fragment(
    @builtin(front_facing) is_front: bool,
    mesh: MeshVertexOutput,
) -> @location(0) vec4<f32> {
    let layer = i32(mesh.world_position.x) & 0x3;

    // Prepare a 'processed' StandardMaterial by sampling all textures to resolve
    // the material members
    var pbr_input: fns::PbrInput = fns::pbr_input_new();

    pbr_input.material.base_color = texture_sample(my_array_texture, my_array_texture_sampler, mesh.uv, layer);
#ifdef VERTEX_COLORS
    pbr_input.material.base_color = pbr_input.material.base_color * mesh.color;
#endif

    pbr_input.frag_coord = mesh.position;
    pbr_input.world_position = mesh.world_position;
    pbr_input.world_normal = fns::prepare_world_normal(
        mesh.world_normal,
        (pbr_input.material.flags & STANDARD_MATERIAL_FLAGS_DOUBLE_SIDED_BIT) != 0u,
        is_front,
    );

    pbr_input.is_orthographic = view.projection[3].w == 1.0;

    pbr_input.N = fns::apply_normal_mapping(
        pbr_input.material.flags,
        mesh.world_normal,
#ifdef VERTEX_TANGENTS
#ifdef STANDARDMATERIAL_NORMAL_MAP
        mesh.world_tangent,
#endif
#endif
        mesh.uv,
        view.mip_bias,
    );
    pbr_input.V = fns::calculate_view(mesh.world_position, pbr_input.is_orthographic);

    return tone_mapping(fns::pbr(pbr_input), view.color_grading);
}
#import bevy_pbr::mesh_view_bindings
#import bevy_pbr::mesh_bindings
#import bevy_pbr::forward_io::VertexOutput

@group(1) @binding(0) var test_texture_1d: texture_1d<f32>;
@group(1) @binding(1) var test_texture_1d_sampler: sampler;

@group(1) @binding(2) var test_texture_2d: texture_2d<f32>;
@group(1) @binding(3) var test_texture_2d_sampler: sampler;

@group(1) @binding(4) var test_texture_2d_array: texture_2d_array<f32>;
@group(1) @binding(5) var test_texture_2d_array_sampler: sampler;

@group(1) @binding(6) var test_texture_cube: texture_cube<f32>;
@group(1) @binding(7) var test_texture_cube_sampler: sampler;

@group(1) @binding(8) var test_texture_cube_array: texture_cube_array<f32>;
@group(1) @binding(9) var test_texture_cube_array_sampler: sampler;

@group(1) @binding(10) var test_texture_3d: texture_3d<f32>;
@group(1) @binding(11) var test_texture_3d_sampler: sampler;

@fragment
fn fragment(in: MeshVertexOutput) {}
#import bevy_pbr::mesh_view_bindings  view
#import bevy_pbr::mesh_vertex_output  MeshVertexOutput
#import bevy_pbr::utils               coords_to_viewport_uv

@group(1) @binding(0) var texture: texture_2d<f32>;
@group(1) @binding(1) var texture_sampler: sampler;

@fragment
fn fragment(
    mesh: MeshVertexOutput,
) -> @location(0) vec4<f32> {
    let viewport_uv = coords_to_viewport_uv(mesh.position.xy, view.viewport);
    let color = texture_sample(texture, texture_sampler, viewport_uv);
    return color;
}
#import bevy_pbr::forward_io::VertexOutput

struct CustomMaterial {
    color: vec4<f32>,
};

@group(1) @binding(0) var<uniform> material: CustomMaterial;
@group(1) @binding(1) var base_color_texture: texture_2d<f32>;
@group(1) @binding(2) var base_color_sampler: sampler;

@fragment
fn fragment(
    mesh: MeshVertexOutput,
) -> @location(0) vec4<f32> {
    return material.color * texture_sample(base_color_texture, base_color_sampler, mesh.uv);
}
#import bevy_pbr::mesh_view_bindings
#import bevy_pbr::mesh_bindings
#import bevy_pbr::mesh_vertex_output  MeshVertexOutput
#import bevy_pbr::utils               PI

#ifdef TONEMAP_IN_SHADER
#import bevy_core_pipeline::tonemapping tone_mapping
#endif

// Sweep across hues on y axis with value from 0.0 to +15EV across x axis 
// quantized into 24 steps for both axis.
fn color_sweep(uv: vec2<f32>) -> vec3<f32> {
    var uv = uv;
    let steps = 24.0;
    uv.y = uv.y * (1.0 + 1.0 / steps);
    let ratio = 2.0;
    
    let h = PI * 2.0 * floor(1.0 + steps * uv.y) / steps;
    let L = floor(uv.x * steps * ratio) / (steps * ratio) - 0.5;
    
    var color = vec3(0.0);
    if uv.y < 1.0 { 
        color = cos(h + vec3(0.0, 1.0, 2.0) * PI * 2.0 / 3.0);
        let max_rgb = max(color.r, max(color.g, color.b));
        let min_rgb = min(color.r, min(color.g, color.b));
        color = exp(15.0 * L) * (color - min_rgb) / (max_rgb - min_rgb);
    } else {
        color = vec3(exp(15.0 * L));
    }
    return color;
}

fn hsv_to_srgb(c: vec3<f32>) -> vec3<f32> {
    let K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    let p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, vec3(0.0), vec3(1.0)), c.y);
}

// Generates a continuous sRGB sweep.
fn continuous_hue(uv: vec2<f32>) -> vec3<f32> {
    return hsv_to_srgb(vec3(uv.x, 1.0, 1.0)) * max(0.0, exp2(uv.y * 9.0) - 1.0);
}

@fragment
fn fragment(
    in: MeshVertexOutput,
) -> @location(0) vec4<f32> {
    var uv = in.uv;
    var out = vec3(0.0);
    if uv.y > 0.5 {
        uv.y = 1.0 - uv.y;
        out = color_sweep(vec2(uv.x, uv.y * 2.0));
    } else {
        out = continuous_hue(vec2(uv.y * 2.0, uv.x));
    }
    var color = vec4(out, 1.0);
#ifdef TONEMAP_IN_SHADER
    color = tone_mapping(color, bevy_pbr::mesh_view_bindings::view.color_grading);
#endif
    return color;
}
#import bevy_pbr::mesh_bindings   mesh
#import bevy_pbr::mesh_functions  get_model_matrix, mesh_position_local_to_clip

struct CustomMaterial {
    color: vec4<f32>,
};
@group(1) @binding(0) var<uniform> material: CustomMaterial;

struct Vertex {
    @builtin(instance_index) instance_index: u32,
    @location(0) position: vec3<f32>,
    @location(1) blend_color: vec4<f32>,
};

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) blend_color: vec4<f32>,
};

@vertex
fn vertex(vertex: Vertex) -> VertexOutput {
    var out: VertexOutput;
    out.clip_position = mesh_position_local_to_clip(
        get_model_matrix(vertex.instance_index),
        vec4<f32>(vertex.position, 1.0),
    );
    out.blend_color = vertex.blend_color;
    return out;
}

struct FragmentInput {
    @location(0) blend_color: vec4<f32>,
};

@fragment
fn fragment(input: FragmentInput) -> @location(0) vec4<f32> {
    return material.color * input.blend_color;
}
// This shader computes the chromatic aberration effect

#import bevy_pbr::utils

// Since post processing is a fullscreen effect, we use the fullscreen vertex shader provided by bevy.
// This will import a vertex shader that renders a single fullscreen triangle.
//
// A fullscreen triangle is a single triangle that covers the entire screen.
// The box in the top left in that diagram is the screen. The 4 x are the corner of the screen
//
// Y axis
//  1 |  x-----x......
//  0 |  |  s  |  . ´
// -1 |  x_____x´
// -2 |  :  .´
// -3 |  :´
//    +---------------  X axis
//      -1  0  1  2  3
//
// As you can see, the triangle ends up bigger than the screen.
//
// You don't need to worry about this too much since bevy will compute the correct UVs for you.
#import bevy_core_pipeline::fullscreen_vertex_shader FullscreenVertexOutput

@group(0) @binding(0) var screen_texture: texture_2d<f32>;
@group(0) @binding(1) var texture_sampler: sampler;
struct PostProcessSettings {
    intensity: f32,
#ifdef SIXTEEN_BYTE_ALIGNMENT
    // WebGL2 structs must be 16 byte aligned.
    _webgl2_padding: vec3<f32>
#endif
}
@group(0) @binding(2) var<uniform> settings: PostProcessSettings;

@fragment
fn fragment(in: FullscreenVertexOutput) -> @location(0) vec4<f32> {
    // Chromatic aberration strength
    let offset_strength = settings.intensity;

    // Sample each color channel with an arbitrary shift
    return vec4<f32>(
        texture_sample(screen_texture, texture_sampler, in.uv + vec2<f32>(offset_strength, -offset_strength)).r,
        texture_sample(screen_texture, texture_sampler, in.uv + vec2<f32>(-offset_strength, 0.0)).g,
        texture_sample(screen_texture, texture_sampler, in.uv + vec2<f32>(0.0, offset_strength)).b,
        1.0
    );
}

#import bevy_pbr::forward_io::VertexOutput

struct CustomMaterial {
    color: vec4<f32>,
};

@group(1) @binding(0) var<uniform> material: CustomMaterial;

@fragment
fn fragment(
    mesh: MeshVertexOutput,
) -> @location(0) vec4<f32> {
#ifdef IS_RED
    return vec4<f32>(1.0, 0.0, 0.0, 1.0);
#else
    return material.color;
#endif
}
@group(0) @binding(0) var texture: texture_storage_2d<rgba8unorm, read_write>;

fn hash(value: u32) -> u32 {
    var state = value;
    state = state ^ 2747636419u;
    state = state * 2654435769u;
    state = state ^ state >> 16u;
    state = state * 2654435769u;
    state = state ^ state >> 16u;
    state = state * 2654435769u;
    return state;
}

fn random_float(value: u32) -> f32 {
    return f32(hash(value)) / 4294967295.0;
}

@compute @workgroup_size(8, 8, 1)
fn init(@builtin(global_invocation_id) invocation_id: vec3<u32>, @builtin(num_workgroups) num_workgroups: vec3<u32>) {
    let location = vec2<i32>(i32(invocation_id.x), i32(invocation_id.y));

    let random_number = random_float(invocation_id.y * num_workgroups.x + invocation_id.x);
    let alive = random_number > 0.9;
    let color = vec4<f32>(f32(alive));

    texture_store(texture, location, color);
}

fn is_alive(location: vec2<i32>, offset_x: i32, offset_y: i32) -> i32 {
    let value: vec4<f32> = texture_load(texture, location + vec2<i32>(offset_x, offset_y));
    return i32(value.x);
}

fn count_alive(location: vec2<i32>) -> i32 {
    return is_alive(location, -1, -1) +
           is_alive(location, -1,  0) +
           is_alive(location, -1,  1) +
           is_alive(location,  0, -1) +
           is_alive(location,  0,  1) +
           is_alive(location,  1, -1) +
           is_alive(location,  1,  0) +
           is_alive(location,  1,  1);
}

@compute @workgroup_size(8, 8, 1)
fn update(@builtin(global_invocation_id) invocation_id: vec3<u32>) {
    let location = vec2<i32>(i32(invocation_id.x), i32(invocation_id.y));

    let n_alive = count_alive(location);

    var alive: bool;
    if (n_alive == 3) {
        alive = true;
    } else if (n_alive == 2) {
        let currently_alive = is_alive(location, 0, 0);
        alive = bool(currently_alive);
    } else {
        alive = false;
    }
    let color = vec4<f32>(f32(alive));

    storage_barrier();

    texture_store(texture, location, color);
}#import bevy_pbr::forward_io::VertexOutput

#ifdef CUBEMAP_ARRAY
@group(1) @binding(0) var base_color_texture: texture_cube_array<f32>;
#else
@group(1) @binding(0) var base_color_texture: texture_cube<f32>;
#endif

@group(1) @binding(1) var base_color_sampler: sampler;

@fragment
fn fragment(
    mesh: MeshVertexOutput,
) -> @location(0) vec4<f32> {
    let fragment_position_view_lh = mesh.world_position.xyz * vec3<f32>(1.0, 1.0, -1.0);
    return texture_sample(
        base_color_texture,
        base_color_sampler,
        fragment_position_view_lh
    );
}
#import bevy_pbr::forward_io::VertexOutput

struct LineMaterial {
    color: vec4<f32>,
};

@group(1) @binding(0) var<uniform> material: LineMaterial;

@fragment
fn fragment(
    mesh: MeshVertexOutput,
) -> @location(0) vec4<f32> {
    return material.color;
}
#import bevy_pbr::mesh_functions  get_model_matrix, mesh_position_local_to_clip
#import bevy_pbr::mesh_bindings   mesh

struct Vertex {
    @location(0) position: vec3<f32>,
    @location(1) normal: vec3<f32>,
    @location(2) uv: vec2<f32>,

    @location(3) i_pos_scale: vec4<f32>,
    @location(4) i_color: vec4<f32>,
};

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) color: vec4<f32>,
};

@vertex
fn vertex(vertex: Vertex) -> VertexOutput {
    let position = vertex.position * vertex.i_pos_scale.w + vertex.i_pos_scale.xyz;
    var out: VertexOutput;
    // NOTE: Passing 0 as the instance_index to get_model_matrix() is a hack
    // for this example as the instance_index builtin would map to the wrong
    // index in the Mesh array. This index could be passed in via another
    // uniform instead but it's unnecessary for the example.
    out.clip_position = mesh_position_local_to_clip(
        get_model_matrix(0u),
        vec4<f32>(position, 1.0)
    );
    out.color = vertex.i_color;
    return out;
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    return in.color;
}
#import bevy_pbr::forward_io::VertexOutput

@group(1) @binding(0) var textures: binding_array<texture_2d<f32>>;
@group(1) @binding(1) var nearest_sampler: sampler;
// We can also have array of samplers
// var samplers: binding_array<sampler>;

@fragment
fn fragment(
    mesh: MeshVertexOutput,
) -> @location(0) vec4<f32> {
    // Select the texture to sample from using non-uniform uv coordinates
    let coords = clamp(vec2<u32>(mesh.uv * 4.0), vec2<u32>(0u), vec2<u32>(3u));
    let index = coords.y * 4u + coords.x;
    let inner_uv = fract(mesh.uv * 4.0);
    return texture_sample(textures[index], nearest_sampler, inner_uv);
}
#import bevy_pbr::mesh_types
#import bevy_pbr::mesh_view_bindings  globals
#import bevy_pbr::prepass_utils
#import bevy_pbr::mesh_vertex_output  MeshVertexOutput

struct ShowPrepassSettings {
    show_depth: u32,
    show_normals: u32,
    show_motion_vectors: u32,
    padding_1: u32,
    padding_2: u32,
}
@group(1) @binding(0) var<uniform> settings: ShowPrepassSettings;

@fragment
fn fragment(
#ifdef MULTISAMPLED
    @builtin(sample_index) sample_index: u32,
#endif
    mesh: MeshVertexOutput,
) -> @location(0) vec4<f32> {
#ifndef MULTISAMPLED
    let sample_index = 0u;
#endif
    if settings.show_depth == 1u {
        let depth = bevy_pbr::prepass_utils::prepass_depth(mesh.position, sample_index);
        return vec4(depth, depth, depth, 1.0);
    } else if settings.show_normals == 1u {
        let normal = bevy_pbr::prepass_utils::prepass_normal(mesh.position, sample_index);
        return vec4(normal, 1.0);
    } else if settings.show_motion_vectors == 1u {
        let motion_vector = bevy_pbr::prepass_utils::prepass_motion_vector(mesh.position, sample_index);
        return vec4(motion_vector / globals.delta_time, 0.0, 1.0);
    }

    return vec4(0.0);
}
// If using this WGSL snippet as an #import, the following should be in scope:
//
// - the `morph_weights` uniform of type `MorphWeights`
// - the `morph_targets` 3d texture
//
// They are defined in `mesh_types.wgsl` and `mesh_bindings.wgsl`.

#define_import_path bevy_pbr::morph

#ifdef MORPH_TARGETS

#import bevy_pbr::mesh_types MorphWeights

#ifdef MESH_BINDGROUP_1

@group(1) @binding(2) var<uniform> morph_weights: MorphWeights;
@group(1) @binding(3) var morph_targets: texture_3d<f32>;

#else

@group(2) @binding(2) var<uniform> morph_weights: MorphWeights;
@group(2) @binding(3) var morph_targets: texture_3d<f32>;

#endif


// NOTE: Those are the "hardcoded" values found in `MorphAttributes` struct
// in crates/bevy_render/src/mesh/morph/visitors.rs
// In an ideal world, the offsets are established dynamically and passed as #defines
// to the shader, but it's out of scope for the initial implementation of morph targets.
const position_offset: u32 = 0u;
const normal_offset: u32 = 3u;
const tangent_offset: u32 = 6u;
const total_component_count: u32 = 9u;

fn layer_count() -> u32 {
    let dimensions = texture_dimensions(morph_targets);
    return u32(dimensions.z);
}
fn component_texture_coord(vertex_index: u32, component_offset: u32) -> vec2<u32> {
    let width = u32(texture_dimensions(morph_targets).x);
    let component_index = total_component_count * vertex_index + component_offset;
    return vec2<u32>(component_index % width, component_index / width);
}
fn weight_at(weight_index: u32) -> f32 {
    let i = weight_index;
    return morph_weights.weights[i / 4u][i % 4u];
}
fn morph_pixel(vertex: u32, component: u32, weight: u32) -> f32 {
    let coord = component_texture_coord(vertex, component);
    // Due to https://gpuweb.github.io/gpuweb/wgsl/#texel-formats
    // While the texture stores a f32, the textureLoad returns a vec4<>, where
    // only the first component is set.
    return texture_load(morph_targets, vec3(coord, weight), 0).r;
}
fn morph(vertex_index: u32, component_offset: u32, weight_index: u32) -> vec3<f32> {
    return vec3<f32>(
        morph_pixel(vertex_index, component_offset, weight_index),
        morph_pixel(vertex_index, component_offset + 1u, weight_index),
        morph_pixel(vertex_index, component_offset + 2u, weight_index),
    );
}

#endif // MORPH_TARGETS#define_import_path bevy_pbr::mesh_functions

#import bevy_pbr::mesh_view_bindings  view
#import bevy_pbr::mesh_bindings       mesh
#import bevy_pbr::mesh_types          MESH_FLAGS_SIGN_DETERMINANT_MODEL_3X3_BIT
#import bevy_render::instance_index   get_instance_index
#import bevy_render::maths            affine_to_square, mat2x4_f32_to_mat3x3_unpack

fn get_model_matrix(instance_index: u32) -> mat4x4<f32> {
    return affine_to_square(mesh[get_instance_index(instance_index)].model);
}

fn get_previous_model_matrix(instance_index: u32) -> mat4x4<f32> {
    return affine_to_square(mesh[get_instance_index(instance_index)].previous_model);
}

fn mesh_position_local_to_world(model: mat4x4<f32>, vertex_position: vec4<f32>) -> vec4<f32> {
    return model * vertex_position;
}

fn mesh_position_world_to_clip(world_position: vec4<f32>) -> vec4<f32> {
    return view.view_proj * world_position;
}

// NOTE: The intermediate world_position assignment is important
// for precision purposes when using the 'equals' depth comparison
// function.
fn mesh_position_local_to_clip(model: mat4x4<f32>, vertex_position: vec4<f32>) -> vec4<f32> {
    let world_position = mesh_position_local_to_world(model, vertex_position);
    return mesh_position_world_to_clip(world_position);
}

fn mesh_normal_local_to_world(vertex_normal: vec3<f32>, instance_index: u32) -> vec3<f32> {
    // NOTE: The mikktspace method of normal mapping requires that the world normal is
    // re-normalized in the vertex shader to match the way mikktspace bakes vertex tangents
    // and normal maps so that the exact inverse process is applied when shading. Blender, Unity,
    // Unreal Engine, Godot, and more all use the mikktspace method. Do not change this code
    // unless you really know what you are doing.
    // http://www.mikktspace.com/
    return normalize(
        mat2x4_f32_to_mat3x3_unpack(
            mesh[instance_index].inverse_transpose_model_a,
            mesh[instance_index].inverse_transpose_model_b,
        ) * vertex_normal
    );
}

// Calculates the sign of the determinant of the 3x3 model matrix based on a
// mesh flag
fn sign_determinant_model_3x3m(instance_index: u32) -> f32 {
    // bool(u32) is false if 0u else true
    // f32(bool) is 1.0 if true else 0.0
    // * 2.0 - 1.0 remaps 0.0 or 1.0 to -1.0 or 1.0 respectively
    return f32(bool(mesh[instance_index].flags & MESH_FLAGS_SIGN_DETERMINANT_MODEL_3X3_BIT)) * 2.0 - 1.0;
}

fn mesh_tangent_local_to_world(model: mat4x4<f32>, vertex_tangent: vec4<f32>, instance_index: u32) -> vec4<f32> {
    // NOTE: The mikktspace method of normal mapping requires that the world tangent is
    // re-normalized in the vertex shader to match the way mikktspace bakes vertex tangents
    // and normal maps so that the exact inverse process is applied when shading. Blender, Unity,
    // Unreal Engine, Godot, and more all use the mikktspace method. Do not change this code
    // unless you really know what you are doing.
    // http://www.mikktspace.com/
    return vec4<f32>(
        normalize(
            mat3x3<f32>(
                model[0].xyz,
                model[1].xyz,
                model[2].xyz
            ) * vertex_tangent.xyz
        ),
        // NOTE: Multiplying by the sign of the determinant of the 3x3 model matrix accounts for
        // situations such as negative scaling.
        vertex_tangent.w * sign_determinant_model_3x3m(instance_index)
    );
}
#define_import_path bevy_pbr::mesh_types

struct Mesh {
    // Affine 4x3 matrices transposed to 3x4
    // Use bevy_render::maths::affine_to_square to unpack
    model: mat3x4<f32>,
    previous_model: mat3x4<f32>,
    // 3x3 matrix packed in mat2x4 and f32 as:
    // [0].xyz, [1].x,
    // [1].yz, [2].xy
    // [2].z
    // Use bevy_pbr::mesh_functions::mat2x4_f32_to_mat3x3_unpack to unpack
    inverse_transpose_model_a: mat2x4<f32>,
    inverse_transpose_model_b: f32,
    // 'flags' is a bit field indicating various options. u32 is 32 bits so we have up to 32 options.
    flags: u32,
};

#ifdef SKINNED
struct SkinnedMesh {
    data: array<mat4x4<f32>, 256u>,
};
#endif

#ifdef MORPH_TARGETS
struct MorphWeights {
    weights: array<vec4<f32>, 16u>, // 16 = 64 / 4 (64 = MAX_MORPH_WEIGHTS)
};
#endif

const MESH_FLAGS_SHADOW_RECEIVER_BIT: u32 = 1u;
// 2^31 - if the flag is set, the sign is positive, else it is negative
const MESH_FLAGS_SIGN_DETERMINANT_MODEL_3X3_BIT: u32 = 2147483648u;
#define_import_path bevy_pbr::skinning

#import bevy_pbr::mesh_types  SkinnedMesh

#ifdef SKINNED

#ifdef MESH_BINDGROUP_1
    @group(1) @binding(1) var<uniform> joint_matrices: SkinnedMesh;
#else 
    @group(2) @binding(1) var<uniform> joint_matrices: SkinnedMesh;
#endif


fn skin_model(
    indexes: vec4<u32>,
    weights: vec4<f32>,
) -> mat4x4<f32> {
    return weights.x * joint_matrices.data[indexes.x]
        + weights.y * joint_matrices.data[indexes.y]
        + weights.z * joint_matrices.data[indexes.z]
        + weights.w * joint_matrices.data[indexes.w];
}

fn inverse_transpose_3x3m(in: mat3x3<f32>) -> mat3x3<f32> {
    let x = cross(in[1], in[2]);
    let y = cross(in[2], in[0]);
    let z = cross(in[0], in[1]);
    let det = dot(in[2], z);
    return mat3x3<f32>(
        x / det,
        y / det,
        z / det
    );
}

fn skin_normals(
    model: mat4x4<f32>,
    normal: vec3<f32>,
) -> vec3<f32> {
    return normalize(
        inverse_transpose_3x3m(
            mat3x3<f32>(
                model[0].xyz,
                model[1].xyz,
                model[2].xyz
            )
        ) * normal
    );
}

#endif
#define_import_path bevy_pbr::mesh_view_bindings

#import bevy_pbr::mesh_view_types as types
#import bevy_render::view  View
#import bevy_render::globals  Globals

@group(0) @binding(0) var<uniform> view: View;
@group(0) @binding(1) var<uniform> lights: types::Lights;
#ifdef NO_ARRAY_TEXTURES_SUPPORT
@group(0) @binding(2) var point_shadow_textures: texture_depth_cube;
#else
@group(0) @binding(2) var point_shadow_textures: texture_depth_cube_array;
#endif
@group(0) @binding(3) var point_shadow_textures_sampler: sampler_comparison;
#ifdef NO_ARRAY_TEXTURES_SUPPORT
@group(0) @binding(4) var directional_shadow_textures: texture_depth_2d;
#else
@group(0) @binding(4) var directional_shadow_textures: texture_depth_2d_array;
#endif
@group(0) @binding(5) var directional_shadow_textures_sampler: sampler_comparison;

#if AVAILABLE_STORAGE_BUFFER_BINDINGS >= 3
@group(0) @binding(6) var<storage> point_lights: types::PointLights;
@group(0) @binding(7) var<storage> cluster_light_index_lists: types::ClusterLightIndexLists;
@group(0) @binding(8) var<storage> cluster_offsets_and_counts: types::ClusterOffsetsAndCounts;
#else
@group(0) @binding(6) var<uniform> point_lights: types::PointLights;
@group(0) @binding(7) var<uniform> cluster_light_index_lists: types::ClusterLightIndexLists;
@group(0) @binding(8) var<uniform> cluster_offsets_and_counts: types::ClusterOffsetsAndCounts;
#endif

@group(0) @binding(9) var<uniform> globals: Globals;
@group(0) @binding(10) var<uniform> fog: types::Fog;

@group(0) @binding(11) var screen_space_ambient_occlusion_texture: texture_2d<f32>;

@group(0) @binding(12) var environment_map_diffuse: texture_cube<f32>;
@group(0) @binding(13) var environment_map_specular: texture_cube<f32>;
@group(0) @binding(14) var environment_map_sampler: sampler;

@group(0) @binding(15) var dt_lut_texture: texture_3d<f32>;
@group(0) @binding(16) var dt_lut_sampler: sampler;

#ifdef MULTISAMPLED
@group(0) @binding(17) var depth_prepass_texture: texture_depth_multisampled_2d;
@group(0) @binding(18) var normal_prepass_texture: texture_multisampled_2d<f32>;
@group(0) @binding(19) var motion_vector_prepass_texture: texture_multisampled_2d<f32>;
#else
@group(0) @binding(17) var depth_prepass_texture: texture_depth_2d;
@group(0) @binding(18) var normal_prepass_texture: texture_2d<f32>;
@group(0) @binding(19) var motion_vector_prepass_texture: texture_2d<f32>;
#endif
#import bevy_pbr::mesh_bindings    mesh
#import bevy_pbr::mesh_functions   get_model_matrix, mesh_position_local_to_clip
#import bevy_pbr::morph

#ifdef SKINNED
    #import bevy_pbr::skinning
#endif

struct Vertex {
    @builtin(instance_index) instance_index: u32,
    @location(0) position: vec3<f32>,
#ifdef SKINNED
    @location(5) joint_indexes: vec4<u32>,
    @location(6) joint_weights: vec4<f32>,
#endif
#ifdef MORPH_TARGETS
    @builtin(vertex_index) index: u32,
#endif
};

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
};


#ifdef MORPH_TARGETS
fn morph_vertex(vertex_in: Vertex) -> Vertex {
    var vertex = vertex_in;
    let weight_count = bevy_pbr::morph::layer_count();
    for (var i: u32 = 0u; i < weight_count; i ++) {
        let weight = bevy_pbr::morph::weight_at(i);
        if weight == 0.0 {
            continue;
        }
        vertex.position += weight * bevy_pbr::morph::morph(vertex.index, bevy_pbr::morph::position_offset, i);
    }
    return vertex;
}
#endif

@vertex
fn vertex(vertex_no_morph: Vertex) -> VertexOutput {

#ifdef MORPH_TARGETS
    var vertex = morph_vertex(vertex_no_morph);
#else
    var vertex = vertex_no_morph;
#endif

#ifdef SKINNED
    let model = bevy_pbr::skinning::skin_model(vertex.joint_indexes, vertex.joint_weights);
#else
    let model = get_model_matrix(vertex.instance_index);
#endif

    var out: VertexOutput;
    out.clip_position = mesh_position_local_to_clip(model, vec4<f32>(vertex.position, 1.0));
    return out;
}

@fragment
fn fragment() -> @location(0) vec4<f32> {
    return vec4<f32>(1.0, 1.0, 1.0, 1.0);
}
#define_import_path bevy_pbr::fragment

#import bevy_pbr::pbr_functions as pbr_functions
#import bevy_pbr::pbr_bindings as pbr_bindings
#import bevy_pbr::pbr_types as pbr_types
#import bevy_pbr::prepass_utils

#import bevy_pbr::mesh_vertex_output       MeshVertexOutput
#import bevy_pbr::mesh_bindings            mesh
#import bevy_pbr::mesh_view_bindings       view, fog, screen_space_ambient_occlusion_texture
#import bevy_pbr::mesh_view_types          FOG_MODE_OFF
#import bevy_core_pipeline::tonemapping    screen_space_dither, powsafe, tone_mapping
#import bevy_pbr::parallax_mapping         parallaxed_uv

#import bevy_pbr::prepass_utils

#ifdef SCREEN_SPACE_AMBIENT_OCCLUSION
#import bevy_pbr::gtao_utils gtao_multibounce
#endif

@fragment
fn fragment(
    in: MeshVertexOutput,
    @builtin(front_facing) is_front: bool,
) -> @location(0) vec4<f32> {
    var output_color: vec4<f32> = pbr_bindings::material.base_color;

    let is_orthographic = view.projection[3].w == 1.0;
    let V = pbr_functions::calculate_view(in.world_position, is_orthographic);
#ifdef VERTEX_UVS
    var uv = in.uv;
#ifdef VERTEX_TANGENTS
    if ((pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_DEPTH_MAP_BIT) != 0u) {
        let N = in.world_normal;
        let T = in.world_tangent.xyz;
        let B = in.world_tangent.w * cross(N, T);
        // Transform V from fragment to camera in world space to tangent space.
        let Vt = vec3(dot(V, T), dot(V, B), dot(V, N));
        uv = parallaxed_uv(
            pbr_bindings::material.parallax_depth_scale,
            pbr_bindings::material.max_parallax_layer_count,
            pbr_bindings::material.max_relief_mapping_search_steps,
            uv,
            // Flip the direction of Vt to go toward the surface to make the
            // parallax mapping algorithm easier to understand and reason
            // about.
            -Vt,
        );
    }
#endif
#endif

#ifdef VERTEX_COLORS
    output_color = output_color * in.color;
#endif
#ifdef VERTEX_UVS
    if ((pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_BASE_COLOR_TEXTURE_BIT) != 0u) {
        output_color = output_color * texture_sample_bias(pbr_bindings::base_color_texture, pbr_bindings::base_color_sampler, uv, view.mip_bias);
    }
#endif

    // NOTE: Unlit bit not set means == 0 is true, so the true case is if lit
    if ((pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_UNLIT_BIT) == 0u) {
        // Prepare a 'processed' StandardMaterial by sampling all textures to resolve
        // the material members
        var pbr_input: pbr_functions::PbrInput;

        pbr_input.material.base_color = output_color;
        pbr_input.material.reflectance = pbr_bindings::material.reflectance;
        pbr_input.material.flags = pbr_bindings::material.flags;
        pbr_input.material.alpha_cutoff = pbr_bindings::material.alpha_cutoff;

        // TODO use .a for exposure compensation in HDR
        var emissive: vec4<f32> = pbr_bindings::material.emissive;
#ifdef VERTEX_UVS
        if ((pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_EMISSIVE_TEXTURE_BIT) != 0u) {
            emissive = vec4<f32>(emissive.rgb * texture_sample_bias(pbr_bindings::emissive_texture, pbr_bindings::emissive_sampler, uv, view.mip_bias).rgb, 1.0);
        }
#endif
        pbr_input.material.emissive = emissive;

        var metallic: f32 = pbr_bindings::material.metallic;
        var perceptual_roughness: f32 = pbr_bindings::material.perceptual_roughness;
#ifdef VERTEX_UVS
        if ((pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_METALLIC_ROUGHNESS_TEXTURE_BIT) != 0u) {
            let metallic_roughness = texture_sample_bias(pbr_bindings::metallic_roughness_texture, pbr_bindings::metallic_roughness_sampler, uv, view.mip_bias);
            // Sampling from GLTF standard channels for now
            metallic = metallic * metallic_roughness.b;
            perceptual_roughness = perceptual_roughness * metallic_roughness.g;
        }
#endif
        pbr_input.material.metallic = metallic;
        pbr_input.material.perceptual_roughness = perceptual_roughness;

        // TODO: Split into diffuse/specular occlusion?
        var occlusion: vec3<f32> = vec3(1.0);
#ifdef VERTEX_UVS
        if ((pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_OCCLUSION_TEXTURE_BIT) != 0u) {
            occlusion = vec3(texture_sample_bias(pbr_bindings::occlusion_texture, pbr_bindings::occlusion_sampler, uv, view.mip_bias).r);
        }
#endif
#ifdef SCREEN_SPACE_AMBIENT_OCCLUSION
        let ssao = texture_load(screen_space_ambient_occlusion_texture, vec2<i32>(in.position.xy), 0i).r;
        let ssao_multibounce = gtao_multibounce(ssao, pbr_input.material.base_color.rgb);
        occlusion = min(occlusion, ssao_multibounce);
#endif
        pbr_input.occlusion = occlusion;

        pbr_input.frag_coord = in.position;
        pbr_input.world_position = in.world_position;

        pbr_input.world_normal = pbr_functions::prepare_world_normal(
            in.world_normal,
            (pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_DOUBLE_SIDED_BIT) != 0u,
            is_front,
        );

        pbr_input.is_orthographic = is_orthographic;

#ifdef LOAD_PREPASS_NORMALS
        pbr_input.N = bevy_pbr::prepass_utils::prepass_normal(in.position, 0u);
#else
        pbr_input.N = pbr_functions::apply_normal_mapping(
            pbr_bindings::material.flags,
            pbr_input.world_normal,
#ifdef VERTEX_TANGENTS
#ifdef STANDARDMATERIAL_NORMAL_MAP
            in.world_tangent,
#endif
#endif
#ifdef VERTEX_UVS
            uv,
#endif
            view.mip_bias,
        );
#endif

        pbr_input.V = V;
        pbr_input.occlusion = occlusion;

        pbr_input.flags = mesh[in.instance_index].flags;

        output_color = pbr_functions::pbr(pbr_input);
    } else {
        output_color = pbr_functions::alpha_discard(pbr_bindings::material, output_color);
    }

    // fog
    if (fog.mode != FOG_MODE_OFF && (pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_FOG_ENABLED_BIT) != 0u) {
        output_color = pbr_functions::apply_fog(fog, output_color, in.world_position.xyz, view.world_position.xyz);
    }

#ifdef TONEMAP_IN_SHADER
    output_color = tone_mapping(output_color, view.color_grading);
#ifdef DEBAND_DITHER
    var output_rgb = output_color.rgb;
    output_rgb = powsafe(output_rgb, 1.0 / 2.2);
    output_rgb = output_rgb + screen_space_dither(in.position.xy);
    // This conversion back to linear space is required because our output texture format is
    // SRGB; the GPU will assume our output is linear and will apply an SRGB conversion.
    output_rgb = powsafe(output_rgb, 2.2);
    output_color = vec4(output_rgb, output_color.a);
#endif
#endif
#ifdef PREMULTIPLY_ALPHA
    output_color = pbr_functions::premultiply_alpha(pbr_bindings::material.flags, output_color);
#endif
    return output_color;
}
#define_import_path bevy_pbr::pbr_bindings

#import bevy_pbr::pbr_types  StandardMaterial

@group(1) @binding(0) var<uniform> material: StandardMaterial;
@group(1) @binding(1) var base_color_texture: texture_2d<f32>;
@group(1) @binding(2) var base_color_sampler: sampler;
@group(1) @binding(3) var emissive_texture: texture_2d<f32>;
@group(1) @binding(4) var emissive_sampler: sampler;
@group(1) @binding(5) var metallic_roughness_texture: texture_2d<f32>;
@group(1) @binding(6) var metallic_roughness_sampler: sampler;
@group(1) @binding(7) var occlusion_texture: texture_2d<f32>;
@group(1) @binding(8) var occlusion_sampler: sampler;
@group(1) @binding(9) var normal_map_texture: texture_2d<f32>;
@group(1) @binding(10) var normal_map_sampler: sampler;
@group(1) @binding(11) var depth_map_texture: texture_2d<f32>;
@group(1) @binding(12) var depth_map_sampler: sampler;
#define_import_path bevy_pbr::mesh_vertex_output

struct MeshVertexOutput {
    // this is `clip position` when the struct is used as a vertex stage output
    // and `frag coord` when used as a fragment stage input
    @builtin(position) position: vec4<f32>,
    @location(0) world_position: vec4<f32>,
    @location(1) world_normal: vec3<f32>,
    #ifdef VERTEX_UVS
    @location(2) uv: vec2<f32>,
    #endif
    #ifdef VERTEX_TANGENTS
    @location(3) world_tangent: vec4<f32>,
    #endif
    #ifdef VERTEX_COLORS
    @location(4) color: vec4<f32>,
    #endif
    #ifdef VERTEX_OUTPUT_INSTANCE_INDEX
    @location(5) @interpolate(flat) instance_index: u32,
    #endif
}
#define_import_path bevy_pbr::mesh_bindings

#import bevy_pbr::mesh_types Mesh

#ifdef MESH_BINDGROUP_1

#ifdef PER_OBJECT_BUFFER_BATCH_SIZE
@group(1) @binding(0) var<uniform> mesh: array<Mesh, #{PER_OBJECT_BUFFER_BATCH_SIZE}u>;
#else
@group(1) @binding(0) var<storage> mesh: array<Mesh>;
#endif // PER_OBJECT_BUFFER_BATCH_SIZE

#else // MESH_BINDGROUP_1

#ifdef PER_OBJECT_BUFFER_BATCH_SIZE
@group(2) @binding(0) var<uniform> mesh: array<Mesh, #{PER_OBJECT_BUFFER_BATCH_SIZE}u>;
#else
@group(2) @binding(0) var<storage> mesh: array<Mesh>;
#endif // PER_OBJECT_BUFFER_BATCH_SIZE

#endif // MESH_BINDGROUP_1
#import bevy_pbr::mesh_functions as mesh_functions
#import bevy_pbr::skinning
#import bevy_pbr::morph
#import bevy_pbr::mesh_bindings       mesh
#import bevy_pbr::mesh_vertex_output  MeshVertexOutput
#import bevy_render::instance_index   get_instance_index

struct Vertex {
    @builtin(instance_index) instance_index: u32,
#ifdef VERTEX_POSITIONS
    @location(0) position: vec3<f32>,
#endif
#ifdef VERTEX_NORMALS
    @location(1) normal: vec3<f32>,
#endif
#ifdef VERTEX_UVS
    @location(2) uv: vec2<f32>,
#endif
#ifdef VERTEX_TANGENTS
    @location(3) tangent: vec4<f32>,
#endif
#ifdef VERTEX_COLORS
    @location(4) color: vec4<f32>,
#endif
#ifdef SKINNED
    @location(5) joint_indices: vec4<u32>,
    @location(6) joint_weights: vec4<f32>,
#endif
#ifdef MORPH_TARGETS
    @builtin(vertex_index) index: u32,
#endif
};

#ifdef MORPH_TARGETS
fn morph_vertex(vertex_in: Vertex) -> Vertex {
    var vertex = vertex_in;
    let weight_count = bevy_pbr::morph::layer_count();
    for (var i: u32 = 0u; i < weight_count; i ++) {
        let weight = bevy_pbr::morph::weight_at(i);
        if weight == 0.0 {
            continue;
        }
        vertex.position += weight * bevy_pbr::morph::morph(vertex.index, bevy_pbr::morph::position_offset, i);
#ifdef VERTEX_NORMALS
        vertex.normal += weight * bevy_pbr::morph::morph(vertex.index, bevy_pbr::morph::normal_offset, i);
#endif
#ifdef VERTEX_TANGENTS
        vertex.tangent += vec4(weight * bevy_pbr::morph::morph(vertex.index, bevy_pbr::morph::tangent_offset, i), 0.0);
#endif
    }
    return vertex;
}
#endif

@vertex
fn vertex(vertex_no_morph: Vertex) -> MeshVertexOutput {
    var out: MeshVertexOutput;

#ifdef MORPH_TARGETS
    var vertex = morph_vertex(vertex_no_morph);
#else
    var vertex = vertex_no_morph;
#endif

#ifdef SKINNED
    var model = bevy_pbr::skinning::skin_model(vertex.joint_indices, vertex.joint_weights);
#else
    // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
    // See https://github.com/gfx-rs/naga/issues/2416 .
    var model = mesh_functions::get_model_matrix(vertex_no_morph.instance_index);
#endif

#ifdef VERTEX_NORMALS
#ifdef SKINNED
    out.world_normal = bevy_pbr::skinning::skin_normals(model, vertex.normal);
#else
    out.world_normal = mesh_functions::mesh_normal_local_to_world(
        vertex.normal,
        // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
        // See https://github.com/gfx-rs/naga/issues/2416
        get_instance_index(vertex_no_morph.instance_index)
    );
#endif
#endif

#ifdef VERTEX_POSITIONS
    out.world_position = mesh_functions::mesh_position_local_to_world(model, vec4<f32>(vertex.position, 1.0));
    out.position = mesh_functions::mesh_position_world_to_clip(out.world_position);
#endif

#ifdef VERTEX_UVS
    out.uv = vertex.uv;
#endif

#ifdef VERTEX_TANGENTS
    out.world_tangent = mesh_functions::mesh_tangent_local_to_world(
        model,
        vertex.tangent,
        // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
        // See https://github.com/gfx-rs/naga/issues/2416
        get_instance_index(vertex_no_morph.instance_index)
    );
#endif

#ifdef VERTEX_COLORS
    out.color = vertex.color;
#endif

#ifdef VERTEX_OUTPUT_INSTANCE_INDEX
    // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
    // See https://github.com/gfx-rs/naga/issues/2416
    out.instance_index = get_instance_index(vertex_no_morph.instance_index);
#endif

    return out;
}

@fragment
fn fragment(
    mesh: MeshVertexOutput,
) -> @location(0) vec4<f32> {
#ifdef VERTEX_COLORS
    return mesh.color;
#else
    return vec4<f32>(1.0, 0.0, 1.0, 1.0);
#endif
}
#define_import_path bevy_pbr::pbr_functions

#ifdef TONEMAP_IN_SHADER
#import bevy_core_pipeline::tonemapping
#endif

#import bevy_pbr::pbr_types as pbr_types
#import bevy_pbr::pbr_bindings as pbr_bindings
#import bevy_pbr::mesh_view_bindings as view_bindings
#import bevy_pbr::mesh_view_types as mesh_view_types
#import bevy_pbr::lighting as lighting
#import bevy_pbr::clustered_forward as clustering
#import bevy_pbr::shadows as shadows
#import bevy_pbr::fog as fog
#import bevy_pbr::ambient as ambient
#ifdef ENVIRONMENT_MAP
#import bevy_pbr::environment_map
#endif

#import bevy_pbr::mesh_bindings   mesh
#import bevy_pbr::mesh_types      MESH_FLAGS_SHADOW_RECEIVER_BIT

fn alpha_discard(material: pbr_types::StandardMaterial, output_color: vec4<f32>) -> vec4<f32> {
    var color = output_color;
    let alpha_mode = material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_ALPHA_MODE_RESERVED_BITS;
    if alpha_mode == pbr_types::STANDARD_MATERIAL_FLAGS_ALPHA_MODE_OPAQUE {
        // NOTE: If rendering as opaque, alpha should be ignored so set to 1.0
        color.a = 1.0;
    }

#ifdef MAY_DISCARD
    else if alpha_mode == pbr_types::STANDARD_MATERIAL_FLAGS_ALPHA_MODE_MASK {
        if color.a >= material.alpha_cutoff {
            // NOTE: If rendering as masked alpha and >= the cutoff, render as fully opaque
            color.a = 1.0;
        } else {
            // NOTE: output_color.a < in.material.alpha_cutoff should not be rendered
            discard;
        }
    }
#endif

    return color;
}

fn prepare_world_normal(
    world_normal: vec3<f32>,
    double_sided: bool,
    is_front: bool,
) -> vec3<f32> {
    var output: vec3<f32> = world_normal;
#ifndef VERTEX_TANGENTS
#ifndef STANDARDMATERIAL_NORMAL_MAP
    // NOTE: When NOT using normal-mapping, if looking at the back face of a double-sided
    // material, the normal needs to be inverted. This is a branchless version of that.
    output = (f32(!double_sided || is_front) * 2.0 - 1.0) * output;
#endif
#endif
    return output;
}

fn apply_normal_mapping(
    standard_material_flags: u32,
    world_normal: vec3<f32>,
#ifdef VERTEX_TANGENTS
#ifdef STANDARDMATERIAL_NORMAL_MAP
    world_tangent: vec4<f32>,
#endif
#endif
#ifdef VERTEX_UVS
    uv: vec2<f32>,
#endif
    mip_bias: f32,
) -> vec3<f32> {
    // NOTE: The mikktspace method of normal mapping explicitly requires that the world normal NOT
    // be re-normalized in the fragment shader. This is primarily to match the way mikktspace
    // bakes vertex tangents and normal maps so that this is the exact inverse. Blender, Unity,
    // Unreal Engine, Godot, and more all use the mikktspace method. Do not change this code
    // unless you really know what you are doing.
    // http://www.mikktspace.com/
    var N: vec3<f32> = world_normal;

#ifdef VERTEX_TANGENTS
#ifdef STANDARDMATERIAL_NORMAL_MAP
    // NOTE: The mikktspace method of normal mapping explicitly requires that these NOT be
    // normalized nor any Gram-Schmidt applied to ensure the vertex normal is orthogonal to the
    // vertex tangent! Do not change this code unless you really know what you are doing.
    // http://www.mikktspace.com/
    var T: vec3<f32> = world_tangent.xyz;
    var B: vec3<f32> = world_tangent.w * cross(N, T);
#endif
#endif

#ifdef VERTEX_TANGENTS
#ifdef VERTEX_UVS
#ifdef STANDARDMATERIAL_NORMAL_MAP
    // Nt is the tangent-space normal.
    var Nt = texture_sample_bias(pbr_bindings::normal_map_texture, pbr_bindings::normal_map_sampler, uv, mip_bias).rgb;
    if (standard_material_flags & pbr_types::STANDARD_MATERIAL_FLAGS_TWO_COMPONENT_NORMAL_MAP) != 0u {
        // Only use the xy components and derive z for 2-component normal maps.
        Nt = vec3<f32>(Nt.rg * 2.0 - 1.0, 0.0);
        Nt.z = sqrt(1.0 - Nt.x * Nt.x - Nt.y * Nt.y);
    } else {
        Nt = Nt * 2.0 - 1.0;
    }
    // Normal maps authored for DirectX require flipping the y component
    if (standard_material_flags & pbr_types::STANDARD_MATERIAL_FLAGS_FLIP_NORMAL_MAP_Y) != 0u {
        Nt.y = -Nt.y;
    }
    // NOTE: The mikktspace method of normal mapping applies maps the tangent-space normal from
    // the normal map texture in this way to be an EXACT inverse of how the normal map baker
    // calculates the normal maps so there is no error introduced. Do not change this code
    // unless you really know what you are doing.
    // http://www.mikktspace.com/
    N = Nt.x * T + Nt.y * B + Nt.z * N;
#endif
#endif
#endif

    return normalize(N);
}

// NOTE: Correctly calculates the view vector depending on whether
// the projection is orthographic or perspective.
fn calculate_view(
    world_position: vec4<f32>,
    is_orthographic: bool,
) -> vec3<f32> {
    var V: vec3<f32>;
    if is_orthographic {
        // Orthographic view vector
        V = normalize(vec3<f32>(view_bindings::view.view_proj[0].z, view_bindings::view.view_proj[1].z, view_bindings::view.view_proj[2].z));
    } else {
        // Only valid for a perpective projection
        V = normalize(view_bindings::view.world_position.xyz - world_position.xyz);
    }
    return V;
}

struct PbrInput {
    material: pbr_types::StandardMaterial,
    occlusion: vec3<f32>,
    frag_coord: vec4<f32>,
    world_position: vec4<f32>,
    // Normalized world normal used for shadow mapping as normal-mapping is not used for shadow
    // mapping
    world_normal: vec3<f32>,
    // Normalized normal-mapped world normal used for lighting
    N: vec3<f32>,
    // Normalized view vector in world space, pointing from the fragment world position toward the
    // view world position
    V: vec3<f32>,
    is_orthographic: bool,
    flags: u32,
};

// Creates a PbrInput with default values
fn pbr_input_new() -> PbrInput {
    var pbr_input: PbrInput;

    pbr_input.material = pbr_types::standard_material_new();
    pbr_input.occlusion = vec3<f32>(1.0);

    pbr_input.frag_coord = vec4<f32>(0.0, 0.0, 0.0, 1.0);
    pbr_input.world_position = vec4<f32>(0.0, 0.0, 0.0, 1.0);
    pbr_input.world_normal = vec3<f32>(0.0, 0.0, 1.0);

    pbr_input.is_orthographic = false;

    pbr_input.N = vec3<f32>(0.0, 0.0, 1.0);
    pbr_input.V = vec3<f32>(1.0, 0.0, 0.0);

    pbr_input.flags = 0u;

    return pbr_input;
}

#ifndef PREPASS_FRAGMENT
fn pbr(
    in: PbrInput,
) -> vec4<f32> {
    var output_color: vec4<f32> = in.material.base_color;

    // TODO use .a for exposure compensation in HDR
    let emissive = in.material.emissive;

    // calculate non-linear roughness from linear perceptualRoughness
    let metallic = in.material.metallic;
    let perceptual_roughness = in.material.perceptual_roughness;
    let roughness = lighting::perceptual_roughness_to_roughness(perceptual_roughness);

    let occlusion = in.occlusion;

    output_color = alpha_discard(in.material, output_color);

    // Neubelt and Pettineo 2013, "Crafting a Next-gen Material Pipeline for The Order: 1886"
    let NdotV = max(dot(in.N, in.V), 0.0001);

    // Remapping [0,1] reflectance to F0
    // See https://google.github.io/filament/Filament.html#materialsystem/parameterization/remapping
    let reflectance = in.material.reflectance;
    let F0 = 0.16 * reflectance * reflectance * (1.0 - metallic) + output_color.rgb * metallic;

    // Diffuse strength inversely related to metallicity
    let diffuse_color = output_color.rgb * (1.0 - metallic);

    let R = reflect(-in.V, in.N);

    let f_ab = lighting::F_AB(perceptual_roughness, NdotV);

    var direct_light: vec3<f32> = vec3<f32>(0.0);

    let view_z = dot(vec4<f32>(
        view_bindings::view.inverse_view[0].z,
        view_bindings::view.inverse_view[1].z,
        view_bindings::view.inverse_view[2].z,
        view_bindings::view.inverse_view[3].z
    ), in.world_position);
    let cluster_index = clustering::fragment_cluster_index(in.frag_coord.xy, view_z, in.is_orthographic);
    let offset_and_counts = clustering::unpack_offset_and_counts(cluster_index);

    // Point lights (direct)
    for (var i: u32 = offset_and_counts[0]; i < offset_and_counts[0] + offset_and_counts[1]; i = i + 1u) {
        let light_id = clustering::get_light_id(i);
        var shadow: f32 = 1.0;
        if ((in.flags & MESH_FLAGS_SHADOW_RECEIVER_BIT) != 0u
                && (view_bindings::point_lights.data[light_id].flags & mesh_view_types::POINT_LIGHT_FLAGS_SHADOWS_ENABLED_BIT) != 0u) {
            shadow = shadows::fetch_point_shadow(light_id, in.world_position, in.world_normal);
        }
        let light_contrib = lighting::point_light(in.world_position.xyz, light_id, roughness, NdotV, in.N, in.V, R, F0, f_ab, diffuse_color);
        direct_light += light_contrib * shadow;
    }

    // Spot lights (direct)
    for (var i: u32 = offset_and_counts[0] + offset_and_counts[1]; i < offset_and_counts[0] + offset_and_counts[1] + offset_and_counts[2]; i = i + 1u) {
        let light_id = clustering::get_light_id(i);

        var shadow: f32 = 1.0;
        if ((in.flags & MESH_FLAGS_SHADOW_RECEIVER_BIT) != 0u
                && (view_bindings::point_lights.data[light_id].flags & mesh_view_types::POINT_LIGHT_FLAGS_SHADOWS_ENABLED_BIT) != 0u) {
            shadow = shadows::fetch_spot_shadow(light_id, in.world_position, in.world_normal);
        }
        let light_contrib = lighting::spot_light(in.world_position.xyz, light_id, roughness, NdotV, in.N, in.V, R, F0, f_ab, diffuse_color);
        direct_light += light_contrib * shadow;
    }

    // directional lights (direct)
    let n_directional_lights = view_bindings::lights.n_directional_lights;
    for (var i: u32 = 0u; i < n_directional_lights; i = i + 1u) {
        var shadow: f32 = 1.0;
        if ((in.flags & MESH_FLAGS_SHADOW_RECEIVER_BIT) != 0u
                && (view_bindings::lights.directional_lights[i].flags & mesh_view_types::DIRECTIONAL_LIGHT_FLAGS_SHADOWS_ENABLED_BIT) != 0u) {
            shadow = shadows::fetch_directional_shadow(i, in.world_position, in.world_normal, view_z);
        }
        var light_contrib = lighting::directional_light(i, roughness, NdotV, in.N, in.V, R, F0, f_ab, diffuse_color);
#ifdef DIRECTIONAL_LIGHT_SHADOW_MAP_DEBUG_CASCADES
        light_contrib = shadows::cascade_debug_visualization(light_contrib, i, view_z);
#endif
        direct_light += light_contrib * shadow;
    }

    // Ambient light (indirect)
    var indirect_light = ambient::ambient_light(in.world_position, in.N, in.V, NdotV, diffuse_color, F0, perceptual_roughness, occlusion);

    // Environment map light (indirect)
#ifdef ENVIRONMENT_MAP
    let environment_light = bevy_pbr::environment_map::environment_map_light(perceptual_roughness, roughness, diffuse_color, NdotV, f_ab, in.N, R, F0);
    indirect_light += (environment_light.diffuse * occlusion) + environment_light.specular;
#endif

    let emissive_light = emissive.rgb * output_color.a;

    // Total light
    output_color = vec4<f32>(
        direct_light + indirect_light + emissive_light,
        output_color.a
    );

    output_color = clustering::cluster_debug_visualization(
        output_color,
        view_z,
        in.is_orthographic,
        offset_and_counts,
        cluster_index,
    );

    return output_color;
}
#endif // PREPASS_FRAGMENT

#ifndef PREPASS_FRAGMENT
fn apply_fog(fog_params: mesh_view_types::Fog, input_color: vec4<f32>, fragment_world_position: vec3<f32>, view_world_position: vec3<f32>) -> vec4<f32> {
    let view_to_world = fragment_world_position.xyz - view_world_position.xyz;

    // `length()` is used here instead of just `view_to_world.z` since that produces more
    // high quality results, especially for denser/smaller fogs. we get a "curved"
    // fog shape that remains consistent with camera rotation, instead of a "linear"
    // fog shape that looks a bit fake
    let distance = length(view_to_world);

    var scattering = vec3<f32>(0.0);
    if fog_params.directional_light_color.a > 0.0 {
        let view_to_world_normalized = view_to_world / distance;
        let n_directional_lights = view_bindings::lights.n_directional_lights;
        for (var i: u32 = 0u; i < n_directional_lights; i = i + 1u) {
            let light = view_bindings::lights.directional_lights[i];
            scattering += pow(
                max(
                    dot(view_to_world_normalized, light.direction_to_light),
                    0.0
                ),
                fog_params.directional_light_exponent
            ) * light.color.rgb;
        }
    }

    if fog_params.mode == mesh_view_types::FOG_MODE_LINEAR {
        return fog::linear_fog(fog_params, input_color, distance, scattering);
    } else if fog_params.mode == mesh_view_types::FOG_MODE_EXPONENTIAL {
        return fog::exponential_fog(fog_params, input_color, distance, scattering);
    } else if fog_params.mode == mesh_view_types::FOG_MODE_EXPONENTIAL_SQUARED {
        return fog::exponential_squared_fog(fog_params, input_color, distance, scattering);
    } else if fog_params.mode == mesh_view_types::FOG_MODE_ATMOSPHERIC {
        return fog::atmospheric_fog(fog_params, input_color, distance, scattering);
    } else {
        return input_color;
    }
}
#endif // PREPASS_FRAGMENT

#ifdef PREMULTIPLY_ALPHA
fn premultiply_alpha(standard_material_flags: u32, color: vec4<f32>) -> vec4<f32> {
// `Blend`, `Premultiplied` and `Alpha` all share the same `BlendState`. Depending
// on the alpha mode, we premultiply the color channels by the alpha channel value,
// (and also optionally replace the alpha value with 0.0) so that the result produces
// the desired blend mode when sent to the blending operation.
#ifdef BLEND_PREMULTIPLIED_ALPHA
    // For `BlendState::PREMULTIPLIED_ALPHA_BLENDING` the blend function is:
    //
    //     result = 1 * src_color + (1 - src_alpha) * dst_color
    let alpha_mode = standard_material_flags & pbr_types::STANDARD_MATERIAL_FLAGS_ALPHA_MODE_RESERVED_BITS;
    if alpha_mode == pbr_types::STANDARD_MATERIAL_FLAGS_ALPHA_MODE_ADD {
        // Here, we premultiply `src_color` by `src_alpha`, and replace `src_alpha` with 0.0:
        //
        //     src_color *= src_alpha
        //     src_alpha = 0.0
        //
        // We end up with:
        //
        //     result = 1 * (src_alpha * src_color) + (1 - 0) * dst_color
        //     result = src_alpha * src_color + 1 * dst_color
        //
        // Which is the blend operation for additive blending
        return vec4<f32>(color.rgb * color.a, 0.0);
    } else {
        // Here, we don't do anything, so that we get premultiplied alpha blending. (As expected)
        return color.rgba;
    }
#endif
// `Multiply` uses its own `BlendState`, but we still need to premultiply here in the
// shader so that we get correct results as we tweak the alpha channel
#ifdef BLEND_MULTIPLY
    // The blend function is:
    //
    //     result = dst_color * src_color + (1 - src_alpha) * dst_color
    //
    // We premultiply `src_color` by `src_alpha`:
    //
    //     src_color *= src_alpha
    //
    // We end up with:
    //
    //     result = dst_color * (src_color * src_alpha) + (1 - src_alpha) * dst_color
    //     result = src_alpha * (src_color * dst_color) + (1 - src_alpha) * dst_color
    //
    // Which is the blend operation for multiplicative blending with arbitrary mixing
    // controlled by the source alpha channel
    return vec4<f32>(color.rgb * color.a, color.a);
#endif
}
#endif
#import bevy_pbr::prepass_bindings
#import bevy_pbr::mesh_functions
#import bevy_pbr::skinning
#import bevy_pbr::morph
#import bevy_pbr::mesh_bindings mesh
#import bevy_render::instance_index get_instance_index

// Most of these attributes are not used in the default prepass fragment shader, but they are still needed so we can
// pass them to custom prepass shaders like pbr_prepass.wgsl.
struct Vertex {
    @builtin(instance_index) instance_index: u32,
    @location(0) position: vec3<f32>,

#ifdef VERTEX_UVS
    @location(1) uv: vec2<f32>,
#endif // VERTEX_UVS

#ifdef NORMAL_PREPASS
    @location(2) normal: vec3<f32>,
#ifdef VERTEX_TANGENTS
    @location(3) tangent: vec4<f32>,
#endif // VERTEX_TANGENTS
#endif // NORMAL_PREPASS

#ifdef SKINNED
    @location(4) joint_indices: vec4<u32>,
    @location(5) joint_weights: vec4<f32>,
#endif // SKINNED

#ifdef MORPH_TARGETS
    @builtin(vertex_index) index: u32,
#endif // MORPH_TARGETS
}

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,

#ifdef VERTEX_UVS
    @location(0) uv: vec2<f32>,
#endif // VERTEX_UVS

#ifdef NORMAL_PREPASS
    @location(1) world_normal: vec3<f32>,
#ifdef VERTEX_TANGENTS
    @location(2) world_tangent: vec4<f32>,
#endif // VERTEX_TANGENTS
#endif // NORMAL_PREPASS

#ifdef MOTION_VECTOR_PREPASS
    @location(3) world_position: vec4<f32>,
    @location(4) previous_world_position: vec4<f32>,
#endif // MOTION_VECTOR_PREPASS

#ifdef DEPTH_CLAMP_ORTHO
    @location(5) clip_position_unclamped: vec4<f32>,
#endif // DEPTH_CLAMP_ORTHO
}

#ifdef MORPH_TARGETS
fn morph_vertex(vertex_in: Vertex) -> Vertex {
    var vertex = vertex_in;
    let weight_count = bevy_pbr::morph::layer_count();
    for (var i: u32 = 0u; i < weight_count; i ++) {
        let weight = bevy_pbr::morph::weight_at(i);
        if weight == 0.0 {
            continue;
        }
        vertex.position += weight * bevy_pbr::morph::morph(vertex.index, bevy_pbr::morph::position_offset, i);
#ifdef VERTEX_NORMALS
        vertex.normal += weight * bevy_pbr::morph::morph(vertex.index, bevy_pbr::morph::normal_offset, i);
#endif
#ifdef VERTEX_TANGENTS
        vertex.tangent += vec4(weight * bevy_pbr::morph::morph(vertex.index, bevy_pbr::morph::tangent_offset, i), 0.0);
#endif
    }
    return vertex;
}
#endif

@vertex
fn vertex(vertex_no_morph: Vertex) -> VertexOutput {
    var out: VertexOutput;

#ifdef MORPH_TARGETS
    var vertex = morph_vertex(vertex_no_morph);
#else
    var vertex = vertex_no_morph;
#endif

#ifdef SKINNED
    var model = bevy_pbr::skinning::skin_model(vertex.joint_indices, vertex.joint_weights);
#else // SKINNED
    // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
    // See https://github.com/gfx-rs/naga/issues/2416
    var model = bevy_pbr::mesh_functions::get_model_matrix(vertex_no_morph.instance_index);
#endif // SKINNED

    out.clip_position = bevy_pbr::mesh_functions::mesh_position_local_to_clip(model, vec4(vertex.position, 1.0));
#ifdef DEPTH_CLAMP_ORTHO
    out.clip_position_unclamped = out.clip_position;
    out.clip_position.z = min(out.clip_position.z, 1.0);
#endif // DEPTH_CLAMP_ORTHO

#ifdef VERTEX_UVS
    out.uv = vertex.uv;
#endif // VERTEX_UVS

#ifdef NORMAL_PREPASS
#ifdef SKINNED
    out.world_normal = bevy_pbr::skinning::skin_normals(model, vertex.normal);
#else // SKINNED
    out.world_normal = bevy_pbr::mesh_functions::mesh_normal_local_to_world(
        vertex.normal,
        // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
        // See https://github.com/gfx-rs/naga/issues/2416
        get_instance_index(vertex_no_morph.instance_index)
    );
#endif // SKINNED

#ifdef VERTEX_TANGENTS
    out.world_tangent = bevy_pbr::mesh_functions::mesh_tangent_local_to_world(
        model,
        vertex.tangent,
        // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
        // See https://github.com/gfx-rs/naga/issues/2416
        get_instance_index(vertex_no_morph.instance_index)
    );
#endif // VERTEX_TANGENTS
#endif // NORMAL_PREPASS

#ifdef MOTION_VECTOR_PREPASS
    out.world_position = bevy_pbr::mesh_functions::mesh_position_local_to_world(model, vec4<f32>(vertex.position, 1.0));
    // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
    // See https://github.com/gfx-rs/naga/issues/2416
    out.previous_world_position = bevy_pbr::mesh_functions::mesh_position_local_to_world(
        bevy_pbr::mesh_functions::get_previous_model_matrix(vertex_no_morph.instance_index),
        vec4<f32>(vertex.position, 1.0)
    );
#endif // MOTION_VECTOR_PREPASS

    return out;
}

#ifdef PREPASS_FRAGMENT
struct FragmentInput {
#ifdef VERTEX_UVS
    @location(0) uv: vec2<f32>,
#endif // VERTEX_UVS

#ifdef NORMAL_PREPASS
    @location(1) world_normal: vec3<f32>,
#endif // NORMAL_PREPASS

#ifdef MOTION_VECTOR_PREPASS
    @location(3) world_position: vec4<f32>,
    @location(4) previous_world_position: vec4<f32>,
#endif // MOTION_VECTOR_PREPASS

#ifdef DEPTH_CLAMP_ORTHO
    @location(5) clip_position_unclamped: vec4<f32>,
#endif // DEPTH_CLAMP_ORTHO
}

struct FragmentOutput {
#ifdef NORMAL_PREPASS
    @location(0) normal: vec4<f32>,
#endif // NORMAL_PREPASS

#ifdef MOTION_VECTOR_PREPASS
    @location(1) motion_vector: vec2<f32>,
#endif // MOTION_VECTOR_PREPASS

#ifdef DEPTH_CLAMP_ORTHO
    @builtin(frag_depth) frag_depth: f32,
#endif // DEPTH_CLAMP_ORTHO
}

@fragment
fn fragment(in: FragmentInput) -> FragmentOutput {
    var out: FragmentOutput;

#ifdef NORMAL_PREPASS
    out.normal = vec4(in.world_normal * 0.5 + vec3(0.5), 1.0);
#endif

#ifdef DEPTH_CLAMP_ORTHO
    out.frag_depth = in.clip_position_unclamped.z;
#endif // DEPTH_CLAMP_ORTHO

#ifdef MOTION_VECTOR_PREPASS
    let clip_position_t = bevy_pbr::prepass_bindings::view.unjittered_view_proj * in.world_position;
    let clip_position = clip_position_t.xy / clip_position_t.w;
    let previous_clip_position_t = bevy_pbr::prepass_bindings::previous_view_proj * in.previous_world_position;
    let previous_clip_position = previous_clip_position_t.xy / previous_clip_position_t.w;
    // These motion vectors are used as offsets to UV positions and are stored
    // in the range -1,1 to allow offsetting from the one corner to the
    // diagonally-opposite corner in UV coordinates, in either direction.
    // A difference between diagonally-opposite corners of clip space is in the
    // range -2,2, so this needs to be scaled by 0.5. And the V direction goes
    // down where clip space y goes up, so y needs to be flipped.
    out.motion_vector = (clip_position - previous_clip_position) * vec2(0.5, -0.5);
#endif // MOTION_VECTOR_PREPASS

    return out;
}
#endif // PREPASS_FRAGMENT
#define_import_path bevy_pbr::prepass_bindings
#import bevy_render::view View
#import bevy_render::globals Globals
#import bevy_pbr::mesh_types

@group(0) @binding(0) var<uniform> view: View;
@group(0) @binding(1) var<uniform> globals: Globals;

#ifdef MOTION_VECTOR_PREPASS
@group(0) @binding(2) var<uniform> previous_view_proj: mat4x4<f32>;
#endif // MOTION_VECTOR_PREPASS

// Material bindings will be in @group(1)
#import bevy_pbr::mesh_bindings   mesh
#import bevy_core_pipeline::fullscreen_vertex_shader  FullscreenVertexOutput

@group(0) @binding(0) var in_texture: texture_2d<f32>;
@group(0) @binding(1) var in_sampler: sampler;

@fragment
fn fs_main(in: FullscreenVertexOutput) -> @location(0) vec4<f32> {
    return texture_sample(in_texture, in_sampler, in.uv);
}
// Copyright (c) 2022 Advanced Micro Devices, Inc. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import bevy_core_pipeline::fullscreen_vertex_shader FullscreenVertexOutput

struct CASUniforms {
    sharpness: f32,
};

@group(0) @binding(0) var screen_texture: texture_2d<f32>;
@group(0) @binding(1) var samp: sampler;
@group(0) @binding(2) var<uniform> uniforms: CASUniforms;

// This is set at the limit of providing unnatural results for sharpening.
const FSR_RCAS_LIMIT = 0.1875;
// -4.0 instead of -1.0 to avoid issues with MSAA.
const peak_c = vec2<f32>(10.0, -40.0);

// Robust Contrast Adaptive Sharpening (RCAS)
// Based on the following implementation:
// https://github.com/GPUOpen-Effects/FidelityFX-FSR2/blob/ea97a113b0f9cadf519fbcff315cc539915a3acd/src/ffx-fsr2-api/shaders/ffx_fsr1.h#L672
// RCAS is based on the following logic.
// RCAS uses a 5 tap filter in a cross pattern (same as CAS),
//    W                b
//  W 1 W  for taps  d e f 
//    W                h
// Where 'W' is the negative lobe weight.
//  output = (W*(b+d+f+h)+e)/(4*W+1)
// RCAS solves for 'W' by seeing where the signal might clip out of the {0 to 1} input range,
//  0 == (W*(b+d+f+h)+e)/(4*W+1) -> W = -e/(b+d+f+h)
//  1 == (W*(b+d+f+h)+e)/(4*W+1) -> W = (1-e)/(b+d+f+h-4)
// Then chooses the 'W' which results in no clipping, limits 'W', and multiplies by the 'sharp' amount.
// This solution above has issues with MSAA input as the steps along the gradient cause edge detection issues.
// So RCAS uses 4x the maximum and 4x the minimum (depending on equation)in place of the individual taps.
// As well as switching from 'e' to either the minimum or maximum (depending on side), to help in energy conservation.
// This stabilizes RCAS.
// RCAS does a simple highpass which is normalized against the local contrast then shaped,
//       0.25
//  0.25  -1  0.25
//       0.25
// This is used as a noise detection filter, to reduce the effect of RCAS on grain, and focus on real edges.
// The CAS node runs after tonemapping, so the input will be in the range of 0 to 1.
@fragment
fn fragment(in: FullscreenVertexOutput) -> @location(0) vec4<f32> {
    // Algorithm uses minimal 3x3 pixel neighborhood.
    //    b
    //  d e f
    //    h
    let b = texture_sample(screen_texture, samp, in.uv, vec2<i32>(0, -1)).rgb;
    let d = texture_sample(screen_texture, samp, in.uv, vec2<i32>(-1, 0)).rgb;
    // We need the alpha value of the pixel we're working on for the output
    let e = texture_sample(screen_texture, samp, in.uv).rgbw;
    let f = texture_sample(screen_texture, samp, in.uv, vec2<i32>(1, 0)).rgb;
    let h = texture_sample(screen_texture, samp, in.uv, vec2<i32>(0, 1)).rgb;
    // Min and max of ring.
    let mn4 = min(min(b, d), min(f, h));
    let mx4 = max(max(b, d), max(f, h));
    // Limiters
    // 4.0 to avoid issues with MSAA.
    let hit_min = mn4 / (4.0 * mx4);
    let hit_max = (peak_c.x - mx4) / (peak_c.y + 4.0 * mn4);
    let lobe_rgb = max(-hit_min, hit_max);
    var lobe = max(-FSR_RCAS_LIMIT, min(0.0, max(lobe_rgb.r, max(lobe_rgb.g, lobe_rgb.b)))) * uniforms.sharpness;
#ifdef RCAS_DENOISE
    // Luma times 2.
    let b_l = b.b * 0.5 + (b.r * 0.5 + b.g);
    let d_l = d.b * 0.5 + (d.r * 0.5 + d.g);
    let e_l = e.b * 0.5 + (e.r * 0.5 + e.g);
    let f_l = f.b * 0.5 + (f.r * 0.5 + f.g);
    let h_l = h.b * 0.5 + (h.r * 0.5 + h.g);
    // Noise detection.
    var noise = 0.25 * b_l + 0.25 * d_l + 0.25 * f_l + 0.25 * h_l - e_l;;
    noise = saturate(abs(noise) / (max(max(b_l, d_l), max(f_l, h_l)) - min(min(b_l, d_l), min(f_l, h_l))));
    noise = 1.0 - 0.5 * noise;
    // Apply noise removal.
    lobe *= noise;
#endif
    return vec4<f32>((lobe * b + lobe * d + lobe * f + lobe * h + e.rgb) / (4.0 * lobe + 1.0), e.w);
}
#import bevy_render::view View

@group(0) @binding(0) var skybox: texture_cube<f32>;
@group(0) @binding(1) var skybox_sampler: sampler;
@group(0) @binding(2) var<uniform> view: View;

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) world_position: vec3<f32>,
};

//  3 |  2.
//  2 |  :  `.
//  1 |  x-----x.
//  0 |  |  s  |  `.
// -1 |  0-----x.....1
//    +---------------
//      -1  0  1  2  3
//
// The axes are clip-space x and y. The region marked s is the visible region.
// The digits in the corners of the right-angled triangle are the vertex
// indices.
@vertex
fn skybox_vertex(@builtin(vertex_index) vertex_index: u32) -> VertexOutput {
    // See the explanation above for how this works.
    let clip_position = vec4(
        f32(vertex_index & 1u),
        f32((vertex_index >> 1u) & 1u),
        0.25,
        0.5
    ) * 4.0 - vec4(1.0);
    // Use the position on the near clipping plane to avoid -inf world position
    // because the far plane of an infinite reverse projection is at infinity.
    // NOTE: The clip position has a w component equal to 1.0 so we don't need
    // to apply a perspective divide to it before inverse-projecting it.
    let world_position_homogeneous = view.inverse_view_proj * vec4(clip_position.xy, 1.0, 1.0);
    let world_position = world_position_homogeneous.xyz / world_position_homogeneous.w;

    return VertexOutput(clip_position, world_position);
}

@fragment
fn skybox_fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    // The skybox cubemap is sampled along the direction from the camera world
    // position, to the fragment world position on the near clipping plane
    let ray_direction = in.world_position - view.world_position;
    // cube maps are left-handed so we negate the z coordinate
    return texture_sample(skybox, skybox_sampler, ray_direction * vec3(1.0, 1.0, -1.0));
}
// Bloom works by creating an intermediate texture with a bunch of mip levels, each half the size of the previous.
// You then downsample each mip (starting with the original texture) to the lower resolution mip under it, going in order.
// You then upsample each mip (starting from the smallest mip) and blend with the higher resolution mip above it (ending on the original texture).
//
// References:
// * [COD] - Next Generation Post Processing in Call of Duty - http://www.iryoku.com/next-generation-post-processing-in-call-of-duty-advanced-warfare
// * [PBB] - Physically Based Bloom - https://learnopengl.com/Guest-Articles/2022/Phys.-Based-Bloom

#import bevy_core_pipeline::fullscreen_vertex_shader

struct BloomUniforms {
    threshold_precomputations: vec4<f32>,
    viewport: vec4<f32>,
    aspect: f32,
};

@group(0) @binding(0) var input_texture: texture_2d<f32>;
@group(0) @binding(1) var s: sampler;

@group(0) @binding(2) var<uniform> uniforms: BloomUniforms;

#ifdef FIRST_DOWNSAMPLE
// https://catlikecoding.com/unity/tutorials/advanced-rendering/bloom/#3.4
fn soft_threshold(color: vec3<f32>) -> vec3<f32> {
    let brightness = max(color.r, max(color.g, color.b));
    var softness = brightness - uniforms.threshold_precomputations.y;
    softness = clamp(softness, 0.0, uniforms.threshold_precomputations.z);
    softness = softness * softness * uniforms.threshold_precomputations.w;
    var contribution = max(brightness - uniforms.threshold_precomputations.x, softness);
    contribution /= max(brightness, 0.00001); // Prevent division by 0
    return color * contribution;
}
#endif

// luminance coefficients from Rec. 709.
// https://en.wikipedia.org/wiki/Rec._709
fn tonemapping_luminance(v: vec3<f32>) -> f32 {
    return dot(v, vec3<f32>(0.2126, 0.7152, 0.0722));
}

fn rgb_to_srgb_simple(color: vec3<f32>) -> vec3<f32> {
    return pow(color, vec3<f32>(1.0 / 2.2));
}

// http://graphicrants.blogspot.com/2013/12/tone-mapping.html
fn karis_average(color: vec3<f32>) -> f32 {
    // Luminance calculated by gamma-correcting linear RGB to non-linear sRGB using pow(color, 1.0 / 2.2)
    // and then calculating luminance based on Rec. 709 color primaries.
    let luma = tonemapping_luminance(rgb_to_srgb_simple(color)) / 4.0;
    return 1.0 / (1.0 + luma);
}

// [COD] slide 153
fn sample_input_13_tap(uv: vec2<f32>) -> vec3<f32> {
    let a = texture_sample(input_texture, s, uv, vec2<i32>(-2, 2)).rgb;
    let b = texture_sample(input_texture, s, uv, vec2<i32>(0, 2)).rgb;
    let c = texture_sample(input_texture, s, uv, vec2<i32>(2, 2)).rgb;
    let d = texture_sample(input_texture, s, uv, vec2<i32>(-2, 0)).rgb;
    let e = texture_sample(input_texture, s, uv).rgb;
    let f = texture_sample(input_texture, s, uv, vec2<i32>(2, 0)).rgb;
    let g = texture_sample(input_texture, s, uv, vec2<i32>(-2, -2)).rgb;
    let h = texture_sample(input_texture, s, uv, vec2<i32>(0, -2)).rgb;
    let i = texture_sample(input_texture, s, uv, vec2<i32>(2, -2)).rgb;
    let j = texture_sample(input_texture, s, uv, vec2<i32>(-1, 1)).rgb;
    let k = texture_sample(input_texture, s, uv, vec2<i32>(1, 1)).rgb;
    let l = texture_sample(input_texture, s, uv, vec2<i32>(-1, -1)).rgb;
    let m = texture_sample(input_texture, s, uv, vec2<i32>(1, -1)).rgb;

#ifdef FIRST_DOWNSAMPLE
    // [COD] slide 168
    //
    // The first downsample pass reads from the rendered frame which may exhibit
    // 'fireflies' (individual very bright pixels) that should not cause the bloom effect.
    //
    // The first downsample uses a firefly-reduction method proposed by Brian Karis
    // which takes a weighted-average of the samples to limit their luma range to [0, 1].
    // This implementation matches the LearnOpenGL article [PBB].
    var group0 = (a + b + d + e) * (0.125f / 4.0f);
    var group1 = (b + c + e + f) * (0.125f / 4.0f);
    var group2 = (d + e + g + h) * (0.125f / 4.0f);
    var group3 = (e + f + h + i) * (0.125f / 4.0f);
    var group4 = (j + k + l + m) * (0.5f / 4.0f);
    group0 *= karis_average(group0);
    group1 *= karis_average(group1);
    group2 *= karis_average(group2);
    group3 *= karis_average(group3);
    group4 *= karis_average(group4);
    return group0 + group1 + group2 + group3 + group4;
#else
    var sample = (a + c + g + i) * 0.03125;
    sample += (b + d + f + h) * 0.0625;
    sample += (e + j + k + l + m) * 0.125;
    return sample;
#endif
}

// [COD] slide 162
fn sample_input_3x3_tent(uv: vec2<f32>) -> vec3<f32> {
    // Radius. Empirically chosen by and tweaked from the LearnOpenGL article.
    let x = 0.004 / uniforms.aspect;
    let y = 0.004;

    let a = texture_sample(input_texture, s, vec2<f32>(uv.x - x, uv.y + y)).rgb;
    let b = texture_sample(input_texture, s, vec2<f32>(uv.x, uv.y + y)).rgb;
    let c = texture_sample(input_texture, s, vec2<f32>(uv.x + x, uv.y + y)).rgb;

    let d = texture_sample(input_texture, s, vec2<f32>(uv.x - x, uv.y)).rgb;
    let e = texture_sample(input_texture, s, vec2<f32>(uv.x, uv.y)).rgb;
    let f = texture_sample(input_texture, s, vec2<f32>(uv.x + x, uv.y)).rgb;

    let g = texture_sample(input_texture, s, vec2<f32>(uv.x - x, uv.y - y)).rgb;
    let h = texture_sample(input_texture, s, vec2<f32>(uv.x, uv.y - y)).rgb;
    let i = texture_sample(input_texture, s, vec2<f32>(uv.x + x, uv.y - y)).rgb;

    var sample = e * 0.25;
    sample += (b + d + f + h) * 0.125;
    sample += (a + c + g + i) * 0.0625;

    return sample;
}

#ifdef FIRST_DOWNSAMPLE
@fragment
fn downsample_first(@location(0) output_uv: vec2<f32>) -> @location(0) vec4<f32> {
    let sample_uv = uniforms.viewport.xy + output_uv * uniforms.viewport.zw;
    var sample = sample_input_13_tap(sample_uv);
    // Lower bound of 0.0001 is to avoid propagating multiplying by 0.0 through the
    // downscaling and upscaling which would result in black boxes.
    // The upper bound is to prevent NaNs.
    // with f32::MAX (E+38) Chrome fails with ":value 340282346999999984391321947108527833088.0 cannot be represented as 'f32'"
    sample = clamp(sample, vec3<f32>(0.0001), vec3<f32>(3.40282347E+37));

#ifdef USE_THRESHOLD
    sample = soft_threshold(sample);
#endif

    return vec4<f32>(sample, 1.0);
}
#endif

@fragment
fn downsample(@location(0) uv: vec2<f32>) -> @location(0) vec4<f32> {
    return vec4<f32>(sample_input_13_tap(uv), 1.0);
}

@fragment
fn upsample(@location(0) uv: vec2<f32>) -> @location(0) vec4<f32> {
    return vec4<f32>(sample_input_3x3_tent(uv), 1.0);
}
// NVIDIA FXAA 3.11
// Original source code by TIMOTHY LOTTES
// https://gist.github.com/kosua20/0c506b81b3812ac900048059d2383126
//
// Cleaned version - https://github.com/kosua20/Rendu/blob/master/resources/common/shaders/screens/fxaa.frag
//
// Tweaks by mrDIMAS - https://github.com/FyroxEngine/Fyrox/blob/master/src/renderer/shaders/fxaa_fs.glsl

#import bevy_core_pipeline::fullscreen_vertex_shader  FullscreenVertexOutput

@group(0) @binding(0) var screen_texture: texture_2d<f32>;
@group(0) @binding(1) var samp: sampler;

// Trims the algorithm from processing darks.
#ifdef EDGE_THRESH_MIN_LOW
    const EDGE_THRESHOLD_MIN: f32 = 0.0833;
#endif

#ifdef EDGE_THRESH_MIN_MEDIUM
    const EDGE_THRESHOLD_MIN: f32 = 0.0625;
#endif

#ifdef EDGE_THRESH_MIN_HIGH
    const EDGE_THRESHOLD_MIN: f32 = 0.0312;
#endif

#ifdef EDGE_THRESH_MIN_ULTRA
    const EDGE_THRESHOLD_MIN: f32 = 0.0156;
#endif

#ifdef EDGE_THRESH_MIN_EXTREME
    const EDGE_THRESHOLD_MIN: f32 = 0.0078;
#endif

// The minimum amount of local contrast required to apply algorithm.
#ifdef EDGE_THRESH_LOW
    const EDGE_THRESHOLD_MAX: f32 = 0.250;
#endif

#ifdef EDGE_THRESH_MEDIUM
    const EDGE_THRESHOLD_MAX: f32 = 0.166;
#endif

#ifdef EDGE_THRESH_HIGH
    const EDGE_THRESHOLD_MAX: f32 = 0.125;
#endif

#ifdef EDGE_THRESH_ULTRA
    const EDGE_THRESHOLD_MAX: f32 = 0.063;
#endif

#ifdef EDGE_THRESH_EXTREME
    const EDGE_THRESHOLD_MAX: f32 = 0.031;
#endif

const ITERATIONS: i32 = 12; //default is 12
const SUBPIXEL_QUALITY: f32 = 0.75;
// #define QUALITY(q) ((q) < 5 ? 1.0 : ((q) > 5 ? ((q) < 10 ? 2.0 : ((q) < 11 ? 4.0 : 8.0)) : 1.5))
fn QUALITY(q: i32) -> f32 {
    switch (q) {
        //case 0, 1, 2, 3, 4: { return 1.0; }
        default:              { return 1.0; }
        case 5:               { return 1.5; }
        case 6, 7, 8, 9:      { return 2.0; }
        case 10:              { return 4.0; }
        case 11:              { return 8.0; }
    }
}

fn rgb2luma(rgb: vec3<f32>) -> f32 {
    return sqrt(dot(rgb, vec3<f32>(0.299, 0.587, 0.114)));
}

// Performs FXAA post-process anti-aliasing as described in the Nvidia FXAA white paper and the associated shader code.
@fragment
fn fragment(in: FullscreenVertexOutput) -> @location(0) vec4<f32> {
    let resolution = vec2<f32>(texture_dimensions(screen_texture));
    let inverse_screen_size = 1.0 / resolution.xy;
    let tex_coord = in.position.xy * inverse_screen_size;

    let center_sample = texture_sample_level(screen_texture, samp, tex_coord, 0.0);
    let color_center = center_sample.rgb;

    // Luma at the current fragment
    let luma_center = rgb2luma(color_center);

    // Luma at the four direct neighbors of the current fragment.
    let luma_down = rgb2luma(texture_sample_level(screen_texture, samp, tex_coord, 0.0, vec2<i32>(0, -1)).rgb);
    let luma_up = rgb2luma(texture_sample_level(screen_texture, samp, tex_coord, 0.0, vec2<i32>(0, 1)).rgb);
    let luma_left = rgb2luma(texture_sample_level(screen_texture, samp, tex_coord, 0.0, vec2<i32>(-1, 0)).rgb);
    let luma_right = rgb2luma(texture_sample_level(screen_texture, samp, tex_coord, 0.0, vec2<i32>(1, 0)).rgb);

    // Find the maximum and minimum luma around the current fragment.
    let luma_min = min(luma_center, min(min(luma_down, luma_up), min(luma_left, luma_right)));
    let luma_max = max(luma_center, max(max(luma_down, luma_up), max(luma_left, luma_right)));

    // Compute the delta.
    let luma_range = luma_max - luma_min;

    // If the luma variation is lower that a threshold (or if we are in a really dark area), we are not on an edge, don't perform any AA.
    if (luma_range < max(EDGE_THRESHOLD_MIN, luma_max * EDGE_THRESHOLD_MAX)) {
        return center_sample;
    }

    // Query the 4 remaining corners lumas.
    let luma_down_left  = rgb2luma(texture_sample_level(screen_texture, samp, tex_coord, 0.0, vec2<i32>(-1, -1)).rgb);
    let luma_up_right   = rgb2luma(texture_sample_level(screen_texture, samp, tex_coord, 0.0, vec2<i32>(1, 1)).rgb);
    let luma_up_left    = rgb2luma(texture_sample_level(screen_texture, samp, tex_coord, 0.0, vec2<i32>(-1, 1)).rgb);
    let luma_down_right = rgb2luma(texture_sample_level(screen_texture, samp, tex_coord, 0.0, vec2<i32>(1, -1)).rgb);

    // Combine the four edges lumas (using intermediary variables for future computations with the same values).
    let luma_down_up = luma_down + luma_up;
    let luma_leftRight = luma_left + luma_right;

    // Same for corners
    let luma_left_corners = luma_down_left + luma_up_left;
    let luma_down_corners = luma_down_left + luma_down_right;
    let luma_right_corners = luma_down_right + luma_up_right;
    let luma_up_corners = luma_up_right + luma_up_left;

    // Compute an estimation of the gradient along the horizontal and vertical axis.
    let edge_horizontal = abs(-2.0 * luma_left   + luma_left_corners)  + 
                         abs(-2.0 * luma_center + luma_down_up) * 2.0 + 
                         abs(-2.0 * luma_right  + luma_rightCorners);

    let edge_vertical =   abs(-2.0 * luma_up     + luma_up_corners)       + 
                         abs(-2.0 * luma_center + luma_left_right) * 2.0 + 
                         abs(-2.0 * luma_down   + luma_downCorners);

    // Is the local edge horizontal or vertical ?
    let is_horizontal = (edge_horizontal >= edge_vertical);

    // Choose the step size (one pixel) accordingly.
    var step_length = select(inverse_screen_size.x, inverse_screen_size.y, is_horizontal);

    // Select the two neighboring texels lumas in the opposite direction to the local edge.
    var luma1 = select(luma_left, luma_down, is_horizontal);
    var luma2 = select(luma_right, luma_up, is_horizontal);

    // Compute gradients in this direction.
    let gradient1 = luma1 - luma_center;
    let gradient2 = luma2 - luma_center;

    // Which direction is the steepest ?
    let is1Steepest = abs(gradient1) >= abs(gradient2);

    // Gradient in the corresponding direction, normalized.
    let gradient_scaled = 0.25 * max(abs(gradient1), abs(gradient2));

    // Average luma in the correct direction.
    var luma_local_average = 0.0;
    if (is1Steepest) {
        // Switch the direction
        step_length = -step_length;
        luma_local_average = 0.5 * (luma1 + luma_center);
    } else {
        luma_local_average = 0.5 * (luma2 + luma_center);
    }

    // Shift UV in the correct direction by half a pixel.
    // Compute offset (for each iteration step) in the right direction.
    var current_uv = tex_coord;
    var offset = vec2<f32>(0.0, 0.0);
    if (is_horizontal) {
        current_uv.y = current_uv.y + step_length * 0.5;
        offset.x = inverse_screen_size.x;
    } else {
        current_uv.x = current_uv.x + step_length * 0.5;
        offset.y = inverse_screen_size.y;
    }

    // Compute UVs to explore on each side of the edge, orthogonally. The QUALITY allows us to step faster.
    var uv1 = current_uv - offset; // * QUALITY(0); // (quality 0 is 1.0)
    var uv2 = current_uv + offset; // * QUALITY(0); // (quality 0 is 1.0)

    // Read the lumas at both current extremities of the exploration segment, and compute the delta wrt to the local average luma.
    var luma_end1 = rgb2luma(texture_sample_level(screen_texture, samp, uv1, 0.0).rgb);
    var luma_end2 = rgb2luma(texture_sample_level(screen_texture, samp, uv2, 0.0).rgb);
    luma_end1 = luma_end1 - luma_local_average;
    luma_end2 = luma_end2 - luma_local_average;

    // If the luma deltas at the current extremities is larger than the local gradient, we have reached the side of the edge.
    var reached1 = abs(luma_end1) >= gradient_scaled;
    var reached2 = abs(luma_end2) >= gradient_scaled;
    var reached_both = reached1 && reached2;

    // If the side is not reached, we continue to explore in this direction.
    uv1 = select(uv1 - offset, uv1, reached1); // * QUALITY(1); // (quality 1 is 1.0)
    uv2 = select(uv2 - offset, uv2, reached2); // * QUALITY(1); // (quality 1 is 1.0)

    // If both sides have not been reached, continue to explore.
    if (!reached_both) {
        for (var i: i32 = 2; i < ITERATIONS; i = i + 1) {
            // If needed, read luma in 1st direction, compute delta.
            if (!reached1) { 
                luma_end1 = rgb2luma(texture_sample_level(screen_texture, samp, uv1, 0.0).rgb);
                luma_end1 = luma_end1 - luma_local_average;
            }
            // If needed, read luma in opposite direction, compute delta.
            if (!reached2) { 
                luma_end2 = rgb2luma(texture_sample_level(screen_texture, samp, uv2, 0.0).rgb);
                luma_end2 = luma_end2 - luma_local_average;
            }
            // If the luma deltas at the current extremities is larger than the local gradient, we have reached the side of the edge.
            reached1 = abs(luma_end1) >= gradient_scaled;
            reached2 = abs(luma_end2) >= gradient_scaled;
            reached_both = reached1 && reached2;

            // If the side is not reached, we continue to explore in this direction, with a variable quality.
            if (!reached1) {
                uv1 = uv1 - offset * QUALITY(i);
            }
            if (!reached2) {
                uv2 = uv2 + offset * QUALITY(i);
            }

            // If both sides have been reached, stop the exploration.
            if (reached_both) { 
                break; 
            }
        }
    }

    // Compute the distances to each side edge of the edge (!).
    var distance1 = select(tex_coord.y - uv1.y, tex_coord.x - uv1.x, is_horizontal);
    var distance2 = select(uv2.y - tex_coord.y, uv2.x - tex_coord.x, is_horizontal);

    // In which direction is the side of the edge closer ?
    let is_direction1 = distance1 < distance2;
    let distance_final = min(distance1, distance2);

    // Thickness of the edge.
    let edge_thickness = (distance1 + distance2);

    // Is the luma at center smaller than the local average ?
    let is_luma_center_smaller = luma_center < luma_local_average;

    // If the luma at center is smaller than at its neighbor, the delta luma at each end should be positive (same variation).
    let correct_variation1 = (luma_end1 < 0.0) != is_luma_center_smaller;
    let correct_variation2 = (luma_end2 < 0.0) != is_luma_center_smaller;

    // Only keep the result in the direction of the closer side of the edge.
    var correct_variation = select(correct_variation2, correct_variation1, is_direction1);

    // UV offset: read in the direction of the closest side of the edge.
    let pixel_offset = - distance_final / edge_thickness + 0.5;

    // If the luma variation is incorrect, do not offset.
    var final_offset = select(0.0, pixel_offset, correct_variation);

    // Sub-pixel shifting
    // Full weighted average of the luma over the 3x3 neighborhood.
    let luma_average = (1.0 / 12.0) * (2.0 * (luma_down_up + luma_left_right) + luma_left_corners + luma_right_corners);
    // Ratio of the delta between the global average and the center luma, over the luma range in the 3x3 neighborhood.
    let sub_pixel_offset1 = clamp(abs(luma_average - luma_center) / luma_range, 0.0, 1.0);
    let sub_pixel_offset2 = (-2.0 * sub_pixel_offset1 + 3.0) * sub_pixel_offset1 * sub_pixel_offset1;
    // Compute a sub-pixel offset based on this delta.
    let sub_pixel_offset_final = sub_pixel_offset2 * sub_pixel_offset2 * SUBPIXEL_QUALITY;

    // Pick the biggest of the two offsets.
    final_offset = max(final_offset, sub_pixel_offset_final);

    // Compute the final UV coordinates.
    var final_uv = tex_coord;
    if (is_horizontal) {
        final_uv.y = final_uv.y + final_offset * step_length;
    } else {
        final_uv.x = final_uv.x + final_offset * step_length;
    }

    // Read the color at the new UV coordinates, and use it.
    var final_color = texture_sample_level(screen_texture, samp, final_uv, 0.0).rgb;
    return vec4<f32>(final_color, center_sample.a);
}
#define TONEMAPPING_PASS

#import bevy_core_pipeline::fullscreen_vertex_shader  FullscreenVertexOutput
#import bevy_render::view  View
#import bevy_core_pipeline::tonemapping  tone_mapping, powsafe, screen_space_dither

@group(0) @binding(0) var<uniform> view: View;

@group(0) @binding(1) var hdr_texture: texture_2d<f32>;
@group(0) @binding(2) var hdr_sampler: sampler;
@group(0) @binding(3) var dt_lut_texture: texture_3d<f32>;
@group(0) @binding(4) var dt_lut_sampler: sampler;

#import bevy_core_pipeline::tonemapping

@fragment
fn fragment(in: FullscreenVertexOutput) -> @location(0) vec4<f32> {
    let hdr_color = texture_sample(hdr_texture, hdr_sampler, in.uv);

    var output_rgb = tone_mapping(hdr_color, view.color_grading).rgb;

#ifdef DEBAND_DITHER
    output_rgb = powsafe(output_rgb.rgb, 1.0 / 2.2);
    output_rgb = output_rgb + bevy_core_pipeline::tonemapping::screen_space_dither(in.position.xy);
    // This conversion back to linear space is required because our output texture format is
    // SRGB; the GPU will assume our output is linear and will apply an SRGB conversion.
    output_rgb = powsafe(output_rgb.rgb, 2.2);
#endif

    return vec4<f32>(output_rgb, hdr_color.a);
}
#define_import_path bevy_core_pipeline::tonemapping

#import bevy_render::view View, ColorGrading

// hack !! not sure what to do with this
#ifdef TONEMAPPING_PASS
    @group(0) @binding(3) var dt_lut_texture: texture_3d<f32>;
    @group(0) @binding(4) var dt_lut_sampler: sampler;
#else
    @group(0) @binding(15) var dt_lut_texture: texture_3d<f32>;
    @group(0) @binding(16) var dt_lut_sampler: sampler;
#endif

fn sample_current_lut(p: vec3<f32>) -> vec3<f32> {
    // Don't include code that will try to sample from LUTs if tonemap method doesn't require it
    // Allows this file to be imported without necessarily needing the lut texture bindings
#ifdef TONEMAP_METHOD_AGX
    return texture_sample_level(dt_lut_texture, dt_lut_sampler, p, 0.0).rgb;
#else ifdef TONEMAP_METHOD_TONY_MC_MAPFACE
    return texture_sample_level(dt_lut_texture, dt_lut_sampler, p, 0.0).rgb;
#else ifdef TONEMAP_METHOD_BLENDER_FILMIC
    return texture_sample_level(dt_lut_texture, dt_lut_sampler, p, 0.0).rgb;
#else 
    return vec3(1.0, 0.0, 1.0);
 #endif
}

// --------------------------------------
// --- SomewhatBoringDisplayTransform ---
// --------------------------------------
// By Tomasz Stachowiak

fn rgb_to_ycbcr(col: vec3<f32>) -> vec3<f32> {
    let m = mat3x3<f32>(
        0.2126, 0.7152, 0.0722, 
        -0.1146, -0.3854, 0.5, 
        0.5, -0.4542, -0.0458
    );
    return col * m;
}

fn ycbcr_to_rgb(col: vec3<f32>) -> vec3<f32> {
    let m = mat3x3<f32>(
        1.0, 0.0, 1.5748, 
        1.0, -0.1873, -0.4681, 
        1.0, 1.8556, 0.0
    );
    return max(vec3(0.0), col * m);
}

fn tonemap_curve(v: f32) -> f32 {
#ifdef 0
    // Large linear part in the lows, but compresses highs.
    float c = v + v * v + 0.5 * v * v * v;
    return c / (1.0 + c);
#else
    return 1.0 - exp(-v);
#endif
}

fn tonemap_curve3_(v: vec3<f32>) -> vec3<f32> {
    return vec3(tonemap_curve(v.r), tonemap_curve(v.g), tonemap_curve(v.b));
}

fn somewhat_boring_display_transform(col: vec3<f32>) -> vec3<f32> {
    var boring_color = col;
    let ycbcr = rgb_to_ycbcr(boring_color);

    let bt = tonemap_curve(length(ycbcr.yz) * 2.4);
    var desat = max((bt - 0.7) * 0.8, 0.0);
    desat *= desat;

    let desat_col = mix(boring_color.rgb, ycbcr.xxx, desat);

    let tm_luma = tonemap_curve(ycbcr.x);
    let tm0 = boring_color.rgb * max(0.0, tm_luma / max(1e-5, tonemapping_luminance(boring_color.rgb)));
    let final_mult = 0.97;
    let tm1 = tonemap_curve3_(desat_col);

    boring_color = mix(tm0, tm1, bt * bt);

    return boring_color * final_mult;
}

// ------------------------------------------
// ------------- Tony McMapface -------------
// ------------------------------------------
// By Tomasz Stachowiak
// https://github.com/h3r2tic/tony-mc-mapface

const TONY_MC_MAPFACE_LUT_DIMS: f32 = 48.0;

fn sample_tony_mc_mapface_lut(stimulus: vec3<f32>) -> vec3<f32> {
    var uv = (stimulus / (stimulus + 1.0)) * (f32(TONY_MC_MAPFACE_LUT_DIMS - 1.0) / f32(TONY_MC_MAPFACE_LUT_DIMS)) + 0.5 / f32(TONY_MC_MAPFACE_LUT_DIMS);
    return sample_current_lut(saturate(uv)).rgb;
}

// ---------------------------------
// ---------- ACES Fitted ----------
// ---------------------------------

// Same base implementation that Godot 4.0 uses for Tonemap ACES.

// https://github.com/TheRealMJP/BakingLab/blob/master/BakingLab/ACES.hlsl

// The code in this file was originally written by Stephen Hill (@self_shadow), who deserves all
// credit for coming up with this fit and implementing it. Buy him a beer next time you see him. :)

fn RRTAndODTFit(v: vec3<f32>) -> vec3<f32> {
    let a = v * (v + 0.0245786) - 0.000090537;
    let b = v * (0.983729 * v + 0.4329510) + 0.238081;
    return a / b;
}

fn ACESFitted(color: vec3<f32>) -> vec3<f32> {    
    var fitted_color = color;

    // sRGB => XYZ => D65_2_D60 => AP1 => RRT_SAT
    let rgb_to_rrt = mat3x3<f32>(
        vec3(0.59719, 0.35458, 0.04823),
        vec3(0.07600, 0.90834, 0.01566),
        vec3(0.02840, 0.13383, 0.83777)    
    );

    // ODT_SAT => XYZ => D60_2_D65 => sRGB
    let odt_to_rgb = mat3x3<f32>(
        vec3(1.60475, -0.53108, -0.07367),
        vec3(-0.10208, 1.10813, -0.00605),
        vec3(-0.00327, -0.07276, 1.07602)
    );

    fitted_color *= rgb_to_rrt;

    // Apply RRT and ODT
    fitted_color = RRTAndODTFit(fitted_color);

    fitted_color *= odt_to_rgb;

    // Clamp to [0, 1]
    fitted_color = saturate(fitted_color);

    return fitted_color;
}

// -------------------------------
// ------------- AgX -------------
// -------------------------------
// By Troy Sobotka
// https://github.com/MrLixm/AgXc
// https://github.com/sobotka/AgX

// pow() but safe for NaNs/negatives
fn powsafe(color: vec3<f32>, power: f32) -> vec3<f32> {
    return pow(abs(color), vec3(power)) * sign(color);
}

/*
    Increase color saturation of the given color data.
    :param color: expected s_rgb primaries input
    :param saturation_amount: expected 0-1 range with 1=neutral, 0=no saturation.
    -- ref[2] [4]
*/
fn saturation(color: vec3<f32>, saturation_amount: f32) -> vec3<f32> {
    let luma = tonemapping_luminance(color);
    return mix(vec3(luma), color, vec3(saturation_amount));
}

/*
    Output log domain encoded data.
    Similar to OCIO lg2 AllocationTransform.
    ref[0]
*/
fn convertOpenDomainToNormalizedLog2_(color: vec3<f32>, minimum_ev: f32, maximum_ev: f32) -> vec3<f32> {
    let in_midgray = 0.18;

    // remove negative before log transform
    var normalized_color = max(vec3(0.0), color);
    // avoid infinite issue with log -- ref[1]
    normalized_color = select(normalized_color, 0.00001525878 + normalized_color, normalized_color  < vec3<f32>(0.00003051757));
    normalized_color = clamp(
        log2(normalized_color / in_midgray),
        vec3(minimum_ev),
        vec3(maximum_ev)
    );
    let total_exposure = maximum_ev - minimum_ev;

    return (normalized_color - minimum_ev) / total_exposure;
}

// Inverse of above
fn convert_normalized_log2_to_open_domain(color: vec3<f32>, minimum_ev: f32, maximum_ev: f32) -> vec3<f32> {
    var open_color = color;
    let in_midgray = 0.18;
    let total_exposure = maximum_ev - minimum_ev;

    open_color = (open_color * total_exposure) + minimum_ev;
    open_color = pow(vec3(2.0), open_color);
    open_color = open_color * in_midgray;

    return open_color;
}


/*=================
    Main processes
=================*/

// Prepare the data for display encoding. Converted to log domain.
fn apply_ag_x_log(Image: vec3<f32>) -> vec3<f32> {
    var prepared_image = max(vec3(0.0), Image); // clamp negatives
    let r = dot(prepared_image, vec3(0.84247906, 0.0784336, 0.07922375));
    let g = dot(prepared_image, vec3(0.04232824, 0.87846864, 0.07916613));
    let b = dot(prepared_image, vec3(0.04237565, 0.0784336, 0.87914297));
    prepared_image = vec3(r, g, b);

    prepared_image = convertOpenDomainToNormalizedLog2_(prepared_image, -10.0, 6.5);
    
    prepared_image = clamp(prepared_image, vec3(0.0), vec3(1.0));
    return prepared_image;
}

fn apply_lut3_d(Image: vec3<f32>, block_size: f32) -> vec3<f32> {
    return sample_current_lut(Image * ((block_size - 1.0) / block_size) + 0.5 / block_size).rgb;
}

// -------------------------
// -------------------------
// -------------------------

fn sample_blender_filmic_lut(stimulus: vec3<f32>) -> vec3<f32> {
    let block_size = 64.0;
    let normalized = saturate(convertOpenDomainToNormalizedLog2_(stimulus, -11.0, 12.0));
    return apply_lut3_d(normalized, block_size);
}

// from https://64.github.io/tonemapping/
// reinhard on RGB oversaturates colors
fn tonemapping_reinhard(color: vec3<f32>) -> vec3<f32> {
    return color / (1.0 + color);
}

fn tonemapping_reinhard_extended(color: vec3<f32>, max_white: f32) -> vec3<f32> {
    let numerator = color * (1.0 + (color / vec3<f32>(max_white * max_white)));
    return numerator / (1.0 + color);
}

// luminance coefficients from Rec. 709.
// https://en.wikipedia.org/wiki/Rec._709
fn tonemapping_luminance(v: vec3<f32>) -> f32 {
    return dot(v, vec3<f32>(0.2126, 0.7152, 0.0722));
}

fn tonemapping_change_luminance(c_in: vec3<f32>, l_out: f32) -> vec3<f32> {
    let l_in = tonemapping_luminance(c_in);
    return c_in * (l_out / l_in);
}

fn tonemapping_reinhard_luminance(color: vec3<f32>) -> vec3<f32> {
    let l_old = tonemapping_luminance(color);
    let l_new = l_old / (1.0 + l_old);
    return tonemapping_change_luminance(color, l_new);
}

fn rgb_to_srgb_simple(color: vec3<f32>) -> vec3<f32> {
    return pow(color, vec3<f32>(1.0 / 2.2));
}

// Source: Advanced VR Rendering, GDC 2015, Alex Vlachos, Valve, Slide 49
// https://media.steampowered.com/apps/valve/2015/Alex_Vlachos_Advanced_VR_Rendering_GDC2015.pdf
fn screen_space_dither(frag_coord: vec2<f32>) -> vec3<f32> {
    var dither = vec3<f32>(dot(vec2<f32>(171.0, 231.0), frag_coord)).xxx;
    dither = fract(dither.rgb / vec3<f32>(103.0, 71.0, 97.0));
    return (dither - 0.5) / 255.0;
}

fn tone_mapping(in: vec4<f32>, color_grading: ColorGrading) -> vec4<f32> {
    var color = max(in.rgb, vec3(0.0));

    // Possible future grading:

    // highlight gain gamma: 0..
    // let luma = powsafe(vec3(tonemapping_luminance(color)), 1.0); 

    // highlight gain: 0.. 
    // color += color * luma.xxx * 1.0; 

    // Linear pre tonemapping grading
    color = saturation(color, color_grading.pre_saturation);
    color = powsafe(color, color_grading.gamma);
    color = color * powsafe(vec3(2.0), color_grading.exposure);
    color = max(color, vec3(0.0));

    // tone_mapping
#ifdef TONEMAP_METHOD_NONE
    color = color;
#else ifdef TONEMAP_METHOD_REINHARD
    color = tonemapping_reinhard(color.rgb);
#else ifdef TONEMAP_METHOD_REINHARD_LUMINANCE
    color = tonemapping_reinhard_luminance(color.rgb);
#else ifdef TONEMAP_METHOD_ACES_FITTED
    color = ACESFitted(color.rgb);
#else ifdef TONEMAP_METHOD_AGX
    color = apply_ag_x_log(color);
    color = apply_lut3_d(color, 32.0);
#else ifdef TONEMAP_METHOD_SOMEWHAT_BORING_DISPLAY_TRANSFORM
    color = somewhat_boring_display_transform(color.rgb);
#else ifdef TONEMAP_METHOD_TONY_MC_MAPFACE
    color = sample_tony_mc_mapface_lut(color); 
#else ifdef TONEMAP_METHOD_BLENDER_FILMIC
    color = sample_blender_filmic_lut(color.rgb);
#endif

    // Perceptual post tonemapping grading
    color = saturation(color, color_grading.post_saturation);
    
    return vec4(color, in.a);
}

#define_import_path bevy_sprite::mesh2d_bindings

#import bevy_sprite::mesh2d_types

@group(2) @binding(0) var<uniform> mesh: bevy_sprite::mesh2d_types::Mesh2d;
#define_import_path bevy_sprite::mesh2d_view_bindings

#import bevy_render::view  View
#import bevy_render::globals  Globals

@group(0) @binding(0) var<uniform> view: View;

@group(0) @binding(1) var<uniform> globals: Globals;
#import bevy_sprite::mesh2d_types          Mesh2d
#import bevy_sprite::mesh2d_vertex_output  MeshVertexOutput
#import bevy_sprite::mesh2d_view_bindings  view

#ifdef TONEMAP_IN_SHADER
#import bevy_core_pipeline::tonemapping
#endif

struct ColorMaterial {
    color: vec4<f32>,
    // 'flags' is a bit field indicating various options. u32 is 32 bits so we have up to 32 options.
    flags: u32,
};
const COLOR_MATERIAL_FLAGS_TEXTURE_BIT: u32 = 1u;

@group(1) @binding(0) var<uniform> material: ColorMaterial;
@group(1) @binding(1) var texture: texture_2d<f32>;
@group(1) @binding(2) var texture_sampler: sampler;

@fragment
fn fragment(
    mesh: MeshVertexOutput,
) -> @location(0) vec4<f32> {
    var output_color: vec4<f32> = material.color;
#ifdef VERTEX_COLORS
    output_color = output_color * mesh.color;
#endif
    if ((material.flags & COLOR_MATERIAL_FLAGS_TEXTURE_BIT) != 0u) {
        output_color = output_color * texture_sample(texture, texture_sampler, mesh.uv);
    }
#ifdef TONEMAP_IN_SHADER
    output_color = bevy_core_pipeline::tonemapping::tone_mapping(output_color, view.color_grading);
#endif
    return output_color;
}
#ifdef TONEMAP_IN_SHADER
#import bevy_core_pipeline::tonemapping
#endif

#import bevy_render::maths affine_to_square
#import bevy_render::view  View

@group(0) @binding(0) var<uniform> view: View;

struct VertexInput {
    @builtin(vertex_index) index: u32,
    // NOTE: Instance-rate vertex buffer members prefixed with i_
    // NOTE: i_model_transpose_colN are the 3 columns of a 3x4 matrix that is the transpose of the
    // affine 4x3 model matrix.
    @location(0) i_model_transpose_col0: vec4<f32>,
    @location(1) i_model_transpose_col1: vec4<f32>,
    @location(2) i_model_transpose_col2: vec4<f32>,
    @location(3) i_color: vec4<f32>,
    @location(4) i_uv_offset_scale: vec4<f32>,
}

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) uv: vec2<f32>,
    @location(1) @interpolate(flat) color: vec4<f32>,
};

@vertex
fn vertex(in: VertexInput) -> VertexOutput {
    var out: VertexOutput;

    let vertex_position = vec3<f32>(
        f32(in.index & 0x1u),
        f32((in.index & 0x2u) >> 1u),
        0.0
    );

    out.clip_position = view.view_proj * affine_to_square(mat3x4<f32>(
        in.i_model_transpose_col0,
        in.i_model_transpose_col1,
        in.i_model_transpose_col2,
    )) * vec4<f32>(vertex_position, 1.0);
    out.uv = vec2<f32>(vertex_position.xy) * in.i_uv_offset_scale.zw + in.i_uv_offset_scale.xy;
    out.color = in.i_color;

    return out;
}

@group(1) @binding(0) var sprite_texture: texture_2d<f32>;
@group(1) @binding(1) var sprite_sampler: sampler;

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    var color = in.color * texture_sample(sprite_texture, sprite_sampler, in.uv);

#ifdef TONEMAP_IN_SHADER
    color = bevy_core_pipeline::tonemapping::tone_mapping(color, view.color_grading);
#endif

    return color;
}
// TODO use common view binding
#import bevy_render::view View

@group(0) @binding(0) var<uniform> view: View;


struct LineGizmoUniform {
    line_width: f32,
    depth_bias: f32,
#ifdef SIXTEEN_BYTE_ALIGNMENT
    // WebGL2 structs must be 16 byte aligned.
    _padding: vec2<f32>,
#endif
}

@group(1) @binding(0) var<uniform> line_gizmo: LineGizmoUniform;

struct VertexInput {
    @location(0) position_a: vec3<f32>,
    @location(1) position_b: vec3<f32>,
    @location(2) color_a: vec4<f32>,
    @location(3) color_b: vec4<f32>,
    @builtin(vertex_index) index: u32,
};

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) color: vec4<f32>,
};

@vertex
fn vertex(vertex: VertexInput) -> VertexOutput {
    var positions = array<vec3<f32>, 6>(
        vec3(0., -0.5, 0.),
        vec3(0., -0.5, 1.),
        vec3(0., 0.5, 1.),
        vec3(0., -0.5, 0.),
        vec3(0., 0.5, 1.),
        vec3(0., 0.5, 0.)
    );
    let position = positions[vertex.index];

    // algorithm based on https://wwwtyro.net/2019/11/18/instanced-lines.html
    var clip_a = view.view_proj * vec4(vertex.position_a, 1.);
    var clip_b = view.view_proj * vec4(vertex.position_b, 1.);

    // Manual near plane clipping to avoid errors when doing the perspective divide inside this shader.
    clip_a = clip_near_plane(clip_a, clip_b);
    clip_b = clip_near_plane(clip_b, clip_a);

    let clip = mix(clip_a, clip_b, position.z);

    let resolution = view.viewport.zw;
    let screen_a = resolution * (0.5 * clip_a.xy / clip_a.w + 0.5);
    let screen_b = resolution * (0.5 * clip_b.xy / clip_b.w + 0.5);

    let x_basis = normalize(screen_a - screen_b);
    let y_basis = vec2(-x_basis.y, x_basis.x);

    var color = mix(vertex.color_a, vertex.color_b, position.z);

    var line_width = line_gizmo.line_width;
    var alpha = 1.;

#ifdef PERSPECTIVE
    line_width /= clip.w;
#endif

    // Line thinness fade from https://acegikmo.com/shapes/docs/#anti-aliasing
    if line_width > 0.0 && line_width < 1. {
        color.a *= line_width;
        line_width = 1.;
    }

    let offset = line_width * (position.x * x_basis + position.y * y_basis);
    let screen = mix(screen_a, screen_b, position.z) + offset;

    var depth: f32;
    if line_gizmo.depth_bias >= 0. {
        depth = clip.z * (1. - line_gizmo.depth_bias);
    } else {
        let epsilon = 4.88e-04;
        // depth * (clip.w / depth)^-depth_bias. So that when -depth_bias is 1.0, this is equal to clip.w
        // and when equal to 0.0, it is exactly equal to depth.
        // the epsilon is here to prevent the depth from exceeding clip.w when -depth_bias = 1.0
        // clip.w represents the near plane in homogeneous clip space in bevy, having a depth
        // of this value means nothing can be in front of this
        // The reason this uses an exponential function is that it makes it much easier for the
        // user to chose a value that is convenient for them
        depth = clip.z * exp2(-line_gizmo.depth_bias * log2(clip.w / clip.z - epsilon));
    }

    var clip_position = vec4(clip.w * ((2. * screen) / resolution - 1.), depth, clip.w);

    return VertexOutput(clip_position, color);
}

fn clip_near_plane(a: vec4<f32>, b: vec4<f32>) -> vec4<f32> {
    // Move a if a is behind the near plane and b is in front. 
    if a.z > a.w && b.z <= b.w {
        // Interpolate a towards b until it's at the near plane.
        let distance_a = a.z - a.w;
        let distance_b = b.z - b.w;
        let t = distance_a / (distance_a - distance_b);
        return a + (b - a) * t;
    }
    return a;
}

struct FragmentInput {
    @location(0) color: vec4<f32>,
};

struct FragmentOutput {
    @location(0) color: vec4<f32>,
};

@fragment
fn fragment(in: FragmentInput) -> FragmentOutput {
    return FragmentOutput(in.color);
}
#import bevy_render::view  View

const TEXTURED_QUAD: u32 = 0u;

@group(0) @binding(0) var<uniform> view: View;

struct VertexOutput {
    @location(0) uv: vec2<f32>,
    @location(1) color: vec4<f32>,
    @location(3) @interpolate(flat) mode: u32,
    @builtin(position) position: vec4<f32>,
};

@vertex
fn vertex(
    @location(0) vertex_position: vec3<f32>,
    @location(1) vertex_uv: vec2<f32>,
    @location(2) vertex_color: vec4<f32>,
    @location(3) mode: u32,
) -> VertexOutput {
    var out: VertexOutput;
    out.uv = vertex_uv;
    out.position = view.view_proj * vec4<f32>(vertex_position, 1.0);
    out.color = vertex_color;
    out.mode = mode;
    return out;
}

@group(1) @binding(0) var sprite_texture: texture_2d<f32>;
@group(1) @binding(1) var sprite_sampler: sampler;

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    // textureSample can only be called in unform control flow, not inside an if branch.
    var color = texture_sample(sprite_texture, sprite_sampler, in.uv);
    if in.mode == TEXTURED_QUAD {
        color = in.color * color;
    } else {
        color = in.color;
    }
    return color;
}
#define_import_path bevy_render::maths

fn affine_to_square(affine: mat3x4<f32>) -> mat4x4<f32> {
    return transpose(mat4x4<f32>(
        affine[0],
        affine[1],
        affine[2],
        vec4<f32>(0.0, 0.0, 0.0, 1.0),
    ));
}

fn mat2x4_f32_to_mat3x3_unpack(
    a: mat2x4<f32>,
    b: f32,
) -> mat3x3<f32> {
    return mat3x3<f32>(
        a[0].xyz,
        vec3<f32>(a[0].w, a[1].xy),
        vec3<f32>(a[1].zw, b),
    );
}
#define_import_path bevy_render::instance_index

#ifdef BASE_INSTANCE_WORKAROUND
// naga and wgpu should polyfill WGSL instance_index functionality where it is
// not available in GLSL. Until that is done, we can work around it in bevy
// using a push constant which is converted to a uniform by naga and wgpu.
// https://github.com/gfx-rs/wgpu/issues/1573
var<push_constant> base_instance: i32;

fn get_instance_index(instance_index: u32) -> u32 {
    return u32(base_instance) + instance_index;
}
#else
fn get_instance_index(instance_index: u32) -> u32 {
    return instance_index;
}
#endif
