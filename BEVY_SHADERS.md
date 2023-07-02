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
