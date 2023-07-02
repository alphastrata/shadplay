As there's not really good docs on this, here's a bunch of notes on some shaders that have useful defs you can pull into your own, from bevy.

These are just copy-pastered from their declarations.

[Globals](https://github.com/bevyengine/bevy/blob/main/crates/bevy_render/src/globals.wgsl):

```rust
struct Globals {
    // The time since startup in seconds
    // Wraps to 0 after 1 hour.
    time: f32,
    // The delta time since the previous frame in seconds
    delta_time: f32,
    // Frame count since the start of the app.
    // It wraps to zero when it reaches the maximum value of a u32.
    frame_count: u32,
#ifdef SIXTEEN_BYTE_ALIGNMENT
    // WebGL2 structs must be 16 byte aligned.
    _webgl2_padding: f32
#endif
};
```

Example usage:

```rust
#import bevy_pbr::mesh_view_bindings globals

// The time since startup data is in the globals binding which is part of the mesh_view_bindings import
#import bevy_pbr::mesh_view_bindings globals
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_pbr::mesh_functions


@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {

    let t_1 = sin(globals.time * 2.); // You'll usually see things that count up monotonically clamped with a sin/tan/cos etc function.

    let green = vec3<f32>(0.86644, -0.233887, 0.179498);
    let blue = vec3<f32>(0.701674, 0.274566, -0.169156);
    let white = vec3<f32>(1.0, 0.0, 0.0);


    return vec4<f32>(mix(white, blue, green) * t_1, 1.0); // Mix, does what you think, you can put a vecN in and get a vecN out.
}

```

Stuff available from the [View]()

```rust
#define_import_path bevy_render::view

struct ColorGrading {
    exposure: f32,
    gamma: f32,
    pre_saturation: f32,
    post_saturation: f32,
}

struct View {
    view_proj: mat4x4<f32>,
    unjittered_view_proj: mat4x4<f32>,
    inverse_view_proj: mat4x4<f32>,
    view: mat4x4<f32>,
    inverse_view: mat4x4<f32>,
    projection: mat4x4<f32>,
    inverse_projection: mat4x4<f32>,
    world_position: vec3<f32>,
    // viewport(x_origin, y_origin, width, height)
    viewport: vec4<f32>,
    color_grading: ColorGrading,
    mip_bias: f32,
};
```

Which begs to wonder, earlier you used the [MeshVertexOutput](), so what's in that?:

```rust
struct MeshVertexOutput {
    // this is `clip position` when the struct is used as a vertex stage output
    // and `frag coord` when used as a fragment stage input
    @builtin(position) position: vec4<f32>,
    @location(0) world_position: vec4<f32>,
    @location(1) world_normal: vec3<f32>,
    #ifdef VERTEX_UVS // May or, may not be there depending on your Mesh.
    @location(2) uv: vec2<f32>,
    #endif
    #ifdef VERTEX_TANGENTS
    @location(3) world_tangent: vec4<f32>,
    #endif
    #ifdef VERTEX_COLORS
    @location(4) color: vec4<f32>,
    #endif
}
```

[mesh_types](https://github.com/bevyengine/bevy/blob/94291cf5699cc1b9e639c23d664d40abf5bb1560/crates/bevy_pbr/src/render/mesh_types.wgsl)

```rust
#define_import_path bevy_pbr::mesh_types

struct Mesh {
    model: mat4x4<f32>,
    previous_model: mat4x4<f32>,
    inverse_transpose_model: mat4x4<f32>,
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
```

Those meshes have the following functions available:

```rust
#define_import_path bevy_pbr::mesh_functions

#import bevy_pbr::mesh_view_bindings  view
#import bevy_pbr::mesh_bindings       mesh
#import bevy_pbr::mesh_types          MESH_FLAGS_SIGN_DETERMINANT_MODEL_3X3_BIT

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

fn mesh_normal_local_to_world(vertex_normal: vec3<f32>) -> vec3<f32> {
    // NOTE: The mikktspace method of normal mapping requires that the world normal is
    // re-normalized in the vertex shader to match the way mikktspace bakes vertex tangents
    // and normal maps so that the exact inverse process is applied when shading. Blender, Unity,
    // Unreal Engine, Godot, and more all use the mikktspace method. Do not change this code
    // unless you really know what you are doing.
    // http://www.mikktspace.com/
    return normalize(
        mat3x3<f32>(
            mesh.inverse_transpose_model[0].xyz,
            mesh.inverse_transpose_model[1].xyz,
            mesh.inverse_transpose_model[2].xyz
        ) * vertex_normal
    );
}

// Calculates the sign of the determinant of the 3x3 model matrix based on a
// mesh flag
fn sign_determinant_model_3x3m() -> f32 {
    // bool(u32) is false if 0u else true
    // f32(bool) is 1.0 if true else 0.0
    // * 2.0 - 1.0 remaps 0.0 or 1.0 to -1.0 or 1.0 respectively
    return f32(bool(mesh.flags & MESH_FLAGS_SIGN_DETERMINANT_MODEL_3X3_BIT)) * 2.0 - 1.0;
}

fn mesh_tangent_local_to_world(model: mat4x4<f32>, vertex_tangent: vec4<f32>) -> vec4<f32> {
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
        vertex_tangent.w * sign_determinant_model_3x3m()
    );
}
```

Stuff available in `utils.wgsl`

````rust
#define_import_path bevy_pbr::utils

const PI: f32 = 3.141592653589793;
const HALF_PI: f32 = 1.57079632679;
const E: f32 = 2.718281828459045;

fn hsv2rgb(hue: f32, saturation: f32, value: f32) -> vec3<f32> {
    let rgb = clamp(
        abs(
            ((hue * 6.0 + vec3<f32>(0.0, 4.0, 2.0)) % 6.0) - 3.0
        ) - 1.0,
        vec3<f32>(0.0),
        vec3<f32>(1.0)
    );

    return value * mix(vec3<f32>(1.0), rgb, vec3<f32>(saturation));
}

fn random1D(s: f32) -> f32 {
    return fract(sin(s * 12.9898) * 43758.5453123);
}

// returns the (0-1, 0-1) position within the given viewport for the current buffer coords .
// buffer coords can be obtained from `@builtin(position).xy`.
// the view uniform struct contains the current camera viewport in `view.viewport`.
// topleft = 0,0
fn coords_to_viewport_uv(position: vec2<f32>, viewport: vec4<f32>) -> vec2<f32> {
    return (position - viewport.xy) / viewport.zw;
}```

You'll notive the `bevy::render::StandardMaterial` rust `struct` mirrors this definition in wgsl-land
```rust
#define_import_path bevy_pbr::pbr_bindings

#import bevy_pbr::pbr_types  StandardMaterial

@group(1) @binding(0)
var<uniform> material: StandardMaterial;
@group(1) @binding(1)
var base_color_texture: texture_2d<f32>;
@group(1) @binding(2)
var base_color_sampler: sampler;
@group(1) @binding(3)
var emissive_texture: texture_2d<f32>;
@group(1) @binding(4)
var emissive_sampler: sampler;
@group(1) @binding(5)
var metallic_roughness_texture: texture_2d<f32>;
@group(1) @binding(6)
var metallic_roughness_sampler: sampler;
@group(1) @binding(7)
var occlusion_texture: texture_2d<f32>;
@group(1) @binding(8)
var occlusion_sampler: sampler;
@group(1) @binding(9)
var normal_map_texture: texture_2d<f32>;
@group(1) @binding(10)
var normal_map_sampler: sampler;
@group(1) @binding(11)
var depth_map_texture: texture_2d<f32>;
@group(1) @binding(12)
var depth_map_sampler: sampler;
````
