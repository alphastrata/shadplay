# All the BevyEngine Shaders

This document is really to give you an easy, one-stop-shop to reference all the Bevy Engine's shaders -- as they're not well documented.

## Table of Contents

- [crates/bevy_gizmos/src/lines](#crates/bevy_gizmos/src/lines)
- [crates/bevy_gizmos/src/line_joints](#crates/bevy_gizmos/src/line_joints)
- [crates/bevy_sprite/src/render/sprite](#crates/bevy_sprite/src/render/sprite)
- [crates/bevy_sprite/src/mesh2d/mesh2d_functions](#crates/bevy_sprite/src/mesh2d/mesh2d_functions)
- [crates/bevy_sprite/src/mesh2d/mesh2d](#crates/bevy_sprite/src/mesh2d/mesh2d)
- [crates/bevy_sprite/src/mesh2d/color_material](#crates/bevy_sprite/src/mesh2d/color_material)
- [crates/bevy_sprite/src/mesh2d/mesh2d_view_bindings](#crates/bevy_sprite/src/mesh2d/mesh2d_view_bindings)
- [crates/bevy_sprite/src/mesh2d/mesh2d_types](#crates/bevy_sprite/src/mesh2d/mesh2d_types)
- [crates/bevy_sprite/src/mesh2d/mesh2d_view_types](#crates/bevy_sprite/src/mesh2d/mesh2d_view_types)
- [crates/bevy_sprite/src/mesh2d/mesh2d_vertex_output](#crates/bevy_sprite/src/mesh2d/mesh2d_vertex_output)
- [crates/bevy_sprite/src/mesh2d/mesh2d_bindings](#crates/bevy_sprite/src/mesh2d/mesh2d_bindings)
- [crates/bevy_sprite/src/mesh2d/wireframe2d](#crates/bevy_sprite/src/mesh2d/wireframe2d)
- [crates/bevy_ui/src/render/ui](#crates/bevy_ui/src/render/ui)
- [crates/bevy_ui/src/render/ui_material](#crates/bevy_ui/src/render/ui_material)
- [crates/bevy_ui/src/render/ui_vertex_output](#crates/bevy_ui/src/render/ui_vertex_output)
- [crates/bevy_core_pipeline/src/bloom/bloom](#crates/bevy_core_pipeline/src/bloom/bloom)
- [crates/bevy_core_pipeline/src/fxaa/fxaa](#crates/bevy_core_pipeline/src/fxaa/fxaa)
- [crates/bevy_core_pipeline/src/skybox/skybox](#crates/bevy_core_pipeline/src/skybox/skybox)
- [crates/bevy_core_pipeline/src/taa/taa](#crates/bevy_core_pipeline/src/taa/taa)
- [crates/bevy_core_pipeline/src/tonemapping/tonemapping_shared](#crates/bevy_core_pipeline/src/tonemapping/tonemapping_shared)
- [crates/bevy_core_pipeline/src/tonemapping/tonemapping](#crates/bevy_core_pipeline/src/tonemapping/tonemapping)
- [crates/bevy_core_pipeline/src/fullscreen_vertex_shader/fullscreen](#crates/bevy_core_pipeline/src/fullscreen_vertex_shader/fullscreen)
- [crates/bevy_core_pipeline/src/contrast_adaptive_sharpening/robust_contrast_adaptive_sharpening](#crates/bevy_core_pipeline/src/contrast_adaptive_sharpening/robust_contrast_adaptive_sharpening)
- [crates/bevy_core_pipeline/src/deferred/copy_deferred_lighting_id](#crates/bevy_core_pipeline/src/deferred/copy_deferred_lighting_id)
- [crates/bevy_core_pipeline/src/blit/blit](#crates/bevy_core_pipeline/src/blit/blit)
- [crates/bevy_render/src/globals](#crates/bevy_render/src/globals)
- [crates/bevy_render/src/maths](#crates/bevy_render/src/maths)
- [crates/bevy_render/src/view/view](#crates/bevy_render/src/view/view)
- [crates/bevy_render/src/view/window/screenshot](#crates/bevy_render/src/view/window/screenshot)
- [crates/bevy_pbr/src/render/pbr_functions](#crates/bevy_pbr/src/render/pbr_functions)
- [crates/bevy_pbr/src/render/pbr](#crates/bevy_pbr/src/render/pbr)
- [crates/bevy_pbr/src/render/pbr_lighting](#crates/bevy_pbr/src/render/pbr_lighting)
- [crates/bevy_pbr/src/render/wireframe](#crates/bevy_pbr/src/render/wireframe)
- [crates/bevy_pbr/src/render/mesh_preprocess](#crates/bevy_pbr/src/render/mesh_preprocess)
- [crates/bevy_pbr/src/render/pbr_prepass](#crates/bevy_pbr/src/render/pbr_prepass)
- [crates/bevy_pbr/src/render/parallax_mapping](#crates/bevy_pbr/src/render/parallax_mapping)
- [crates/bevy_pbr/src/render/pbr_fragment](#crates/bevy_pbr/src/render/pbr_fragment)
- [crates/bevy_pbr/src/render/utils](#crates/bevy_pbr/src/render/utils)
- [crates/bevy_pbr/src/render/mesh_types](#crates/bevy_pbr/src/render/mesh_types)
- [crates/bevy_pbr/src/render/shadows](#crates/bevy_pbr/src/render/shadows)
- [crates/bevy_pbr/src/render/fog](#crates/bevy_pbr/src/render/fog)
- [crates/bevy_pbr/src/render/pbr_bindings](#crates/bevy_pbr/src/render/pbr_bindings)
- [crates/bevy_pbr/src/render/pbr_types](#crates/bevy_pbr/src/render/pbr_types)
- [crates/bevy_pbr/src/render/mesh](#crates/bevy_pbr/src/render/mesh)
- [crates/bevy_pbr/src/render/pbr_ambient](#crates/bevy_pbr/src/render/pbr_ambient)
- [crates/bevy_pbr/src/render/mesh_bindings](#crates/bevy_pbr/src/render/mesh_bindings)
- [crates/bevy_pbr/src/render/pbr_prepass_functions](#crates/bevy_pbr/src/render/pbr_prepass_functions)
- [crates/bevy_pbr/src/render/shadow_sampling](#crates/bevy_pbr/src/render/shadow_sampling)
- [crates/bevy_pbr/src/render/mesh_view_types](#crates/bevy_pbr/src/render/mesh_view_types)
- [crates/bevy_pbr/src/render/forward_io](#crates/bevy_pbr/src/render/forward_io)
- [crates/bevy_pbr/src/render/rgb9e5](#crates/bevy_pbr/src/render/rgb9e5)
- [crates/bevy_pbr/src/render/morph](#crates/bevy_pbr/src/render/morph)
- [crates/bevy_pbr/src/render/clustered_forward](#crates/bevy_pbr/src/render/clustered_forward)
- [crates/bevy_pbr/src/render/mesh_functions](#crates/bevy_pbr/src/render/mesh_functions)
- [crates/bevy_pbr/src/render/pbr_transmission](#crates/bevy_pbr/src/render/pbr_transmission)
- [crates/bevy_pbr/src/render/mesh_view_bindings](#crates/bevy_pbr/src/render/mesh_view_bindings)
- [crates/bevy_pbr/src/render/view_transformations](#crates/bevy_pbr/src/render/view_transformations)
- [crates/bevy_pbr/src/render/skinning](#crates/bevy_pbr/src/render/skinning)
- [crates/bevy_pbr/src/prepass/prepass_utils](#crates/bevy_pbr/src/prepass/prepass_utils)
- [crates/bevy_pbr/src/prepass/prepass_bindings](#crates/bevy_pbr/src/prepass/prepass_bindings)
- [crates/bevy_pbr/src/prepass/prepass](#crates/bevy_pbr/src/prepass/prepass)
- [crates/bevy_pbr/src/prepass/prepass_io](#crates/bevy_pbr/src/prepass/prepass_io)
- [crates/bevy_pbr/src/meshlet/copy_material_depth](#crates/bevy_pbr/src/meshlet/copy_material_depth)
- [crates/bevy_pbr/src/meshlet/write_index_buffer](#crates/bevy_pbr/src/meshlet/write_index_buffer)
- [crates/bevy_pbr/src/meshlet/meshlet_bindings](#crates/bevy_pbr/src/meshlet/meshlet_bindings)
- [crates/bevy_pbr/src/meshlet/downsample_depth](#crates/bevy_pbr/src/meshlet/downsample_depth)
- [crates/bevy_pbr/src/meshlet/cull_meshlets](#crates/bevy_pbr/src/meshlet/cull_meshlets)
- [crates/bevy_pbr/src/meshlet/meshlet_mesh_material](#crates/bevy_pbr/src/meshlet/meshlet_mesh_material)
- [crates/bevy_pbr/src/meshlet/visibility_buffer_resolve](#crates/bevy_pbr/src/meshlet/visibility_buffer_resolve)
- [crates/bevy_pbr/src/meshlet/dummy_visibility_buffer_resolve](#crates/bevy_pbr/src/meshlet/dummy_visibility_buffer_resolve)
- [crates/bevy_pbr/src/meshlet/visibility_buffer_raster](#crates/bevy_pbr/src/meshlet/visibility_buffer_raster)
- [crates/bevy_pbr/src/light_probe/environment_map](#crates/bevy_pbr/src/light_probe/environment_map)
- [crates/bevy_pbr/src/light_probe/light_probe](#crates/bevy_pbr/src/light_probe/light_probe)
- [crates/bevy_pbr/src/light_probe/irradiance_volume](#crates/bevy_pbr/src/light_probe/irradiance_volume)
- [crates/bevy_pbr/src/lightmap/lightmap](#crates/bevy_pbr/src/lightmap/lightmap)
- [crates/bevy_pbr/src/ssao/spatial_denoise](#crates/bevy_pbr/src/ssao/spatial_denoise)
- [crates/bevy_pbr/src/ssao/gtao](#crates/bevy_pbr/src/ssao/gtao)
- [crates/bevy_pbr/src/ssao/gtao_utils](#crates/bevy_pbr/src/ssao/gtao_utils)
- [crates/bevy_pbr/src/ssao/preprocess_depth](#crates/bevy_pbr/src/ssao/preprocess_depth)
- [crates/bevy_pbr/src/deferred/deferred_lighting](#crates/bevy_pbr/src/deferred/deferred_lighting)
- [crates/bevy_pbr/src/deferred/pbr_deferred_functions](#crates/bevy_pbr/src/deferred/pbr_deferred_functions)
- [crates/bevy_pbr/src/deferred/pbr_deferred_types](#crates/bevy_pbr/src/deferred/pbr_deferred_types)
- [assets/shaders/line_material](#assets/shaders/line_material)
- [assets/shaders/instancing](#assets/shaders/instancing)
- [assets/shaders/gpu_readback](#assets/shaders/gpu_readback)
- [assets/shaders/shader_defs](#assets/shaders/shader_defs)
- [assets/shaders/custom_material_import](#assets/shaders/custom_material_import)
- [assets/shaders/extended_material](#assets/shaders/extended_material)
- [assets/shaders/custom_gltf_2d](#assets/shaders/custom_gltf_2d)
- [assets/shaders/custom_vertex_attribute](#assets/shaders/custom_vertex_attribute)
- [assets/shaders/texture_binding_array](#assets/shaders/texture_binding_array)
- [assets/shaders/circle_shader](#assets/shaders/circle_shader)
- [assets/shaders/tonemapping_test_patterns](#assets/shaders/tonemapping_test_patterns)
- [assets/shaders/custom_material_screenspace_texture](#assets/shaders/custom_material_screenspace_texture)
- [assets/shaders/custom_material_2d](#assets/shaders/custom_material_2d)
- [assets/shaders/cubemap_unlit](#assets/shaders/cubemap_unlit)
- [assets/shaders/fallback_image_test](#assets/shaders/fallback_image_test)
- [assets/shaders/custom_material](#assets/shaders/custom_material)
- [assets/shaders/array_texture](#assets/shaders/array_texture)
- [assets/shaders/show_prepass](#assets/shaders/show_prepass)
- [assets/shaders/irradiance_volume_voxel_visualization](#assets/shaders/irradiance_volume_voxel_visualization)
- [assets/shaders/game_of_life](#assets/shaders/game_of_life)
- [assets/shaders/animate_shader](#assets/shaders/animate_shader)
- [assets/shaders/post_processing](#assets/shaders/post_processing)

### crates/bevy_gizmos/src/lines

```rust
// TODO use common view binding
#import bevy_render::view::View

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
    @location(1) uv: f32,
};

const EPSILON: f32 = 4.88e-04;

@vertex
fn vertex(vertex: VertexInput) -> VertexOutput {
    var positions = array<vec2<f32>, 6>(
        vec2(-0.5, 0.),
        vec2(-0.5, 1.),
        vec2(0.5, 1.),
        vec2(-0.5, 0.),
        vec2(0.5, 1.),
        vec2(0.5, 0.)
    );
    let position = positions[vertex.index];

    // algorithm based on https://wwwtyro.net/2019/11/18/instanced-lines.html
    var clip_a = view.view_proj * vec4(vertex.position_a, 1.);
    var clip_b = view.view_proj * vec4(vertex.position_b, 1.);

    // Manual near plane clipping to avoid errors when doing the perspective divide inside this shader.
    clip_a = clip_near_plane(clip_a, clip_b);
    clip_b = clip_near_plane(clip_b, clip_a);
    let clip = mix(clip_a, clip_b, position.y);

    let resolution = view.viewport.zw;
    let screen_a = resolution * (0.5 * clip_a.xy / clip_a.w + 0.5);
    let screen_b = resolution * (0.5 * clip_b.xy / clip_b.w + 0.5);

    let y_basis = normalize(screen_b - screen_a);
    let x_basis = vec2(-y_basis.y, y_basis.x);

    var color = mix(vertex.color_a, vertex.color_b, position.y);

    var line_width = line_gizmo.line_width;
    var alpha = 1.;

    var uv: f32;
#ifdef PERSPECTIVE
    line_width /= clip.w;

    // get height of near clipping plane in world space
    let pos0 = view.inverse_projection * vec4(0, -1, 0, 1); // Bottom of the screen
    let pos1 = view.inverse_projection * vec4(0, 1, 0, 1); // Top of the screen
    let near_clipping_plane_height = length(pos0.xyz - pos1.xyz);

    // We can't use vertex.position_X because we may have changed the clip positions with clip_near_plane
    let position_a = view.inverse_view_proj * clip_a;
    let position_b = view.inverse_view_proj * clip_b;
    let world_distance = length(position_a.xyz - position_b.xyz);

    // Offset to compensate for moved clip positions. If removed dots on lines will slide when position a is ofscreen.
    let clipped_offset = length(position_a.xyz - vertex.position_a);

    uv = (clipped_offset + position.y * world_distance) * resolution.y / near_clipping_plane_height / line_gizmo.line_width;
#else
    // Get the distance of b to the camera along camera axes
    let camera_b = view.inverse_projection * clip_b;

    // This differentiates between orthographic and perspective cameras.
    // For orthographic cameras no depth adaptment (depth_adaptment = 1) is needed.
    var depth_adaptment: f32;
    if (clip_b.w == 1.0) {
        depth_adaptment = 1.0;
    }
    else {
        depth_adaptment = -camera_b.z;
    }
    uv = position.y * depth_adaptment * length(screen_b - screen_a) / line_gizmo.line_width;
#endif

    // Line thinness fade from https://acegikmo.com/shapes/docs/#anti-aliasing
    if line_width > 0.0 && line_width < 1. {
        color.a *= line_width;
        line_width = 1.;
    }

    let x_offset = line_width * position.x * x_basis;
    let screen = mix(screen_a, screen_b, position.y) + x_offset;

    var depth: f32;
    if line_gizmo.depth_bias >= 0. {
        depth = clip.z * (1. - line_gizmo.depth_bias);
    } else {
        // depth * (clip.w / depth)^-depth_bias. So that when -depth_bias is 1.0, this is equal to clip.w
        // and when equal to 0.0, it is exactly equal to depth.
        // the epsilon is here to prevent the depth from exceeding clip.w when -depth_bias = 1.0
        // clip.w represents the near plane in homogeneous clip space in bevy, having a depth
        // of this value means nothing can be in front of this
        // The reason this uses an exponential function is that it makes it much easier for the
        // user to chose a value that is convenient for them
        depth = clip.z * exp2(-line_gizmo.depth_bias * log2(clip.w / clip.z - EPSILON));
    }

    var clip_position = vec4(clip.w * ((2. * screen) / resolution - 1.), depth, clip.w);

    return VertexOutput(clip_position, color, uv);
}

fn clip_near_plane(a: vec4<f32>, b: vec4<f32>) -> vec4<f32> {
    // Move a if a is behind the near plane and b is in front. 
    if a.z > a.w && b.z <= b.w {
        // Interpolate a towards b until it's at the near plane.
        let distance_a = a.z - a.w;
        let distance_b = b.z - b.w;
        // Add an epsilon to the interpolator to ensure that the point is
        // not just behind the clip plane due to floating-point imprecision.
        let t = distance_a / (distance_a - distance_b) + EPSILON;
        return mix(a, b, t);
    }
    return a;
}

struct FragmentInput {
    @builtin(position) position: vec4<f32>,
    @location(0) color: vec4<f32>,
    @location(1) uv: f32,
};

struct FragmentOutput {
    @location(0) color: vec4<f32>,
};

@fragment
fn fragment_solid(in: FragmentInput) -> FragmentOutput {
    return FragmentOutput(in.color);
}
@fragment
fn fragment_dotted(in: FragmentInput) -> FragmentOutput {
    var alpha: f32;
#ifdef PERSPECTIVE
    alpha = 1 - floor(in.uv % 2.0);
#else
    alpha = 1 - floor((in.uv * in.position.w) % 2.0);
#endif
    
    return FragmentOutput(vec4(in.color.xyz, in.color.w * alpha));
}

```

### crates/bevy_gizmos/src/line_joints

```rust
#import bevy_render::view::View

@group(0) @binding(0) var<uniform> view: View;


struct LineGizmoUniform {
    line_width: f32,
    depth_bias: f32,
    resolution: u32,
#ifdef SIXTEEN_BYTE_ALIGNMENT
    // WebGL2 structs must be 16 byte aligned.
    _padding: f32,
#endif
}

@group(1) @binding(0) var<uniform> joints_gizmo: LineGizmoUniform;

struct VertexInput {
    @location(0) position_a: vec3<f32>,
    @location(1) position_b: vec3<f32>,
    @location(2) position_c: vec3<f32>,
    @location(3) color: vec4<f32>,
    @builtin(vertex_index) index: u32,
};

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) color: vec4<f32>,
};

const EPSILON: f32 = 4.88e-04;

@vertex
fn vertex_bevel(vertex: VertexInput) -> VertexOutput {
    var positions = array<vec2<f32>, 3>(
        vec2(0, 0),
        vec2(0, 0.5),
        vec2(0.5, 0),
    );
    var position = positions[vertex.index];

    var clip_a = view.view_proj * vec4(vertex.position_a, 1.);
    var clip_b = view.view_proj * vec4(vertex.position_b, 1.);
    var clip_c = view.view_proj * vec4(vertex.position_c, 1.);

    // Manual near plane clipping to avoid errors when doing the perspective divide inside this shader.
    clip_a = clip_near_plane(clip_a, clip_c);
    clip_b = clip_near_plane(clip_b, clip_a);
    clip_c = clip_near_plane(clip_c, clip_b);
    clip_a = clip_near_plane(clip_a, clip_c);

    let resolution = view.viewport.zw;
    let screen_a = resolution * (0.5 * clip_a.xy / clip_a.w + 0.5);
    let screen_b = resolution * (0.5 * clip_b.xy / clip_b.w + 0.5);
    let screen_c = resolution * (0.5 * clip_c.xy / clip_c.w + 0.5);

    var color = vertex.color;
    var line_width = joints_gizmo.line_width;

#ifdef PERSPECTIVE
    line_width /= clip_b.w;
#endif

    // Line thinness fade from https://acegikmo.com/shapes/docs/#anti-aliasing
    if line_width > 0.0 && line_width < 1. {
        color.a *= line_width;
        line_width = 1.;
    }

    let ab = normalize(screen_b - screen_a);
    let cb = normalize(screen_b - screen_c);
    let ab_norm = vec2(-ab.y, ab.x);
    let cb_norm = vec2(cb.y, -cb.x);
    let tangent = normalize(ab - cb);
    let normal = vec2(-tangent.y, tangent.x);
    let sigma = sign(dot(ab + cb, normal));

    var p0 = line_width * sigma * ab_norm;
    var p1 = line_width * sigma * cb_norm;

    let screen = screen_b + position.x * p0 + position.y * p1;

    let depth = depth(clip_b);

    var clip_position = vec4(clip_b.w * ((2. * screen) / resolution - 1.), depth, clip_b.w);
    return VertexOutput(clip_position, color);
}

@vertex
fn vertex_miter(vertex: VertexInput) -> VertexOutput {
    var positions = array<vec3<f32>, 6>(
        vec3(0, 0, 0),
        vec3(0.5, 0, 0),
        vec3(0, 0.5, 0),
        vec3(0, 0, 0),
        vec3(0, 0.5, 0),
        vec3(0, 0, 0.5),
    );
    var position = positions[vertex.index];
 
    var clip_a = view.view_proj * vec4(vertex.position_a, 1.);
    var clip_b = view.view_proj * vec4(vertex.position_b, 1.);
    var clip_c = view.view_proj * vec4(vertex.position_c, 1.);

    // Manual near plane clipping to avoid errors when doing the perspective divide inside this shader.
    clip_a = clip_near_plane(clip_a, clip_c);
    clip_b = clip_near_plane(clip_b, clip_a);
    clip_c = clip_near_plane(clip_c, clip_b);
    clip_a = clip_near_plane(clip_a, clip_c);

    let resolution = view.viewport.zw;
    let screen_a = resolution * (0.5 * clip_a.xy / clip_a.w + 0.5);
    let screen_b = resolution * (0.5 * clip_b.xy / clip_b.w + 0.5);
    let screen_c = resolution * (0.5 * clip_c.xy / clip_c.w + 0.5);

    var color = vertex.color;
    var line_width = joints_gizmo.line_width;

#ifdef PERSPECTIVE
    line_width /= clip_b.w;
#endif

    // Line thinness fade from https://acegikmo.com/shapes/docs/#anti-aliasing
    if line_width > 0.0 && line_width < 1. {
        color.a *= line_width;
        line_width = 1.;
    }

    let ab = normalize(screen_b - screen_a);
    let cb = normalize(screen_b - screen_c);
    let ab_norm = vec2(-ab.y, ab.x);
    let cb_norm = vec2(cb.y, -cb.x);
    let tangent = normalize(ab - cb);
    let normal = vec2(-tangent.y, tangent.x);
    let sigma = sign(dot(ab + cb, normal));

    var p0 = line_width * sigma * ab_norm;
    var p1 = line_width * sigma * normal / dot(normal, ab_norm);
    var p2 = line_width * sigma * cb_norm;
    
    var screen = screen_b + position.x * p0 + position.y * p1 + position.z * p2;

    var depth = depth(clip_b);

    var clip_position = vec4(clip_b.w * ((2. * screen) / resolution - 1.), depth, clip_b.w);
    return VertexOutput(clip_position, color);
}

@vertex
fn vertex_round(vertex: VertexInput) -> VertexOutput {
    var clip_a = view.view_proj * vec4(vertex.position_a, 1.);
    var clip_b = view.view_proj * vec4(vertex.position_b, 1.);
    var clip_c = view.view_proj * vec4(vertex.position_c, 1.);

    // Manual near plane clipping to avoid errors when doing the perspective divide inside this shader.
    clip_a = clip_near_plane(clip_a, clip_c);
    clip_b = clip_near_plane(clip_b, clip_a);
    clip_c = clip_near_plane(clip_c, clip_b);
    clip_a = clip_near_plane(clip_a, clip_c);

    let resolution = view.viewport.zw;
    let screen_a = resolution * (0.5 * clip_a.xy / clip_a.w + 0.5);
    let screen_b = resolution * (0.5 * clip_b.xy / clip_b.w + 0.5);
    let screen_c = resolution * (0.5 * clip_c.xy / clip_c.w + 0.5);

    var color = vertex.color;
    var line_width = joints_gizmo.line_width;

#ifdef PERSPECTIVE
    line_width /= clip_b.w;
#endif

    // Line thinness fade from https://acegikmo.com/shapes/docs/#anti-aliasing
    if line_width > 0.0 && line_width < 1. {
        color.a *= line_width;
        line_width = 1.;
    }

    let ab = normalize(screen_b - screen_a);
    let cb = normalize(screen_b - screen_c);
    let ab_norm = vec2(-ab.y, ab.x);
    let cb_norm = vec2(cb.y, -cb.x);

    // We render `joints_gizmo.resolution`triangles. The vertices in each triangle are ordered as follows:
    // - 0: The 'center' vertex at `screen_b`.
    // - 1: The vertex closer to the ab line.
    // - 2: The vertex closer to the cb line. 
    var in_triangle_index = f32(vertex.index) % 3.0;
    var tri_index = floor(f32(vertex.index) / 3.0);
    var radius = sign(in_triangle_index) * 0.5 * line_width;
    var theta = acos(dot(ab_norm, cb_norm));
    let sigma = sign(dot(ab_norm, cb));
    var angle = theta * (tri_index + in_triangle_index - 1) / f32(joints_gizmo.resolution);
    var position_x = sigma * radius * cos(angle);
    var position_y = radius * sin(angle);

    var screen = screen_b + position_x * ab_norm + position_y * ab;

    var depth = depth(clip_b);

    var clip_position = vec4(clip_b.w * ((2. * screen) / resolution - 1.), depth, clip_b.w);
    return VertexOutput(clip_position, color);
}

fn clip_near_plane(a: vec4<f32>, b: vec4<f32>) -> vec4<f32> {
    // Move a if a is behind the near plane and b is in front. 
    if a.z > a.w && b.z <= b.w {
        // Interpolate a towards b until it's at the near plane.
        let distance_a = a.z - a.w;
        let distance_b = b.z - b.w;
        // Add an epsilon to the interpolator to ensure that the point is
        // not just behind the clip plane due to floating-point imprecision.
        let t = distance_a / (distance_a - distance_b) + EPSILON;
        return mix(a, b, t);
    }
    return a;
}

fn depth(clip: vec4<f32>) -> f32 {
    var depth: f32;
    if joints_gizmo.depth_bias >= 0. {
        depth = clip.z * (1. - joints_gizmo.depth_bias);
    } else {
        // depth * (clip.w / depth)^-depth_bias. So that when -depth_bias is 1.0, this is equal to clip.w
        // and when equal to 0.0, it is exactly equal to depth.
        // the epsilon is here to prevent the depth from exceeding clip.w when -depth_bias = 1.0
        // clip.w represents the near plane in homogeneous clip space in bevy, having a depth
        // of this value means nothing can be in front of this
        // The reason this uses an exponential function is that it makes it much easier for the
        // user to chose a value that is convenient for them
        depth = clip.z * exp2(-joints_gizmo.depth_bias * log2(clip.w / clip.z - EPSILON));
    }
    return depth;
}

struct FragmentInput {
    @location(0) color: vec4<f32>,
};

struct FragmentOutput {
    @location(0) color: vec4<f32>,
};

@fragment
fn fragment(in: FragmentInput) -> FragmentOutput {
    // return FragmentOutput(vec4(1, 1, 1, 1));
    return FragmentOutput(in.color);
}
```

### crates/bevy_sprite/src/render/sprite

```rust
#ifdef TONEMAP_IN_SHADER
#import bevy_core_pipeline::tonemapping
#endif

#import bevy_render::{
    maths::affine3_to_square,
    view::View,
}

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

    out.clip_position = view.view_proj * affine3_to_square(mat3x4<f32>(
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
    var color = in.color * textureSample(sprite_texture, sprite_sampler, in.uv);

#ifdef TONEMAP_IN_SHADER
    color = tonemapping::tone_mapping(color, view.color_grading);
#endif

    return color;
}

```

### crates/bevy_sprite/src/mesh2d/mesh2d_functions

```rust
#define_import_path bevy_sprite::mesh2d_functions

#import bevy_sprite::{
    mesh2d_view_bindings::view,
    mesh2d_bindings::mesh,
}
#import bevy_render::maths::{affine3_to_square, mat2x4_f32_to_mat3x3_unpack}

fn get_model_matrix(instance_index: u32) -> mat4x4<f32> {
    return affine3_to_square(mesh[instance_index].model);
}

fn mesh2d_position_local_to_world(model: mat4x4<f32>, vertex_position: vec4<f32>) -> vec4<f32> {
    return model * vertex_position;
}

fn mesh2d_position_world_to_clip(world_position: vec4<f32>) -> vec4<f32> {
    return view.view_proj * world_position;
}

// NOTE: The intermediate world_position assignment is important
// for precision purposes when using the 'equals' depth comparison
// function.
fn mesh2d_position_local_to_clip(model: mat4x4<f32>, vertex_position: vec4<f32>) -> vec4<f32> {
    let world_position = mesh2d_position_local_to_world(model, vertex_position);
    return mesh2d_position_world_to_clip(world_position);
}

fn mesh2d_normal_local_to_world(vertex_normal: vec3<f32>, instance_index: u32) -> vec3<f32> {
    return mat2x4_f32_to_mat3x3_unpack(
        mesh[instance_index].inverse_transpose_model_a,
        mesh[instance_index].inverse_transpose_model_b,
    ) * vertex_normal;
}

fn mesh2d_tangent_local_to_world(model: mat4x4<f32>, vertex_tangent: vec4<f32>) -> vec4<f32> {
    return vec4<f32>(
        mat3x3<f32>(
            model[0].xyz,
            model[1].xyz,
            model[2].xyz
        ) * vertex_tangent.xyz,
        vertex_tangent.w
    );
}

```

### crates/bevy_sprite/src/mesh2d/mesh2d

```rust
#import bevy_sprite::{
    mesh2d_functions as mesh_functions,
    mesh2d_vertex_output::VertexOutput,
    mesh2d_view_bindings::view,
}

#ifdef TONEMAP_IN_SHADER
#import bevy_core_pipeline::tonemapping
#endif

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
};

@vertex
fn vertex(vertex: Vertex) -> VertexOutput {
    var out: VertexOutput;
#ifdef VERTEX_UVS
    out.uv = vertex.uv;
#endif

#ifdef VERTEX_POSITIONS
    var model = mesh_functions::get_model_matrix(vertex.instance_index);
    out.world_position = mesh_functions::mesh2d_position_local_to_world(
        model,
        vec4<f32>(vertex.position, 1.0)
    );
    out.position = mesh_functions::mesh2d_position_world_to_clip(out.world_position);
#endif

#ifdef VERTEX_NORMALS
    out.world_normal = mesh_functions::mesh2d_normal_local_to_world(vertex.normal, vertex.instance_index);
#endif

#ifdef VERTEX_TANGENTS
    out.world_tangent = mesh_functions::mesh2d_tangent_local_to_world(
        model,
        vertex.tangent
    );
#endif

#ifdef VERTEX_COLORS
    out.color = vertex.color;
#endif
    return out;
}

@fragment
fn fragment(
    in: VertexOutput,
) -> @location(0) vec4<f32> {
#ifdef VERTEX_COLORS
    var color = in.color;
#ifdef TONEMAP_IN_SHADER
    color = tonemapping::tone_mapping(color, view.color_grading);
#endif
    return color;
#else
    return vec4<f32>(1.0, 0.0, 1.0, 1.0);
#endif
}

```

### crates/bevy_sprite/src/mesh2d/color_material

```rust
#import bevy_sprite::{
    mesh2d_vertex_output::VertexOutput,
    mesh2d_view_bindings::view,
}

#ifdef TONEMAP_IN_SHADER
#import bevy_core_pipeline::tonemapping
#endif

struct ColorMaterial {
    color: vec4<f32>,
    // 'flags' is a bit field indicating various options. u32 is 32 bits so we have up to 32 options.
    flags: u32,
};
const COLOR_MATERIAL_FLAGS_TEXTURE_BIT: u32 = 1u;

@group(2) @binding(0) var<uniform> material: ColorMaterial;
@group(2) @binding(1) var texture: texture_2d<f32>;
@group(2) @binding(2) var texture_sampler: sampler;

@fragment
fn fragment(
    mesh: VertexOutput,
) -> @location(0) vec4<f32> {
    var output_color: vec4<f32> = material.color;
#ifdef VERTEX_COLORS
    output_color = output_color * mesh.color;
#endif
    if ((material.flags & COLOR_MATERIAL_FLAGS_TEXTURE_BIT) != 0u) {
        output_color = output_color * textureSample(texture, texture_sampler, mesh.uv);
    }
#ifdef TONEMAP_IN_SHADER
    output_color = tonemapping::tone_mapping(output_color, view.color_grading);
#endif
    return output_color;
}

```

### crates/bevy_sprite/src/mesh2d/mesh2d_view_bindings

```rust
#define_import_path bevy_sprite::mesh2d_view_bindings

#import bevy_render::view::View
#import bevy_render::globals::Globals

@group(0) @binding(0) var<uniform> view: View;

@group(0) @binding(1) var<uniform> globals: Globals;

```

### crates/bevy_sprite/src/mesh2d/mesh2d_types

```rust
#define_import_path bevy_sprite::mesh2d_types

struct Mesh2d {
    // Affine 4x3 matrix transposed to 3x4
    // Use bevy_render::maths::affine3_to_square to unpack
    model: mat3x4<f32>,
    // 3x3 matrix packed in mat2x4 and f32 as:
    // [0].xyz, [1].x,
    // [1].yz, [2].xy
    // [2].z
    // Use bevy_render::maths::mat2x4_f32_to_mat3x3_unpack to unpack
    inverse_transpose_model_a: mat2x4<f32>,
    inverse_transpose_model_b: f32,
    // 'flags' is a bit field indicating various options. u32 is 32 bits so we have up to 32 options.
    flags: u32,
};

```

### crates/bevy_sprite/src/mesh2d/mesh2d_view_types

```rust
#define_import_path bevy_sprite::mesh2d_view_types

#import bevy_render::view
#import bevy_render::globals

```

### crates/bevy_sprite/src/mesh2d/mesh2d_vertex_output

```rust
#define_import_path bevy_sprite::mesh2d_vertex_output

struct VertexOutput {
    // this is `clip position` when the struct is used as a vertex stage output 
    // and `frag coord` when used as a fragment stage input
    @builtin(position) position: vec4<f32>,
    @location(0) world_position: vec4<f32>,
    @location(1) world_normal: vec3<f32>,
    @location(2) uv: vec2<f32>,
    #ifdef VERTEX_TANGENTS
    @location(3) world_tangent: vec4<f32>,
    #endif
    #ifdef VERTEX_COLORS
    @location(4) color: vec4<f32>,
    #endif
}

```

### crates/bevy_sprite/src/mesh2d/mesh2d_bindings

```rust
#define_import_path bevy_sprite::mesh2d_bindings

#import bevy_sprite::mesh2d_types::Mesh2d

#ifdef PER_OBJECT_BUFFER_BATCH_SIZE
@group(1) @binding(0) var<uniform> mesh: array<Mesh2d, #{PER_OBJECT_BUFFER_BATCH_SIZE}u>;
#else
@group(1) @binding(0) var<storage> mesh: array<Mesh2d>;
#endif // PER_OBJECT_BUFFER_BATCH_SIZE

```

### crates/bevy_sprite/src/mesh2d/wireframe2d

```rust
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

struct WireframeMaterial {
    color: vec4<f32>,
};

@group(2) @binding(0) var<uniform> material: WireframeMaterial;
@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    return material.color;
}

```

### crates/bevy_ui/src/render/ui

```rust
#import bevy_render::view::View

const TEXTURED = 1u;
const RIGHT_VERTEX = 2u;
const BOTTOM_VERTEX = 4u;
const BORDER: u32 = 8u;

fn enabled(flags: u32, mask: u32) -> bool {
    return (flags & mask) != 0u;
}

@group(0) @binding(0) var<uniform> view: View;

struct VertexOutput {
    @location(0) uv: vec2<f32>,
    @location(1) color: vec4<f32>,

    @location(2) @interpolate(flat) size: vec2<f32>,
    @location(3) @interpolate(flat) flags: u32,
    @location(4) @interpolate(flat) radius: vec4<f32>,    
    @location(5) @interpolate(flat) border: vec4<f32>,    

    // Position relative to the center of the rectangle.
    @location(6) point: vec2<f32>,
    @builtin(position) position: vec4<f32>,
};

@vertex
fn vertex(
    @location(0) vertex_position: vec3<f32>,
    @location(1) vertex_uv: vec2<f32>,
    @location(2) vertex_color: vec4<f32>,
    @location(3) flags: u32,

    // x: top left, y: top right, z: bottom right, w: bottom left.
    @location(4) radius: vec4<f32>,

    // x: left, y: top, z: right, w: bottom.
    @location(5) border: vec4<f32>,
    @location(6) size: vec2<f32>,
) -> VertexOutput {
    var out: VertexOutput;
    out.uv = vertex_uv;
    out.position = view.view_proj * vec4(vertex_position, 1.0);
    out.color = vertex_color;
    out.flags = flags;
    out.radius = radius;
    out.size = size;
    out.border = border;
    var point = 0.49999 * size;
    if (flags & RIGHT_VERTEX) == 0u {
        point.x *= -1.;
    }
    if (flags & BOTTOM_VERTEX) == 0u {
        point.y *= -1.;
    }
    out.point = point;

    return out;
}

@group(1) @binding(0) var sprite_texture: texture_2d<f32>;
@group(1) @binding(1) var sprite_sampler: sampler;

// The returned value is the shortest distance from the given point to the boundary of the rounded 
// box.
// 
// Negative values indicate that the point is inside the rounded box, positive values that the point 
// is outside, and zero is exactly on the boundary.
//
// Arguments: 
//  - `point`        -> The function will return the distance from this point to the closest point on 
//                    the boundary.
//  - `size`         -> The maximum width and height of the box.
//  - `corner_radii` -> The radius of each rounded corner. Ordered counter clockwise starting 
//                    top left:
//                      x: top left, y: top right, z: bottom right, w: bottom left.
fn sd_rounded_box(point: vec2<f32>, size: vec2<f32>, corner_radii: vec4<f32>) -> f32 {
    // If 0.0 < y then select bottom left (w) and bottom right corner radius (z).
    // Else select top left (x) and top right corner radius (y).
    let rs = select(corner_radii.xy, corner_radii.wz, 0.0 < point.y);
    // w and z are swapped so that both pairs are in left to right order, otherwise this second 
    // select statement would return the incorrect value for the bottom pair.
    let radius = select(rs.x, rs.y, 0.0 < point.x);
    // Vector from the corner closest to the point, to the point.
    let corner_to_point = abs(point) - 0.5 * size;
    // Vector from the center of the radius circle to the point.
    let q = corner_to_point + radius;
    // Length from center of the radius circle to the point, zeros a component if the point is not 
    // within the quadrant of the radius circle that is part of the curved corner.
    let l = length(max(q, vec2(0.0)));
    let m = min(max(q.x, q.y), 0.0);
    return l + m - radius;
}

fn sd_inset_rounded_box(point: vec2<f32>, size: vec2<f32>, radius: vec4<f32>, inset: vec4<f32>) -> f32 {
    let inner_size = size - inset.xy - inset.zw;
    let inner_center = inset.xy + 0.5 * inner_size - 0.5 * size;
    let inner_point = point - inner_center;

    var r = radius;

    // Top left corner.
    r.x = r.x - max(inset.x, inset.y);

    // Top right corner.
    r.y = r.y - max(inset.z, inset.y);

    // Bottom right corner.
    r.z = r.z - max(inset.z, inset.w); 

    // Bottom left corner.
    r.w = r.w - max(inset.x, inset.w);

    let half_size = inner_size * 0.5;
    let min_size = min(half_size.x, half_size.y);

    r = min(max(r, vec4(0.0)), vec4<f32>(min_size));

    return sd_rounded_box(inner_point, inner_size, r);
}

fn draw(in: VertexOutput) -> vec4<f32> {
    let texture_color = textureSample(sprite_texture, sprite_sampler, in.uv);

    // Only use the color sampled from the texture if the `TEXTURED` flag is enabled. 
    // This allows us to draw both textured and untextured shapes together in the same batch.
    let color = select(in.color, in.color * texture_color, enabled(in.flags, TEXTURED));

    // Signed distances. The magnitude is the distance of the point from the edge of the shape.
    // * Negative values indicate that the point is inside the shape.
    // * Zero values indicate the point is on on the edge of the shape.
    // * Positive values indicate the point is outside the shape.

    // Signed distance from the exterior boundary.
    let external_distance = sd_rounded_box(in.point, in.size, in.radius);

    // Signed distance from the border's internal edge (the signed distance is negative if the point 
    // is inside the rect but not on the border).
    // If the border size is set to zero, this is the same as as the external distance.
    let internal_distance = sd_inset_rounded_box(in.point, in.size, in.radius, in.border);

    // Signed distance from the border (the intersection of the rect with its border).
    // Points inside the border have negative signed distance. Any point outside the border, whether 
    // outside the outside edge, or inside the inner edge have positive signed distance.
    let border_distance = max(external_distance, -internal_distance);

    // The `fwidth` function returns an approximation of the rate of change of the signed distance 
    // value that is used to ensure that the smooth alpha transition created by smoothstep occurs 
    // over a range of distance values that is proportional to how quickly the distance is changing.
    let fborder = fwidth(border_distance);
    let fexternal = fwidth(external_distance);

    if enabled(in.flags, BORDER) {   
        // The item is a border

        // At external edges with no border, `border_distance` is equal to zero. 
        // This select statement ensures we only perform anti-aliasing where a non-zero width border 
        // is present, otherwise an outline about the external boundary would be drawn even without 
        // a border.
        let t = 1. - select(step(0.0, border_distance), smoothstep(0.0, fborder, border_distance), external_distance < internal_distance);
        return color.rgba * t;
    }

    // The item is a rectangle, draw normally with anti-aliasing at the edges.
    let t = 1. - smoothstep(0.0, fexternal, external_distance);
    return color.rgba * t;
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    return draw(in);
}

```

### crates/bevy_ui/src/render/ui_material

```rust
#import bevy_render::{
    view::View,
    globals::Globals,
}
#import bevy_ui::ui_vertex_output::UiVertexOutput

@group(0) @binding(0)
var<uniform> view: View;
@group(0) @binding(1)
var<uniform> globals: Globals;

@vertex
fn vertex(
    @location(0) vertex_position: vec3<f32>,
    @location(1) vertex_uv: vec2<f32>,
    @location(2) size: vec2<f32>,
    @location(3) border_widths: vec4<f32>,
) -> UiVertexOutput {
    var out: UiVertexOutput;
    out.uv = vertex_uv;
    out.position = view.view_proj * vec4<f32>(vertex_position, 1.0);
    out.size = size;
    out.border_widths = border_widths;
    return out;
}

@fragment
fn fragment(in: UiVertexOutput) -> @location(0) vec4<f32> {
    return vec4<f32>(1.0);
}

```

### crates/bevy_ui/src/render/ui_vertex_output

```rust
#define_import_path bevy_ui::ui_vertex_output

// The Vertex output of the default vertex shader for the Ui Material pipeline.
struct UiVertexOutput {
    @location(0) uv: vec2<f32>,
    // The size of the borders in UV space. Order is Left, Right, Top, Bottom.
    @location(1) border_widths: vec4<f32>,
    // The size of the node in pixels. Order is width, height.
    @location(2) @interpolate(flat) size: vec2<f32>,
    @builtin(position) position: vec4<f32>,
};

```

### crates/bevy_core_pipeline/src/bloom/bloom

```rust
// Bloom works by creating an intermediate texture with a bunch of mip levels, each half the size of the previous.
// You then downsample each mip (starting with the original texture) to the lower resolution mip under it, going in order.
// You then upsample each mip (starting from the smallest mip) and blend with the higher resolution mip above it (ending on the original texture).
//
// References:
// * [COD] - Next Generation Post Processing in Call of Duty - http://www.iryoku.com/next-generation-post-processing-in-call-of-duty-advanced-warfare
// * [PBB] - Physically Based Bloom - https://learnopengl.com/Guest-Articles/2022/Phys.-Based-Bloom

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
    let a = textureSample(input_texture, s, uv, vec2<i32>(-2, 2)).rgb;
    let b = textureSample(input_texture, s, uv, vec2<i32>(0, 2)).rgb;
    let c = textureSample(input_texture, s, uv, vec2<i32>(2, 2)).rgb;
    let d = textureSample(input_texture, s, uv, vec2<i32>(-2, 0)).rgb;
    let e = textureSample(input_texture, s, uv).rgb;
    let f = textureSample(input_texture, s, uv, vec2<i32>(2, 0)).rgb;
    let g = textureSample(input_texture, s, uv, vec2<i32>(-2, -2)).rgb;
    let h = textureSample(input_texture, s, uv, vec2<i32>(0, -2)).rgb;
    let i = textureSample(input_texture, s, uv, vec2<i32>(2, -2)).rgb;
    let j = textureSample(input_texture, s, uv, vec2<i32>(-1, 1)).rgb;
    let k = textureSample(input_texture, s, uv, vec2<i32>(1, 1)).rgb;
    let l = textureSample(input_texture, s, uv, vec2<i32>(-1, -1)).rgb;
    let m = textureSample(input_texture, s, uv, vec2<i32>(1, -1)).rgb;

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

    let a = textureSample(input_texture, s, vec2<f32>(uv.x - x, uv.y + y)).rgb;
    let b = textureSample(input_texture, s, vec2<f32>(uv.x, uv.y + y)).rgb;
    let c = textureSample(input_texture, s, vec2<f32>(uv.x + x, uv.y + y)).rgb;

    let d = textureSample(input_texture, s, vec2<f32>(uv.x - x, uv.y)).rgb;
    let e = textureSample(input_texture, s, vec2<f32>(uv.x, uv.y)).rgb;
    let f = textureSample(input_texture, s, vec2<f32>(uv.x + x, uv.y)).rgb;

    let g = textureSample(input_texture, s, vec2<f32>(uv.x - x, uv.y - y)).rgb;
    let h = textureSample(input_texture, s, vec2<f32>(uv.x, uv.y - y)).rgb;
    let i = textureSample(input_texture, s, vec2<f32>(uv.x + x, uv.y - y)).rgb;

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

```

### crates/bevy_core_pipeline/src/fxaa/fxaa

```rust
// NVIDIA FXAA 3.11
// Original source code by TIMOTHY LOTTES
// https://gist.github.com/kosua20/0c506b81b3812ac900048059d2383126
//
// Cleaned version - https://github.com/kosua20/Rendu/blob/master/resources/common/shaders/screens/fxaa.frag
//
// Tweaks by mrDIMAS - https://github.com/FyroxEngine/Fyrox/blob/master/src/renderer/shaders/fxaa_fs.glsl

#import bevy_core_pipeline::fullscreen_vertex_shader::FullscreenVertexOutput

@group(0) @binding(0) var screenTexture: texture_2d<f32>;
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
    let resolution = vec2<f32>(textureDimensions(screenTexture));
    let inverseScreenSize = 1.0 / resolution.xy;
    let texCoord = in.position.xy * inverseScreenSize;

    let centerSample = textureSampleLevel(screenTexture, samp, texCoord, 0.0);
    let colorCenter = centerSample.rgb;

    // Luma at the current fragment
    let lumaCenter = rgb2luma(colorCenter);

    // Luma at the four direct neighbors of the current fragment.
    let lumaDown = rgb2luma(textureSampleLevel(screenTexture, samp, texCoord, 0.0, vec2<i32>(0, -1)).rgb);
    let lumaUp = rgb2luma(textureSampleLevel(screenTexture, samp, texCoord, 0.0, vec2<i32>(0, 1)).rgb);
    let lumaLeft = rgb2luma(textureSampleLevel(screenTexture, samp, texCoord, 0.0, vec2<i32>(-1, 0)).rgb);
    let lumaRight = rgb2luma(textureSampleLevel(screenTexture, samp, texCoord, 0.0, vec2<i32>(1, 0)).rgb);

    // Find the maximum and minimum luma around the current fragment.
    let lumaMin = min(lumaCenter, min(min(lumaDown, lumaUp), min(lumaLeft, lumaRight)));
    let lumaMax = max(lumaCenter, max(max(lumaDown, lumaUp), max(lumaLeft, lumaRight)));

    // Compute the delta.
    let lumaRange = lumaMax - lumaMin;

    // If the luma variation is lower that a threshold (or if we are in a really dark area), we are not on an edge, don't perform any AA.
    if (lumaRange < max(EDGE_THRESHOLD_MIN, lumaMax * EDGE_THRESHOLD_MAX)) {
        return centerSample;
    }

    // Query the 4 remaining corners lumas.
    let lumaDownLeft  = rgb2luma(textureSampleLevel(screenTexture, samp, texCoord, 0.0, vec2<i32>(-1, -1)).rgb);
    let lumaUpRight   = rgb2luma(textureSampleLevel(screenTexture, samp, texCoord, 0.0, vec2<i32>(1, 1)).rgb);
    let lumaUpLeft    = rgb2luma(textureSampleLevel(screenTexture, samp, texCoord, 0.0, vec2<i32>(-1, 1)).rgb);
    let lumaDownRight = rgb2luma(textureSampleLevel(screenTexture, samp, texCoord, 0.0, vec2<i32>(1, -1)).rgb);

    // Combine the four edges lumas (using intermediary variables for future computations with the same values).
    let lumaDownUp = lumaDown + lumaUp;
    let lumaLeftRight = lumaLeft + lumaRight;

    // Same for corners
    let lumaLeftCorners = lumaDownLeft + lumaUpLeft;
    let lumaDownCorners = lumaDownLeft + lumaDownRight;
    let lumaRightCorners = lumaDownRight + lumaUpRight;
    let lumaUpCorners = lumaUpRight + lumaUpLeft;

    // Compute an estimation of the gradient along the horizontal and vertical axis.
    let edgeHorizontal = abs(-2.0 * lumaLeft   + lumaLeftCorners)  + 
                         abs(-2.0 * lumaCenter + lumaDownUp) * 2.0 + 
                         abs(-2.0 * lumaRight  + lumaRightCorners);

    let edgeVertical =   abs(-2.0 * lumaUp     + lumaUpCorners)       + 
                         abs(-2.0 * lumaCenter + lumaLeftRight) * 2.0 + 
                         abs(-2.0 * lumaDown   + lumaDownCorners);

    // Is the local edge horizontal or vertical ?
    let isHorizontal = (edgeHorizontal >= edgeVertical);

    // Choose the step size (one pixel) accordingly.
    var stepLength = select(inverseScreenSize.x, inverseScreenSize.y, isHorizontal);

    // Select the two neighboring texels lumas in the opposite direction to the local edge.
    var luma1 = select(lumaLeft, lumaDown, isHorizontal);
    var luma2 = select(lumaRight, lumaUp, isHorizontal);

    // Compute gradients in this direction.
    let gradient1 = luma1 - lumaCenter;
    let gradient2 = luma2 - lumaCenter;

    // Which direction is the steepest ?
    let is1Steepest = abs(gradient1) >= abs(gradient2);

    // Gradient in the corresponding direction, normalized.
    let gradientScaled = 0.25 * max(abs(gradient1), abs(gradient2));

    // Average luma in the correct direction.
    var lumaLocalAverage = 0.0;
    if (is1Steepest) {
        // Switch the direction
        stepLength = -stepLength;
        lumaLocalAverage = 0.5 * (luma1 + lumaCenter);
    } else {
        lumaLocalAverage = 0.5 * (luma2 + lumaCenter);
    }

    // Shift UV in the correct direction by half a pixel.
    // Compute offset (for each iteration step) in the right direction.
    var currentUv = texCoord;
    var offset = vec2<f32>(0.0, 0.0);
    if (isHorizontal) {
        currentUv.y = currentUv.y + stepLength * 0.5;
        offset.x = inverseScreenSize.x;
    } else {
        currentUv.x = currentUv.x + stepLength * 0.5;
        offset.y = inverseScreenSize.y;
    }

    // Compute UVs to explore on each side of the edge, orthogonally. The QUALITY allows us to step faster.
    var uv1 = currentUv - offset; // * QUALITY(0); // (quality 0 is 1.0)
    var uv2 = currentUv + offset; // * QUALITY(0); // (quality 0 is 1.0)

    // Read the lumas at both current extremities of the exploration segment, and compute the delta wrt to the local average luma.
    var lumaEnd1 = rgb2luma(textureSampleLevel(screenTexture, samp, uv1, 0.0).rgb);
    var lumaEnd2 = rgb2luma(textureSampleLevel(screenTexture, samp, uv2, 0.0).rgb);
    lumaEnd1 = lumaEnd1 - lumaLocalAverage;
    lumaEnd2 = lumaEnd2 - lumaLocalAverage;

    // If the luma deltas at the current extremities is larger than the local gradient, we have reached the side of the edge.
    var reached1 = abs(lumaEnd1) >= gradientScaled;
    var reached2 = abs(lumaEnd2) >= gradientScaled;
    var reachedBoth = reached1 && reached2;

    // If the side is not reached, we continue to explore in this direction.
    uv1 = select(uv1 - offset, uv1, reached1); // * QUALITY(1); // (quality 1 is 1.0)
    uv2 = select(uv2 - offset, uv2, reached2); // * QUALITY(1); // (quality 1 is 1.0)

    // If both sides have not been reached, continue to explore.
    if (!reachedBoth) {
        for (var i: i32 = 2; i < ITERATIONS; i = i + 1) {
            // If needed, read luma in 1st direction, compute delta.
            if (!reached1) { 
                lumaEnd1 = rgb2luma(textureSampleLevel(screenTexture, samp, uv1, 0.0).rgb);
                lumaEnd1 = lumaEnd1 - lumaLocalAverage;
            }
            // If needed, read luma in opposite direction, compute delta.
            if (!reached2) { 
                lumaEnd2 = rgb2luma(textureSampleLevel(screenTexture, samp, uv2, 0.0).rgb);
                lumaEnd2 = lumaEnd2 - lumaLocalAverage;
            }
            // If the luma deltas at the current extremities is larger than the local gradient, we have reached the side of the edge.
            reached1 = abs(lumaEnd1) >= gradientScaled;
            reached2 = abs(lumaEnd2) >= gradientScaled;
            reachedBoth = reached1 && reached2;

            // If the side is not reached, we continue to explore in this direction, with a variable quality.
            if (!reached1) {
                uv1 = uv1 - offset * QUALITY(i);
            }
            if (!reached2) {
                uv2 = uv2 + offset * QUALITY(i);
            }

            // If both sides have been reached, stop the exploration.
            if (reachedBoth) { 
                break; 
            }
        }
    }

    // Compute the distances to each side edge of the edge (!).
    var distance1 = select(texCoord.y - uv1.y, texCoord.x - uv1.x, isHorizontal);
    var distance2 = select(uv2.y - texCoord.y, uv2.x - texCoord.x, isHorizontal);

    // In which direction is the side of the edge closer ?
    let isDirection1 = distance1 < distance2;
    let distanceFinal = min(distance1, distance2);

    // Thickness of the edge.
    let edgeThickness = (distance1 + distance2);

    // Is the luma at center smaller than the local average ?
    let isLumaCenterSmaller = lumaCenter < lumaLocalAverage;

    // If the luma at center is smaller than at its neighbor, the delta luma at each end should be positive (same variation).
    let correctVariation1 = (lumaEnd1 < 0.0) != isLumaCenterSmaller;
    let correctVariation2 = (lumaEnd2 < 0.0) != isLumaCenterSmaller;

    // Only keep the result in the direction of the closer side of the edge.
    var correctVariation = select(correctVariation2, correctVariation1, isDirection1);

    // UV offset: read in the direction of the closest side of the edge.
    let pixelOffset = - distanceFinal / edgeThickness + 0.5;

    // If the luma variation is incorrect, do not offset.
    var finalOffset = select(0.0, pixelOffset, correctVariation);

    // Sub-pixel shifting
    // Full weighted average of the luma over the 3x3 neighborhood.
    let lumaAverage = (1.0 / 12.0) * (2.0 * (lumaDownUp + lumaLeftRight) + lumaLeftCorners + lumaRightCorners);
    // Ratio of the delta between the global average and the center luma, over the luma range in the 3x3 neighborhood.
    let subPixelOffset1 = clamp(abs(lumaAverage - lumaCenter) / lumaRange, 0.0, 1.0);
    let subPixelOffset2 = (-2.0 * subPixelOffset1 + 3.0) * subPixelOffset1 * subPixelOffset1;
    // Compute a sub-pixel offset based on this delta.
    let subPixelOffsetFinal = subPixelOffset2 * subPixelOffset2 * SUBPIXEL_QUALITY;

    // Pick the biggest of the two offsets.
    finalOffset = max(finalOffset, subPixelOffsetFinal);

    // Compute the final UV coordinates.
    var finalUv = texCoord;
    if (isHorizontal) {
        finalUv.y = finalUv.y + finalOffset * stepLength;
    } else {
        finalUv.x = finalUv.x + finalOffset * stepLength;
    }

    // Read the color at the new UV coordinates, and use it.
    var finalColor = textureSampleLevel(screenTexture, samp, finalUv, 0.0).rgb;
    return vec4<f32>(finalColor, centerSample.a);
}

```

### crates/bevy_core_pipeline/src/skybox/skybox

```rust
#import bevy_render::view::View
#import bevy_pbr::utils::coords_to_viewport_uv

struct SkyboxUniforms {
	brightness: f32,
#ifdef SIXTEEN_BYTE_ALIGNMENT
	_wasm_padding_8b: u32,
	_wasm_padding_12b: u32,
	_wasm_padding_16b: u32,
#endif
}

@group(0) @binding(0) var skybox: texture_cube<f32>;
@group(0) @binding(1) var skybox_sampler: sampler;
@group(0) @binding(2) var<uniform> view: View;
@group(0) @binding(3) var<uniform> uniforms: SkyboxUniforms;

fn coords_to_ray_direction(position: vec2<f32>, viewport: vec4<f32>) -> vec3<f32> {
    // Using world positions of the fragment and camera to calculate a ray direction
    // breaks down at large translations. This code only needs to know the ray direction.
    // The ray direction is along the direction from the camera to the fragment position.
    // In view space, the camera is at the origin, so the view space ray direction is
    // along the direction of the fragment position - (0,0,0) which is just the
    // fragment position.
    // Use the position on the near clipping plane to avoid -inf world position
    // because the far plane of an infinite reverse projection is at infinity.
    let view_position_homogeneous = view.inverse_projection * vec4(
        coords_to_viewport_uv(position, viewport) * vec2(2.0, -2.0) + vec2(-1.0, 1.0),
        1.0,
        1.0,
    );
    let view_ray_direction = view_position_homogeneous.xyz / view_position_homogeneous.w;
    // Transforming the view space ray direction by the view matrix, transforms the
    // direction to world space. Note that the w element is set to 0.0, as this is a
    // vector direction, not a position, That causes the matrix multiplication to ignore
    // the translations from the view matrix.
    let ray_direction = (view.view * vec4(view_ray_direction, 0.0)).xyz;

    return normalize(ray_direction);
}

struct VertexOutput {
    @builtin(position) position: vec4<f32>,
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

    return VertexOutput(clip_position);
}

@fragment
fn skybox_fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let ray_direction = coords_to_ray_direction(in.position.xy, view.viewport);

    // Cube maps are left-handed so we negate the z coordinate.
    let out = textureSample(skybox, skybox_sampler, ray_direction * vec3(1.0, 1.0, -1.0));
    return vec4(out.rgb * uniforms.brightness, out.a);
}

```

### crates/bevy_core_pipeline/src/taa/taa

```rust
// References:
// https://www.elopezr.com/temporal-aa-and-the-quest-for-the-holy-trail
// http://behindthepixels.io/assets/files/TemporalAA.pdf
// http://leiy.cc/publications/TAA/TAA_EG2020_Talk.pdf
// https://advances.realtimerendering.com/s2014/index.html#_HIGH-QUALITY_TEMPORAL_SUPERSAMPLING

// Controls how much to blend between the current and past samples
// Lower numbers = less of the current sample and more of the past sample = more smoothing
// Values chosen empirically
const DEFAULT_HISTORY_BLEND_RATE: f32 = 0.1; // Default blend rate to use when no confidence in history
const MIN_HISTORY_BLEND_RATE: f32 = 0.015; // Minimum blend rate allowed, to ensure at least some of the current sample is used

@group(0) @binding(0) var view_target: texture_2d<f32>;
@group(0) @binding(1) var history: texture_2d<f32>;
@group(0) @binding(2) var motion_vectors: texture_2d<f32>;
@group(0) @binding(3) var depth: texture_depth_2d;
@group(0) @binding(4) var nearest_sampler: sampler;
@group(0) @binding(5) var linear_sampler: sampler;

struct Output {
    @location(0) view_target: vec4<f32>,
    @location(1) history: vec4<f32>,
};

// TAA is ideally applied after tonemapping, but before post processing
// Post processing wants to go before tonemapping, which conflicts
// Solution: Put TAA before tonemapping, tonemap TAA input, apply TAA, invert-tonemap TAA output
// https://advances.realtimerendering.com/s2014/index.html#_HIGH-QUALITY_TEMPORAL_SUPERSAMPLING, slide 20
// https://gpuopen.com/learn/optimized-reversible-tonemapper-for-resolve
fn rcp(x: f32) -> f32 { return 1.0 / x; }
fn max3(x: vec3<f32>) -> f32 { return max(x.r, max(x.g, x.b)); }
fn tonemap(color: vec3<f32>) -> vec3<f32> { return color * rcp(max3(color) + 1.0); }
fn reverse_tonemap(color: vec3<f32>) -> vec3<f32> { return color * rcp(1.0 - max3(color)); }

// The following 3 functions are from Playdead (MIT-licensed)
// https://github.com/playdeadgames/temporal/blob/master/Assets/Shaders/TemporalReprojection.shader
fn RGB_to_YCoCg(rgb: vec3<f32>) -> vec3<f32> {
    let y = (rgb.r / 4.0) + (rgb.g / 2.0) + (rgb.b / 4.0);
    let co = (rgb.r / 2.0) - (rgb.b / 2.0);
    let cg = (-rgb.r / 4.0) + (rgb.g / 2.0) - (rgb.b / 4.0);
    return vec3(y, co, cg);
}

fn YCoCg_to_RGB(ycocg: vec3<f32>) -> vec3<f32> {
    let r = ycocg.x + ycocg.y - ycocg.z;
    let g = ycocg.x + ycocg.z;
    let b = ycocg.x - ycocg.y - ycocg.z;
    return saturate(vec3(r, g, b));
}

fn clip_towards_aabb_center(history_color: vec3<f32>, current_color: vec3<f32>, aabb_min: vec3<f32>, aabb_max: vec3<f32>) -> vec3<f32> {
    let p_clip = 0.5 * (aabb_max + aabb_min);
    let e_clip = 0.5 * (aabb_max - aabb_min) + 0.00000001;
    let v_clip = history_color - p_clip;
    let v_unit = v_clip / e_clip;
    let a_unit = abs(v_unit);
    let ma_unit = max3(a_unit);
    if ma_unit > 1.0 {
        return p_clip + (v_clip / ma_unit);
    } else {
        return history_color;
    }
}

fn sample_history(u: f32, v: f32) -> vec3<f32> {
    return textureSample(history, linear_sampler, vec2(u, v)).rgb;
}

fn sample_view_target(uv: vec2<f32>) -> vec3<f32> {
    var sample = textureSample(view_target, nearest_sampler, uv).rgb;
#ifdef TONEMAP
    sample = tonemap(sample);
#endif
    return RGB_to_YCoCg(sample);
}

@fragment
fn taa(@location(0) uv: vec2<f32>) -> Output {
    let texture_size = vec2<f32>(textureDimensions(view_target));
    let texel_size = 1.0 / texture_size;

    // Fetch the current sample
    let original_color = textureSample(view_target, nearest_sampler, uv);
    var current_color = original_color.rgb;
#ifdef TONEMAP
    current_color = tonemap(current_color);
#endif

#ifndef RESET
    // Pick the closest motion_vector from 5 samples (reduces aliasing on the edges of moving entities)
    // https://advances.realtimerendering.com/s2014/index.html#_HIGH-QUALITY_TEMPORAL_SUPERSAMPLING, slide 27
    let offset = texel_size * 2.0;
    let d_uv_tl = uv + vec2(-offset.x, offset.y);
    let d_uv_tr = uv + vec2(offset.x, offset.y);
    let d_uv_bl = uv + vec2(-offset.x, -offset.y);
    let d_uv_br = uv + vec2(offset.x, -offset.y);
    var closest_uv = uv;
    let d_tl = textureSample(depth, nearest_sampler, d_uv_tl);
    let d_tr = textureSample(depth, nearest_sampler, d_uv_tr);
    var closest_depth = textureSample(depth, nearest_sampler, uv);
    let d_bl = textureSample(depth, nearest_sampler, d_uv_bl);
    let d_br = textureSample(depth, nearest_sampler, d_uv_br);
    if d_tl > closest_depth {
        closest_uv = d_uv_tl;
        closest_depth = d_tl;
    }
    if d_tr > closest_depth {
        closest_uv = d_uv_tr;
        closest_depth = d_tr;
    }
    if d_bl > closest_depth {
        closest_uv = d_uv_bl;
        closest_depth = d_bl;
    }
    if d_br > closest_depth {
        closest_uv = d_uv_br;
    }
    let closest_motion_vector = textureSample(motion_vectors, nearest_sampler, closest_uv).rg;

    // Reproject to find the equivalent sample from the past
    // Uses 5-sample Catmull-Rom filtering (reduces blurriness)
    // Catmull-Rom filtering: https://gist.github.com/TheRealMJP/c83b8c0f46b63f3a88a5986f4fa982b1
    // Ignoring corners: https://www.activision.com/cdn/research/Dynamic_Temporal_Antialiasing_and_Upsampling_in_Call_of_Duty_v4.pdf#page=68
    // Technically we should renormalize the weights since we're skipping the corners, but it's basically the same result
    let history_uv = uv - closest_motion_vector;
    let sample_position = history_uv * texture_size;
    let texel_center = floor(sample_position - 0.5) + 0.5;
    let f = sample_position - texel_center;
    let w0 = f * (-0.5 + f * (1.0 - 0.5 * f));
    let w1 = 1.0 + f * f * (-2.5 + 1.5 * f);
    let w2 = f * (0.5 + f * (2.0 - 1.5 * f));
    let w3 = f * f * (-0.5 + 0.5 * f);
    let w12 = w1 + w2;
    let texel_position_0 = (texel_center - 1.0) * texel_size;
    let texel_position_3 = (texel_center + 2.0) * texel_size;
    let texel_position_12 = (texel_center + (w2 / w12)) * texel_size;
    var history_color = sample_history(texel_position_12.x, texel_position_0.y) * w12.x * w0.y;
    history_color += sample_history(texel_position_0.x, texel_position_12.y) * w0.x * w12.y;
    history_color += sample_history(texel_position_12.x, texel_position_12.y) * w12.x * w12.y;
    history_color += sample_history(texel_position_3.x, texel_position_12.y) * w3.x * w12.y;
    history_color += sample_history(texel_position_12.x, texel_position_3.y) * w12.x * w3.y;

    // Constrain past sample with 3x3 YCoCg variance clipping (reduces ghosting)
    // YCoCg: https://advances.realtimerendering.com/s2014/index.html#_HIGH-QUALITY_TEMPORAL_SUPERSAMPLING, slide 33
    // Variance clipping: https://developer.download.nvidia.com/gameworks/events/GDC2016/msalvi_temporal_supersampling.pdf
    let s_tl = sample_view_target(uv + vec2(-texel_size.x,  texel_size.y));
    let s_tm = sample_view_target(uv + vec2( 0.0,           texel_size.y));
    let s_tr = sample_view_target(uv + vec2( texel_size.x,  texel_size.y));
    let s_ml = sample_view_target(uv + vec2(-texel_size.x,  0.0));
    let s_mm = RGB_to_YCoCg(current_color);
    let s_mr = sample_view_target(uv + vec2( texel_size.x,  0.0));
    let s_bl = sample_view_target(uv + vec2(-texel_size.x, -texel_size.y));
    let s_bm = sample_view_target(uv + vec2( 0.0,          -texel_size.y));
    let s_br = sample_view_target(uv + vec2( texel_size.x, -texel_size.y));
    let moment_1 = s_tl + s_tm + s_tr + s_ml + s_mm + s_mr + s_bl + s_bm + s_br;
    let moment_2 = (s_tl * s_tl) + (s_tm * s_tm) + (s_tr * s_tr) + (s_ml * s_ml) + (s_mm * s_mm) + (s_mr * s_mr) + (s_bl * s_bl) + (s_bm * s_bm) + (s_br * s_br);
    let mean = moment_1 / 9.0;
    let variance = (moment_2 / 9.0) - (mean * mean);
    let std_deviation = sqrt(max(variance, vec3(0.0)));
    history_color = RGB_to_YCoCg(history_color);
    history_color = clip_towards_aabb_center(history_color, s_mm, mean - std_deviation, mean + std_deviation);
    history_color = YCoCg_to_RGB(history_color);

    // How confident we are that the history is representative of the current frame
    var history_confidence = textureSample(history, nearest_sampler, uv).a;
    let pixel_motion_vector = abs(closest_motion_vector) * texture_size;
    if pixel_motion_vector.x < 0.01 && pixel_motion_vector.y < 0.01 {
        // Increment when pixels are not moving
        history_confidence += 10.0;
    } else {
        // Else reset
        history_confidence = 1.0;
    }

    // Blend current and past sample
    // Use more of the history if we're confident in it (reduces noise when there is no motion)
    // https://hhoppe.com/supersample.pdf, section 4.1
    var current_color_factor = clamp(1.0 / history_confidence, MIN_HISTORY_BLEND_RATE, DEFAULT_HISTORY_BLEND_RATE);

    // Reject history when motion vectors point off screen
    if any(saturate(history_uv) != history_uv) {
        current_color_factor = 1.0;
        history_confidence = 1.0;
    }

    current_color = mix(history_color, current_color, current_color_factor);
#endif // #ifndef RESET


    // Write output to history and view target
    var out: Output;
#ifdef RESET
    let history_confidence = 1.0 / MIN_HISTORY_BLEND_RATE;
#endif
    out.history = vec4(current_color, history_confidence);
#ifdef TONEMAP
    current_color = reverse_tonemap(current_color);
#endif
    out.view_target = vec4(current_color, original_color.a);
    return out;
}

```

### crates/bevy_core_pipeline/src/tonemapping/tonemapping_shared

```rust
#define_import_path bevy_core_pipeline::tonemapping

#import bevy_render::view::ColorGrading

// hack !! not sure what to do with this
#ifdef TONEMAPPING_PASS
    @group(0) @binding(3) var dt_lut_texture: texture_3d<f32>;
    @group(0) @binding(4) var dt_lut_sampler: sampler;
#else
    @group(0) @binding(18) var dt_lut_texture: texture_3d<f32>;
    @group(0) @binding(19) var dt_lut_sampler: sampler;
#endif

fn sample_current_lut(p: vec3<f32>) -> vec3<f32> {
    // Don't include code that will try to sample from LUTs if tonemap method doesn't require it
    // Allows this file to be imported without necessarily needing the lut texture bindings
#ifdef TONEMAP_METHOD_AGX
    return textureSampleLevel(dt_lut_texture, dt_lut_sampler, p, 0.0).rgb;
#else ifdef TONEMAP_METHOD_TONY_MC_MAPFACE
    return textureSampleLevel(dt_lut_texture, dt_lut_sampler, p, 0.0).rgb;
#else ifdef TONEMAP_METHOD_BLENDER_FILMIC
    return textureSampleLevel(dt_lut_texture, dt_lut_sampler, p, 0.0).rgb;
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
    :param color: expected sRGB primaries input
    :param saturationAmount: expected 0-1 range with 1=neutral, 0=no saturation.
    -- ref[2] [4]
*/
fn saturation(color: vec3<f32>, saturationAmount: f32) -> vec3<f32> {
    let luma = tonemapping_luminance(color);
    return mix(vec3(luma), color, vec3(saturationAmount));
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
fn convertNormalizedLog2ToOpenDomain(color: vec3<f32>, minimum_ev: f32, maximum_ev: f32) -> vec3<f32> {
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
fn applyAgXLog(Image: vec3<f32>) -> vec3<f32> {
    var prepared_image = max(vec3(0.0), Image); // clamp negatives
    let r = dot(prepared_image, vec3(0.84247906, 0.0784336, 0.07922375));
    let g = dot(prepared_image, vec3(0.04232824, 0.87846864, 0.07916613));
    let b = dot(prepared_image, vec3(0.04237565, 0.0784336, 0.87914297));
    prepared_image = vec3(r, g, b);

    prepared_image = convertOpenDomainToNormalizedLog2_(prepared_image, -10.0, 6.5);
    
    prepared_image = clamp(prepared_image, vec3(0.0), vec3(1.0));
    return prepared_image;
}

fn applyLUT3D(Image: vec3<f32>, block_size: f32) -> vec3<f32> {
    return sample_current_lut(Image * ((block_size - 1.0) / block_size) + 0.5 / block_size).rgb;
}

// -------------------------
// -------------------------
// -------------------------

fn sample_blender_filmic_lut(stimulus: vec3<f32>) -> vec3<f32> {
    let block_size = 64.0;
    let normalized = saturate(convertOpenDomainToNormalizedLog2_(stimulus, -11.0, 12.0));
    return applyLUT3D(normalized, block_size);
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
    color = applyAgXLog(color);
    color = applyLUT3D(color, 32.0);
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

// This is an **incredibly crude** approximation of the inverse of the tone mapping function.
// We assume here that there's a simple linear relationship between the input and output
// which is not true at all, but useful to at least preserve the overall luminance of colors
// when sampling from an already tonemapped image. (e.g. for transmissive materials when HDR is off)
fn approximate_inverse_tone_mapping(in: vec4<f32>, color_grading: ColorGrading) -> vec4<f32> {
    let out = tone_mapping(in, color_grading);
    let approximate_ratio = length(in.rgb) / length(out.rgb);
    return vec4(in.rgb * approximate_ratio, in.a);
}

```

### crates/bevy_core_pipeline/src/tonemapping/tonemapping

```rust
#define TONEMAPPING_PASS

#import bevy_render::view::View
#import bevy_core_pipeline::{
    fullscreen_vertex_shader::FullscreenVertexOutput,
    tonemapping::{tone_mapping, powsafe, screen_space_dither},
}

@group(0) @binding(0) var<uniform> view: View;

@group(0) @binding(1) var hdr_texture: texture_2d<f32>;
@group(0) @binding(2) var hdr_sampler: sampler;
@group(0) @binding(3) var dt_lut_texture: texture_3d<f32>;
@group(0) @binding(4) var dt_lut_sampler: sampler;

@fragment
fn fragment(in: FullscreenVertexOutput) -> @location(0) vec4<f32> {
    let hdr_color = textureSample(hdr_texture, hdr_sampler, in.uv);

    var output_rgb = tone_mapping(hdr_color, view.color_grading).rgb;

#ifdef DEBAND_DITHER
    output_rgb = powsafe(output_rgb.rgb, 1.0 / 2.2);
    output_rgb = output_rgb + screen_space_dither(in.position.xy);
    // This conversion back to linear space is required because our output texture format is
    // SRGB; the GPU will assume our output is linear and will apply an SRGB conversion.
    output_rgb = powsafe(output_rgb.rgb, 2.2);
#endif

    return vec4<f32>(output_rgb, hdr_color.a);
}

```

### crates/bevy_core_pipeline/src/fullscreen_vertex_shader/fullscreen

```rust
#define_import_path bevy_core_pipeline::fullscreen_vertex_shader

struct FullscreenVertexOutput {
    @builtin(position)
    position: vec4<f32>,
    @location(0)
    uv: vec2<f32>,
};

// This vertex shader produces the following, when drawn using indices 0..3:
//
//  1 |  0-----x.....2
//  0 |  |  s  |  . ´
// -1 |  x_____x´
// -2 |  :  .´
// -3 |  1´
//    +---------------
//      -1  0  1  2  3
//
// The axes are clip-space x and y. The region marked s is the visible region.
// The digits in the corners of the right-angled triangle are the vertex
// indices.
//
// The top-left has UV 0,0, the bottom-left has 0,2, and the top-right has 2,0.
// This means that the UV gets interpolated to 1,1 at the bottom-right corner
// of the clip-space rectangle that is at 1,-1 in clip space.
@vertex
fn fullscreen_vertex_shader(@builtin(vertex_index) vertex_index: u32) -> FullscreenVertexOutput {
    // See the explanation above for how this works
    let uv = vec2<f32>(f32(vertex_index >> 1u), f32(vertex_index & 1u)) * 2.0;
    let clip_position = vec4<f32>(uv * vec2<f32>(2.0, -2.0) + vec2<f32>(-1.0, 1.0), 0.0, 1.0);

    return FullscreenVertexOutput(clip_position, uv);
}

```

### crates/bevy_core_pipeline/src/contrast_adaptive_sharpening/robust_contrast_adaptive_sharpening

```rust
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

#import bevy_core_pipeline::fullscreen_vertex_shader::FullscreenVertexOutput

struct CASUniforms {
    sharpness: f32,
};

@group(0) @binding(0) var screenTexture: texture_2d<f32>;
@group(0) @binding(1) var samp: sampler;
@group(0) @binding(2) var<uniform> uniforms: CASUniforms;

// This is set at the limit of providing unnatural results for sharpening.
const FSR_RCAS_LIMIT = 0.1875;
// -4.0 instead of -1.0 to avoid issues with MSAA.
const peakC = vec2<f32>(10.0, -40.0);

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
    let b = textureSample(screenTexture, samp, in.uv, vec2<i32>(0, -1)).rgb;
    let d = textureSample(screenTexture, samp, in.uv, vec2<i32>(-1, 0)).rgb;
    // We need the alpha value of the pixel we're working on for the output
    let e = textureSample(screenTexture, samp, in.uv).rgbw;
    let f = textureSample(screenTexture, samp, in.uv, vec2<i32>(1, 0)).rgb;
    let h = textureSample(screenTexture, samp, in.uv, vec2<i32>(0, 1)).rgb;
    // Min and max of ring.
    let mn4 = min(min(b, d), min(f, h));
    let mx4 = max(max(b, d), max(f, h));
    // Limiters
    // 4.0 to avoid issues with MSAA.
    let hitMin = mn4 / (4.0 * mx4);
    let hitMax = (peakC.x - mx4) / (peakC.y + 4.0 * mn4);
    let lobeRGB = max(-hitMin, hitMax);
    var lobe = max(-FSR_RCAS_LIMIT, min(0.0, max(lobeRGB.r, max(lobeRGB.g, lobeRGB.b)))) * uniforms.sharpness;
#ifdef RCAS_DENOISE
    // Luma times 2.
    let bL = b.b * 0.5 + (b.r * 0.5 + b.g);
    let dL = d.b * 0.5 + (d.r * 0.5 + d.g);
    let eL = e.b * 0.5 + (e.r * 0.5 + e.g);
    let fL = f.b * 0.5 + (f.r * 0.5 + f.g);
    let hL = h.b * 0.5 + (h.r * 0.5 + h.g);
    // Noise detection.
    var noise = 0.25 * bL + 0.25 * dL + 0.25 * fL + 0.25 * hL - eL;;
    noise = saturate(abs(noise) / (max(max(bL, dL), max(fL, hL)) - min(min(bL, dL), min(fL, hL))));
    noise = 1.0 - 0.5 * noise;
    // Apply noise removal.
    lobe *= noise;
#endif
    return vec4<f32>((lobe * b + lobe * d + lobe * f + lobe * h + e.rgb) / (4.0 * lobe + 1.0), e.w);
}

```

### crates/bevy_core_pipeline/src/deferred/copy_deferred_lighting_id

```rust
#import bevy_core_pipeline::fullscreen_vertex_shader::FullscreenVertexOutput

@group(0) @binding(0)
var material_id_texture: texture_2d<u32>;

struct FragmentOutput {
    @builtin(frag_depth) frag_depth: f32,

}

@fragment
fn fragment(in: FullscreenVertexOutput) -> FragmentOutput {
    var out: FragmentOutput;
    // Depth is stored as unorm, so we are dividing the u8 by 255.0 here.
    out.frag_depth = f32(textureLoad(material_id_texture, vec2<i32>(in.position.xy), 0).x) / 255.0;
    return out;
}


```

### crates/bevy_core_pipeline/src/blit/blit

```rust
#import bevy_core_pipeline::fullscreen_vertex_shader::FullscreenVertexOutput

@group(0) @binding(0) var in_texture: texture_2d<f32>;
@group(0) @binding(1) var in_sampler: sampler;

@fragment
fn fs_main(in: FullscreenVertexOutput) -> @location(0) vec4<f32> {
    return textureSample(in_texture, in_sampler, in.uv);
}

```

### crates/bevy_render/src/globals

```rust
#define_import_path bevy_render::globals

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

### crates/bevy_render/src/maths

```rust
#define_import_path bevy_render::maths

fn affine2_to_square(affine: mat3x2<f32>) -> mat3x3<f32> {
    return mat3x3<f32>(
        vec3<f32>(affine[0].xy, 0.0),
        vec3<f32>(affine[1].xy, 0.0),
        vec3<f32>(affine[2].xy, 1.0),
    );
}

fn affine3_to_square(affine: mat3x4<f32>) -> mat4x4<f32> {
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

// Extracts the square portion of an affine matrix: i.e. discards the
// translation.
fn affine3_to_mat3x3(affine: mat4x3<f32>) -> mat3x3<f32> {
    return mat3x3<f32>(affine[0].xyz, affine[1].xyz, affine[2].xyz);
}

// Returns the inverse of a 3x3 matrix.
fn inverse_mat3x3(matrix: mat3x3<f32>) -> mat3x3<f32> {
    let tmp0 = cross(matrix[1], matrix[2]);
    let tmp1 = cross(matrix[2], matrix[0]);
    let tmp2 = cross(matrix[0], matrix[1]);
    let inv_det = 1.0 / dot(matrix[2], tmp2);
    return transpose(mat3x3<f32>(tmp0 * inv_det, tmp1 * inv_det, tmp2 * inv_det));
}

// Returns the inverse of an affine matrix.
//
// https://en.wikipedia.org/wiki/Affine_transformation#Groups
fn inverse_affine3(affine: mat4x3<f32>) -> mat4x3<f32> {
    let matrix3 = affine3_to_mat3x3(affine);
    let inv_matrix3 = inverse_mat3x3(matrix3);
    return mat4x3<f32>(inv_matrix3[0], inv_matrix3[1], inv_matrix3[2], -(inv_matrix3 * affine[3]));
}

// Creates an orthonormal basis given a Z vector and an up vector (which becomes
// Y after orthonormalization).
//
// The results are equivalent to the Gram-Schmidt process [1].
//
// [1]: https://math.stackexchange.com/a/1849294
fn orthonormalize(z_unnormalized: vec3<f32>, up: vec3<f32>) -> mat3x3<f32> {
    let z_basis = normalize(z_unnormalized);
    let x_basis = normalize(cross(z_basis, up));
    let y_basis = cross(z_basis, x_basis);
    return mat3x3(x_basis, y_basis, z_basis);
}

```

### crates/bevy_render/src/view/view

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
    exposure: f32,
    // viewport(x_origin, y_origin, width, height)
    viewport: vec4<f32>,
    frustum: array<vec4<f32>, 6>,
    color_grading: ColorGrading,
    mip_bias: f32,
    render_layers: u32,
};

```

### crates/bevy_render/src/view/window/screenshot

```rust
// This vertex shader will create a triangle that will cover the entire screen
// with minimal effort, avoiding the need for a vertex buffer etc.
@vertex
fn vs_main(@builtin(vertex_index) in_vertex_index: u32) -> @builtin(position) vec4<f32> {
    let x = f32((in_vertex_index & 1u) << 2u);
    let y = f32((in_vertex_index & 2u) << 1u);
    return vec4<f32>(x - 1.0, y - 1.0, 0.0, 1.0);
}

@group(0) @binding(0) var t: texture_2d<f32>;

@fragment
fn fs_main(@builtin(position) pos: vec4<f32>) -> @location(0) vec4<f32> {
    let coords = floor(pos.xy);
    return textureLoad(t, vec2<i32>(coords), 0i);
}

```

### crates/bevy_pbr/src/render/pbr_functions

```rust
#define_import_path bevy_pbr::pbr_functions

#import bevy_pbr::{
    pbr_types,
    pbr_bindings,
    mesh_view_bindings as view_bindings,
    mesh_view_types,
    lighting,
    transmission,
    clustered_forward as clustering,
    shadows,
    ambient,
    irradiance_volume,
    mesh_types::{MESH_FLAGS_SHADOW_RECEIVER_BIT, MESH_FLAGS_TRANSMITTED_SHADOW_RECEIVER_BIT},
    utils::E,
}

#ifdef ENVIRONMENT_MAP
#import bevy_pbr::environment_map
#endif

#import bevy_core_pipeline::tonemapping::{screen_space_dither, powsafe, tone_mapping}

fn alpha_discard(material: pbr_types::StandardMaterial, output_color: vec4<f32>) -> vec4<f32> {
    var color = output_color;
    let alpha_mode = material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_ALPHA_MODE_RESERVED_BITS;
    if alpha_mode == pbr_types::STANDARD_MATERIAL_FLAGS_ALPHA_MODE_OPAQUE {
        // NOTE: If rendering as opaque, alpha should be ignored so set to 1.0
        color.a = 1.0;
    }

#ifdef MAY_DISCARD
    // NOTE: `MAY_DISCARD` is only defined in the alpha to coverage case if MSAA
    // was off. This special situation causes alpha to coverage to fall back to
    // alpha mask.
    else if alpha_mode == pbr_types::STANDARD_MATERIAL_FLAGS_ALPHA_MODE_MASK ||
            alpha_mode == pbr_types::STANDARD_MATERIAL_FLAGS_ALPHA_MODE_ALPHA_TO_COVERAGE {
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
#ifndef STANDARD_MATERIAL_NORMAL_MAP
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
    double_sided: bool,
    is_front: bool,
#ifdef VERTEX_TANGENTS
#ifdef STANDARD_MATERIAL_NORMAL_MAP
    world_tangent: vec4<f32>,
#endif
#endif
#ifdef VERTEX_UVS
    uv: vec2<f32>,
#endif
    mip_bias: f32,
#ifdef MESHLET_MESH_MATERIAL_PASS
    ddx_uv: vec2<f32>,
    ddy_uv: vec2<f32>,
#endif
) -> vec3<f32> {
    // NOTE: The mikktspace method of normal mapping explicitly requires that the world normal NOT
    // be re-normalized in the fragment shader. This is primarily to match the way mikktspace
    // bakes vertex tangents and normal maps so that this is the exact inverse. Blender, Unity,
    // Unreal Engine, Godot, and more all use the mikktspace method. Do not change this code
    // unless you really know what you are doing.
    // http://www.mikktspace.com/
    var N: vec3<f32> = world_normal;

#ifdef VERTEX_TANGENTS
#ifdef STANDARD_MATERIAL_NORMAL_MAP
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
#ifdef STANDARD_MATERIAL_NORMAL_MAP
    // Nt is the tangent-space normal.
#ifdef MESHLET_MESH_MATERIAL_PASS
    var Nt = textureSampleGrad(pbr_bindings::normal_map_texture, pbr_bindings::normal_map_sampler, uv, ddx_uv, ddy_uv).rgb;
#else
    var Nt = textureSampleBias(pbr_bindings::normal_map_texture, pbr_bindings::normal_map_sampler, uv, mip_bias).rgb;
#endif
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

    if double_sided && !is_front {
        Nt = -Nt;
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
        // Only valid for a perspective projection
        V = normalize(view_bindings::view.world_position.xyz - world_position.xyz);
    }
    return V;
}

#ifndef PREPASS_FRAGMENT
fn apply_pbr_lighting(
    in: pbr_types::PbrInput,
) -> vec4<f32> {
    var output_color: vec4<f32> = in.material.base_color;

    // TODO use .a for exposure compensation in HDR
    let emissive = in.material.emissive;

    // calculate non-linear roughness from linear perceptualRoughness
    let metallic = in.material.metallic;
    let perceptual_roughness = in.material.perceptual_roughness;
    let roughness = lighting::perceptualRoughnessToRoughness(perceptual_roughness);
    let ior = in.material.ior;
    let thickness = in.material.thickness;
    let diffuse_transmission = in.material.diffuse_transmission;
    let specular_transmission = in.material.specular_transmission;

    let specular_transmissive_color = specular_transmission * in.material.base_color.rgb;

    let diffuse_occlusion = in.diffuse_occlusion;
    let specular_occlusion = in.specular_occlusion;

    // Neubelt and Pettineo 2013, "Crafting a Next-gen Material Pipeline for The Order: 1886"
    let NdotV = max(dot(in.N, in.V), 0.0001);

    // Remapping [0,1] reflectance to F0
    // See https://google.github.io/filament/Filament.html#materialsystem/parameterization/remapping
    let reflectance = in.material.reflectance;
    let F0 = 0.16 * reflectance * reflectance * (1.0 - metallic) + output_color.rgb * metallic;

    // Diffuse strength is inversely related to metallicity, specular and diffuse transmission
    let diffuse_color = output_color.rgb * (1.0 - metallic) * (1.0 - specular_transmission) * (1.0 - diffuse_transmission);

    // Diffuse transmissive strength is inversely related to metallicity and specular transmission, but directly related to diffuse transmission
    let diffuse_transmissive_color = output_color.rgb * (1.0 - metallic) * (1.0 - specular_transmission) * diffuse_transmission;

    // Calculate the world position of the second Lambertian lobe used for diffuse transmission, by subtracting material thickness
    let diffuse_transmissive_lobe_world_position = in.world_position - vec4<f32>(in.world_normal, 0.0) * thickness;

    let R = reflect(-in.V, in.N);

    let f_ab = lighting::F_AB(perceptual_roughness, NdotV);

    var direct_light: vec3<f32> = vec3<f32>(0.0);

    // Transmitted Light (Specular and Diffuse)
    var transmitted_light: vec3<f32> = vec3<f32>(0.0);

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

#ifdef STANDARD_MATERIAL_DIFFUSE_TRANSMISSION
        // NOTE: We use the diffuse transmissive color, the second Lambertian lobe's calculated
        // world position, inverted normal and view vectors, and the following simplified
        // values for a fully diffuse transmitted light contribution approximation:
        //
        // roughness = 1.0;
        // NdotV = 1.0;
        // R = vec3<f32>(0.0) // doesn't really matter
        // f_ab = vec2<f32>(0.1)
        // F0 = vec3<f32>(0.0)
        var transmitted_shadow: f32 = 1.0;
        if ((in.flags & (MESH_FLAGS_SHADOW_RECEIVER_BIT | MESH_FLAGS_TRANSMITTED_SHADOW_RECEIVER_BIT)) == (MESH_FLAGS_SHADOW_RECEIVER_BIT | MESH_FLAGS_TRANSMITTED_SHADOW_RECEIVER_BIT)
                && (view_bindings::point_lights.data[light_id].flags & mesh_view_types::POINT_LIGHT_FLAGS_SHADOWS_ENABLED_BIT) != 0u) {
            transmitted_shadow = shadows::fetch_point_shadow(light_id, diffuse_transmissive_lobe_world_position, -in.world_normal);
        }
        let transmitted_light_contrib = lighting::point_light(diffuse_transmissive_lobe_world_position.xyz, light_id, 1.0, 1.0, -in.N, -in.V, vec3<f32>(0.0), vec3<f32>(0.0), vec2<f32>(0.1), diffuse_transmissive_color);
        transmitted_light += transmitted_light_contrib * transmitted_shadow;
#endif
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

#ifdef STANDARD_MATERIAL_DIFFUSE_TRANSMISSION
        // NOTE: We use the diffuse transmissive color, the second Lambertian lobe's calculated
        // world position, inverted normal and view vectors, and the following simplified
        // values for a fully diffuse transmitted light contribution approximation:
        //
        // roughness = 1.0;
        // NdotV = 1.0;
        // R = vec3<f32>(0.0) // doesn't really matter
        // f_ab = vec2<f32>(0.1)
        // F0 = vec3<f32>(0.0)
        var transmitted_shadow: f32 = 1.0;
        if ((in.flags & (MESH_FLAGS_SHADOW_RECEIVER_BIT | MESH_FLAGS_TRANSMITTED_SHADOW_RECEIVER_BIT)) == (MESH_FLAGS_SHADOW_RECEIVER_BIT | MESH_FLAGS_TRANSMITTED_SHADOW_RECEIVER_BIT)
                && (view_bindings::point_lights.data[light_id].flags & mesh_view_types::POINT_LIGHT_FLAGS_SHADOWS_ENABLED_BIT) != 0u) {
            transmitted_shadow = shadows::fetch_spot_shadow(light_id, diffuse_transmissive_lobe_world_position, -in.world_normal);
        }
        let transmitted_light_contrib = lighting::spot_light(diffuse_transmissive_lobe_world_position.xyz, light_id, 1.0, 1.0, -in.N, -in.V, vec3<f32>(0.0), vec3<f32>(0.0), vec2<f32>(0.1), diffuse_transmissive_color);
        transmitted_light += transmitted_light_contrib * transmitted_shadow;
#endif
    }

    // directional lights (direct)
    let n_directional_lights = view_bindings::lights.n_directional_lights;
    for (var i: u32 = 0u; i < n_directional_lights; i = i + 1u) {
        // check the directional light render layers intersect the view render layers
        // note this is not necessary for point and spot lights, as the relevant lights are filtered in `assign_lights_to_clusters`
        let light = &view_bindings::lights.directional_lights[i];
        if ((*light).render_layers & view_bindings::view.render_layers) == 0u {
            continue;
        }

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

#ifdef STANDARD_MATERIAL_DIFFUSE_TRANSMISSION
        // NOTE: We use the diffuse transmissive color, the second Lambertian lobe's calculated
        // world position, inverted normal and view vectors, and the following simplified
        // values for a fully diffuse transmitted light contribution approximation:
        //
        // roughness = 1.0;
        // NdotV = 1.0;
        // R = vec3<f32>(0.0) // doesn't really matter
        // f_ab = vec2<f32>(0.1)
        // F0 = vec3<f32>(0.0)
        var transmitted_shadow: f32 = 1.0;
        if ((in.flags & (MESH_FLAGS_SHADOW_RECEIVER_BIT | MESH_FLAGS_TRANSMITTED_SHADOW_RECEIVER_BIT)) == (MESH_FLAGS_SHADOW_RECEIVER_BIT | MESH_FLAGS_TRANSMITTED_SHADOW_RECEIVER_BIT)
                && (view_bindings::lights.directional_lights[i].flags & mesh_view_types::DIRECTIONAL_LIGHT_FLAGS_SHADOWS_ENABLED_BIT) != 0u) {
            transmitted_shadow = shadows::fetch_directional_shadow(i, diffuse_transmissive_lobe_world_position, -in.world_normal, view_z);
        }
        let transmitted_light_contrib = lighting::directional_light(i, 1.0, 1.0, -in.N, -in.V, vec3<f32>(0.0), vec3<f32>(0.0), vec2<f32>(0.1), diffuse_transmissive_color);
        transmitted_light += transmitted_light_contrib * transmitted_shadow;
#endif
    }

    var indirect_light = vec3(0.0f);

#ifdef STANDARD_MATERIAL_DIFFUSE_TRANSMISSION
    // NOTE: We use the diffuse transmissive color, the second Lambertian lobe's calculated
    // world position, inverted normal and view vectors, and the following simplified
    // values for a fully diffuse transmitted light contribution approximation:
    //
    // perceptual_roughness = 1.0;
    // NdotV = 1.0;
    // F0 = vec3<f32>(0.0)
    // diffuse_occlusion = vec3<f32>(1.0)
    transmitted_light += ambient::ambient_light(diffuse_transmissive_lobe_world_position, -in.N, -in.V, 1.0, diffuse_transmissive_color, vec3<f32>(0.0), 1.0, vec3<f32>(1.0));
#endif

    // Diffuse indirect lighting can come from a variety of sources. The
    // priority goes like this:
    //
    // 1. Lightmap (highest)
    // 2. Irradiance volume
    // 3. Environment map (lowest)
    //
    // When we find a source of diffuse indirect lighting, we stop accumulating
    // any more diffuse indirect light. This avoids double-counting if, for
    // example, both lightmaps and irradiance volumes are present.

#ifdef LIGHTMAP
    if (all(indirect_light == vec3(0.0f))) {
        indirect_light += in.lightmap_light * diffuse_color;
    }
#endif

#ifdef IRRADIANCE_VOLUME {
    // Irradiance volume light (indirect)
    if (all(indirect_light == vec3(0.0f))) {
        let irradiance_volume_light = irradiance_volume::irradiance_volume_light(
            in.world_position.xyz, in.N);
        indirect_light += irradiance_volume_light * diffuse_color * diffuse_occlusion;
    }
#endif

    // Environment map light (indirect)
    //
    // Note that up until this point, we have only accumulated diffuse light.
    // This call is the first call that can accumulate specular light.
#ifdef ENVIRONMENT_MAP
    let environment_light = environment_map::environment_map_light(
        perceptual_roughness,
        roughness,
        diffuse_color,
        NdotV,
        f_ab,
        in.N,
        R,
        F0,
        in.world_position.xyz,
        any(indirect_light != vec3(0.0f)));

    indirect_light += environment_light.diffuse * diffuse_occlusion +
        environment_light.specular * specular_occlusion;

    // we'll use the specular component of the transmitted environment
    // light in the call to `specular_transmissive_light()` below
    var specular_transmitted_environment_light = vec3<f32>(0.0);

#ifdef STANDARD_MATERIAL_SPECULAR_OR_DIFFUSE_TRANSMISSION
    // NOTE: We use the diffuse transmissive color, inverted normal and view vectors,
    // and the following simplified values for the transmitted environment light contribution
    // approximation:
    //
    // diffuse_color = vec3<f32>(1.0) // later we use `diffuse_transmissive_color` and `specular_transmissive_color`
    // NdotV = 1.0;
    // R = T // see definition below
    // F0 = vec3<f32>(1.0)
    // diffuse_occlusion = 1.0
    //
    // (This one is slightly different from the other light types above, because the environment
    // map light returns both diffuse and specular components separately, and we want to use both)

    let T = -normalize(
        in.V + // start with view vector at entry point
        refract(in.V, -in.N, 1.0 / ior) * thickness // add refracted vector scaled by thickness, towards exit point
    ); // normalize to find exit point view vector

    let transmitted_environment_light = bevy_pbr::environment_map::environment_map_light(
        perceptual_roughness,
        roughness,
        vec3<f32>(1.0),
        1.0,
        f_ab,
        -in.N,
        T,
        vec3<f32>(1.0),
        in.world_position.xyz,
        false);
#ifdef STANDARD_MATERIAL_DIFFUSE_TRANSMISSION
    transmitted_light += transmitted_environment_light.diffuse * diffuse_transmissive_color;
#endif
#ifdef STANDARD_MATERIAL_SPECULAR_TRANSMISSION
    specular_transmitted_environment_light = transmitted_environment_light.specular * specular_transmissive_color;
#endif
#endif // STANDARD_MATERIAL_SPECULAR_OR_DIFFUSE_TRANSMISSION
#else
    // If there's no environment map light, there's no transmitted environment
    // light specular component, so we can just hardcode it to zero.
    let specular_transmitted_environment_light = vec3<f32>(0.0);
#endif

    // Ambient light (indirect)
    indirect_light += ambient::ambient_light(in.world_position, in.N, in.V, NdotV, diffuse_color, F0, perceptual_roughness, diffuse_occlusion);

    let emissive_light = emissive.rgb * output_color.a;

#ifdef STANDARD_MATERIAL_SPECULAR_TRANSMISSION
    transmitted_light += transmission::specular_transmissive_light(in.world_position, in.frag_coord.xyz, view_z, in.N, in.V, F0, ior, thickness, perceptual_roughness, specular_transmissive_color, specular_transmitted_environment_light).rgb;

    if (in.material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_ATTENUATION_ENABLED_BIT) != 0u {
        // We reuse the `atmospheric_fog()` function here, as it's fundamentally
        // equivalent to the attenuation that takes place inside the material volume,
        // and will allow us to eventually hook up subsurface scattering more easily
        var attenuation_fog: mesh_view_types::Fog;
        attenuation_fog.base_color.a = 1.0;
        attenuation_fog.be = pow(1.0 - in.material.attenuation_color.rgb, vec3<f32>(E)) / in.material.attenuation_distance;
        // TODO: Add the subsurface scattering factor below
        // attenuation_fog.bi = /* ... */
        transmitted_light = bevy_pbr::fog::atmospheric_fog(
            attenuation_fog, vec4<f32>(transmitted_light, 1.0), thickness,
            vec3<f32>(0.0) // TODO: Pass in (pre-attenuated) scattered light contribution here
        ).rgb;
    }
#endif

    // Total light
    output_color = vec4<f32>(
        view_bindings::view.exposure * (transmitted_light + direct_light + indirect_light + emissive_light),
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
            ) * light.color.rgb * view_bindings::view.exposure;
        }
    }

    if fog_params.mode == mesh_view_types::FOG_MODE_LINEAR {
        return bevy_pbr::fog::linear_fog(fog_params, input_color, distance, scattering);
    } else if fog_params.mode == mesh_view_types::FOG_MODE_EXPONENTIAL {
        return bevy_pbr::fog::exponential_fog(fog_params, input_color, distance, scattering);
    } else if fog_params.mode == mesh_view_types::FOG_MODE_EXPONENTIAL_SQUARED {
        return bevy_pbr::fog::exponential_squared_fog(fog_params, input_color, distance, scattering);
    } else if fog_params.mode == mesh_view_types::FOG_MODE_ATMOSPHERIC {
        return bevy_pbr::fog::atmospheric_fog(fog_params, input_color, distance, scattering);
    } else {
        return input_color;
    }
}

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

// fog, alpha premultiply
// for non-hdr cameras, tonemapping and debanding
fn main_pass_post_lighting_processing(
    pbr_input: pbr_types::PbrInput,
    input_color: vec4<f32>,
) -> vec4<f32> {
    var output_color = input_color;

    // fog
    if (view_bindings::fog.mode != mesh_view_types::FOG_MODE_OFF && (pbr_input.material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_FOG_ENABLED_BIT) != 0u) {
        output_color = apply_fog(view_bindings::fog, output_color, pbr_input.world_position.xyz, view_bindings::view.world_position.xyz);
    }

#ifdef TONEMAP_IN_SHADER
    output_color = tone_mapping(output_color, view_bindings::view.color_grading);
#ifdef DEBAND_DITHER
    var output_rgb = output_color.rgb;
    output_rgb = powsafe(output_rgb, 1.0 / 2.2);
    output_rgb += screen_space_dither(pbr_input.frag_coord.xy);
    // This conversion back to linear space is required because our output texture format is
    // SRGB; the GPU will assume our output is linear and will apply an SRGB conversion.
    output_rgb = powsafe(output_rgb, 2.2);
    output_color = vec4(output_rgb, output_color.a);
#endif
#endif
#ifdef PREMULTIPLY_ALPHA
    output_color = premultiply_alpha(pbr_input.material.flags, output_color);
#endif
    return output_color;
}

```

### crates/bevy_pbr/src/render/pbr

```rust
#import bevy_pbr::{
    pbr_functions::alpha_discard,
    pbr_fragment::pbr_input_from_standard_material,
}

#ifdef PREPASS_PIPELINE
#import bevy_pbr::{
    prepass_io::{VertexOutput, FragmentOutput},
    pbr_deferred_functions::deferred_output,
}
#else
#import bevy_pbr::{
    forward_io::{VertexOutput, FragmentOutput},
    pbr_functions::{apply_pbr_lighting, main_pass_post_lighting_processing},
    pbr_types::STANDARD_MATERIAL_FLAGS_UNLIT_BIT,
}
#endif

#ifdef MESHLET_MESH_MATERIAL_PASS
#import bevy_pbr::meshlet_visibility_buffer_resolve::resolve_vertex_output
#endif

@fragment
fn fragment(
#ifdef MESHLET_MESH_MATERIAL_PASS
    @builtin(position) frag_coord: vec4<f32>,
#else
    in: VertexOutput,
    @builtin(front_facing) is_front: bool,
#endif
) -> FragmentOutput {
#ifdef MESHLET_MESH_MATERIAL_PASS
    let in = resolve_vertex_output(frag_coord);
    let is_front = true;
#endif

    // generate a PbrInput struct from the StandardMaterial bindings
    var pbr_input = pbr_input_from_standard_material(in, is_front);

    // alpha discard
    pbr_input.material.base_color = alpha_discard(pbr_input.material, pbr_input.material.base_color);

#ifdef PREPASS_PIPELINE
    // write the gbuffer, lighting pass id, and optionally normal and motion_vector textures
    let out = deferred_output(in, pbr_input);
#else
    // in forward mode, we calculate the lit color immediately, and then apply some post-lighting effects here.
    // in deferred mode the lit color and these effects will be calculated in the deferred lighting shader
    var out: FragmentOutput;
    if (pbr_input.material.flags & STANDARD_MATERIAL_FLAGS_UNLIT_BIT) == 0u {
        out.color = apply_pbr_lighting(pbr_input);
    } else {
        out.color = pbr_input.material.base_color;
    }

    // apply in-shader post processing (fog, alpha-premultiply, and also tonemapping, debanding if the camera is non-hdr)
    // note this does not include fullscreen postprocessing effects like bloom.
    out.color = main_pass_post_lighting_processing(pbr_input, out.color);
#endif

    return out;
}

```

### crates/bevy_pbr/src/render/pbr_lighting

```rust
#define_import_path bevy_pbr::lighting

#import bevy_pbr::{
    utils::PI,
    mesh_view_types::POINT_LIGHT_FLAGS_SPOT_LIGHT_Y_NEGATIVE,
    mesh_view_bindings as view_bindings,
}

// From the Filament design doc
// https://google.github.io/filament/Filament.html#table_symbols
// Symbol Definition
// v    View unit vector
// l    Incident light unit vector
// n    Surface normal unit vector
// h    Half unit vector between l and v
// f    BRDF
// f_d    Diffuse component of a BRDF
// f_r    Specular component of a BRDF
// α    Roughness, remapped from using input perceptualRoughness
// σ    Diffuse reflectance
// Ω    Spherical domain
// f0    Reflectance at normal incidence
// f90    Reflectance at grazing angle
// χ+(a)    Heaviside function (1 if a>0 and 0 otherwise)
// nior    Index of refraction (IOR) of an interface
// ⟨n⋅l⟩    Dot product clamped to [0..1]
// ⟨a⟩    Saturated value (clamped to [0..1])

// The Bidirectional Reflectance Distribution Function (BRDF) describes the surface response of a standard material
// and consists of two components, the diffuse component (f_d) and the specular component (f_r):
// f(v,l) = f_d(v,l) + f_r(v,l)
//
// The form of the microfacet model is the same for diffuse and specular
// f_r(v,l) = f_d(v,l) = 1 / { |n⋅v||n⋅l| } ∫_Ω D(m,α) G(v,l,m) f_m(v,l,m) (v⋅m) (l⋅m) dm
//
// In which:
// D, also called the Normal Distribution Function (NDF) models the distribution of the microfacets
// G models the visibility (or occlusion or shadow-masking) of the microfacets
// f_m is the microfacet BRDF and differs between specular and diffuse components
//
// The above integration needs to be approximated.

// distanceAttenuation is simply the square falloff of light intensity
// combined with a smooth attenuation at the edge of the light radius
//
// light radius is a non-physical construct for efficiency purposes,
// because otherwise every light affects every fragment in the scene
fn getDistanceAttenuation(distanceSquare: f32, inverseRangeSquared: f32) -> f32 {
    let factor = distanceSquare * inverseRangeSquared;
    let smoothFactor = saturate(1.0 - factor * factor);
    let attenuation = smoothFactor * smoothFactor;
    return attenuation * 1.0 / max(distanceSquare, 0.0001);
}

// Normal distribution function (specular D)
// Based on https://google.github.io/filament/Filament.html#citation-walter07

// D_GGX(h,α) = α^2 / { π ((n⋅h)^2 (α2−1) + 1)^2 }

// Simple implementation, has precision problems when using fp16 instead of fp32
// see https://google.github.io/filament/Filament.html#listing_speculardfp16
fn D_GGX(roughness: f32, NoH: f32, h: vec3<f32>) -> f32 {
    let oneMinusNoHSquared = 1.0 - NoH * NoH;
    let a = NoH * roughness;
    let k = roughness / (oneMinusNoHSquared + a * a);
    let d = k * k * (1.0 / PI);
    return d;
}

// Visibility function (Specular G)
// V(v,l,a) = G(v,l,α) / { 4 (n⋅v) (n⋅l) }
// such that f_r becomes
// f_r(v,l) = D(h,α) V(v,l,α) F(v,h,f0)
// where
// V(v,l,α) = 0.5 / { n⋅l sqrt((n⋅v)^2 (1−α2) + α2) + n⋅v sqrt((n⋅l)^2 (1−α2) + α2) }
// Note the two sqrt's, that may be slow on mobile, see https://google.github.io/filament/Filament.html#listing_approximatedspecularv
fn V_SmithGGXCorrelated(roughness: f32, NoV: f32, NoL: f32) -> f32 {
    let a2 = roughness * roughness;
    let lambdaV = NoL * sqrt((NoV - a2 * NoV) * NoV + a2);
    let lambdaL = NoV * sqrt((NoL - a2 * NoL) * NoL + a2);
    let v = 0.5 / (lambdaV + lambdaL);
    return v;
}

// Fresnel function
// see https://google.github.io/filament/Filament.html#citation-schlick94
// F_Schlick(v,h,f_0,f_90) = f_0 + (f_90 − f_0) (1 − v⋅h)^5
fn F_Schlick_vec(f0: vec3<f32>, f90: f32, VoH: f32) -> vec3<f32> {
    // not using mix to keep the vec3 and float versions identical
    return f0 + (f90 - f0) * pow(1.0 - VoH, 5.0);
}

fn F_Schlick(f0: f32, f90: f32, VoH: f32) -> f32 {
    // not using mix to keep the vec3 and float versions identical
    return f0 + (f90 - f0) * pow(1.0 - VoH, 5.0);
}

fn fresnel(f0: vec3<f32>, LoH: f32) -> vec3<f32> {
    // f_90 suitable for ambient occlusion
    // see https://google.github.io/filament/Filament.html#lighting/occlusion
    let f90 = saturate(dot(f0, vec3<f32>(50.0 * 0.33)));
    return F_Schlick_vec(f0, f90, LoH);
}

// Specular BRDF
// https://google.github.io/filament/Filament.html#materialsystem/specularbrdf

// Cook-Torrance approximation of the microfacet model integration using Fresnel law F to model f_m
// f_r(v,l) = { D(h,α) G(v,l,α) F(v,h,f0) } / { 4 (n⋅v) (n⋅l) }
fn specular(
    f0: vec3<f32>,
    roughness: f32,
    h: vec3<f32>,
    NoV: f32,
    NoL: f32,
    NoH: f32,
    LoH: f32,
    specularIntensity: f32,
    f_ab: vec2<f32>
) -> vec3<f32> {
    let D = D_GGX(roughness, NoH, h);
    let V = V_SmithGGXCorrelated(roughness, NoV, NoL);
    let F = fresnel(f0, LoH);

    var Fr = (specularIntensity * D * V) * F;

    // Multiscattering approximation: https://google.github.io/filament/Filament.html#listing_energycompensationimpl
    Fr *= 1.0 + f0 * (1.0 / f_ab.x - 1.0);

    return Fr;
}

// Diffuse BRDF
// https://google.github.io/filament/Filament.html#materialsystem/diffusebrdf
// fd(v,l) = σ/π * 1 / { |n⋅v||n⋅l| } ∫Ω D(m,α) G(v,l,m) (v⋅m) (l⋅m) dm
//
// simplest approximation
// float Fd_Lambert() {
//     return 1.0 / PI;
// }
//
// vec3 Fd = diffuseColor * Fd_Lambert();
//
// Disney approximation
// See https://google.github.io/filament/Filament.html#citation-burley12
// minimal quality difference
fn Fd_Burley(roughness: f32, NoV: f32, NoL: f32, LoH: f32) -> f32 {
    let f90 = 0.5 + 2.0 * roughness * LoH * LoH;
    let lightScatter = F_Schlick(1.0, f90, NoL);
    let viewScatter = F_Schlick(1.0, f90, NoV);
    return lightScatter * viewScatter * (1.0 / PI);
}

// Scale/bias approximation
// https://www.unrealengine.com/en-US/blog/physically-based-shading-on-mobile
// TODO: Use a LUT (more accurate)
fn F_AB(perceptual_roughness: f32, NoV: f32) -> vec2<f32> {
    let c0 = vec4<f32>(-1.0, -0.0275, -0.572, 0.022);
    let c1 = vec4<f32>(1.0, 0.0425, 1.04, -0.04);
    let r = perceptual_roughness * c0 + c1;
    let a004 = min(r.x * r.x, exp2(-9.28 * NoV)) * r.x + r.y;
    return vec2<f32>(-1.04, 1.04) * a004 + r.zw;
}

fn EnvBRDFApprox(f0: vec3<f32>, f_ab: vec2<f32>) -> vec3<f32> {
    return f0 * f_ab.x + f_ab.y;
}

fn perceptualRoughnessToRoughness(perceptualRoughness: f32) -> f32 {
    // clamp perceptual roughness to prevent precision problems
    // According to Filament design 0.089 is recommended for mobile
    // Filament uses 0.045 for non-mobile
    let clampedPerceptualRoughness = clamp(perceptualRoughness, 0.089, 1.0);
    return clampedPerceptualRoughness * clampedPerceptualRoughness;
}

fn point_light(
    world_position: vec3<f32>,
    light_id: u32,
    roughness: f32,
    NdotV: f32,
    N: vec3<f32>,
    V: vec3<f32>,
    R: vec3<f32>,
    F0: vec3<f32>,
    f_ab: vec2<f32>,
    diffuseColor: vec3<f32>
) -> vec3<f32> {
    let light = &view_bindings::point_lights.data[light_id];
    let light_to_frag = (*light).position_radius.xyz - world_position.xyz;
    let distance_square = dot(light_to_frag, light_to_frag);
    let rangeAttenuation = getDistanceAttenuation(distance_square, (*light).color_inverse_square_range.w);

    // Specular.
    // Representative Point Area Lights.
    // see http://blog.selfshadow.com/publications/s2013-shading-course/karis/s2013_pbs_epic_notes_v2.pdf p14-16
    let a = roughness;
    let centerToRay = dot(light_to_frag, R) * R - light_to_frag;
    let closestPoint = light_to_frag + centerToRay * saturate((*light).position_radius.w * inverseSqrt(dot(centerToRay, centerToRay)));
    let LspecLengthInverse = inverseSqrt(dot(closestPoint, closestPoint));
    let normalizationFactor = a / saturate(a + ((*light).position_radius.w * 0.5 * LspecLengthInverse));
    let specularIntensity = normalizationFactor * normalizationFactor;

    var L: vec3<f32> = closestPoint * LspecLengthInverse; // normalize() equivalent?
    var H: vec3<f32> = normalize(L + V);
    var NoL: f32 = saturate(dot(N, L));
    var NoH: f32 = saturate(dot(N, H));
    var LoH: f32 = saturate(dot(L, H));

    let specular_light = specular(F0, roughness, H, NdotV, NoL, NoH, LoH, specularIntensity, f_ab);

    // Diffuse.
    // Comes after specular since its NoL is used in the lighting equation.
    L = normalize(light_to_frag);
    H = normalize(L + V);
    NoL = saturate(dot(N, L));
    NoH = saturate(dot(N, H));
    LoH = saturate(dot(L, H));

    let diffuse = diffuseColor * Fd_Burley(roughness, NdotV, NoL, LoH);

    // See https://google.github.io/filament/Filament.html#mjx-eqn-pointLightLuminanceEquation
    // Lout = f(v,l) Φ / { 4 π d^2 }⟨n⋅l⟩
    // where
    // f(v,l) = (f_d(v,l) + f_r(v,l)) * light_color
    // Φ is luminous power in lumens
    // our rangeAttenuation = 1 / d^2 multiplied with an attenuation factor for smoothing at the edge of the non-physical maximum light radius

    // For a point light, luminous intensity, I, in lumens per steradian is given by:
    // I = Φ / 4 π
    // The derivation of this can be seen here: https://google.github.io/filament/Filament.html#mjx-eqn-pointLightLuminousPower

    // NOTE: (*light).color.rgb is premultiplied with (*light).intensity / 4 π (which would be the luminous intensity) on the CPU

    return ((diffuse + specular_light) * (*light).color_inverse_square_range.rgb) * (rangeAttenuation * NoL);
}

fn spot_light(
    world_position: vec3<f32>,
    light_id: u32,
    roughness: f32,
    NdotV: f32,
    N: vec3<f32>,
    V: vec3<f32>,
    R: vec3<f32>,
    F0: vec3<f32>,
    f_ab: vec2<f32>,
    diffuseColor: vec3<f32>
) -> vec3<f32> {
    // reuse the point light calculations
    let point_light = point_light(world_position, light_id, roughness, NdotV, N, V, R, F0, f_ab, diffuseColor);

    let light = &view_bindings::point_lights.data[light_id];

    // reconstruct spot dir from x/z and y-direction flag
    var spot_dir = vec3<f32>((*light).light_custom_data.x, 0.0, (*light).light_custom_data.y);
    spot_dir.y = sqrt(max(0.0, 1.0 - spot_dir.x * spot_dir.x - spot_dir.z * spot_dir.z));
    if ((*light).flags & POINT_LIGHT_FLAGS_SPOT_LIGHT_Y_NEGATIVE) != 0u {
        spot_dir.y = -spot_dir.y;
    }
    let light_to_frag = (*light).position_radius.xyz - world_position.xyz;

    // calculate attenuation based on filament formula https://google.github.io/filament/Filament.html#listing_glslpunctuallight
    // spot_scale and spot_offset have been precomputed
    // note we normalize here to get "l" from the filament listing. spot_dir is already normalized
    let cd = dot(-spot_dir, normalize(light_to_frag));
    let attenuation = saturate(cd * (*light).light_custom_data.z + (*light).light_custom_data.w);
    let spot_attenuation = attenuation * attenuation;

    return point_light * spot_attenuation;
}

fn directional_light(light_id: u32, roughness: f32, NdotV: f32, normal: vec3<f32>, view: vec3<f32>, R: vec3<f32>, F0: vec3<f32>, f_ab: vec2<f32>, diffuseColor: vec3<f32>) -> vec3<f32> {
    let light = &view_bindings::lights.directional_lights[light_id];

    let incident_light = (*light).direction_to_light.xyz;

    let half_vector = normalize(incident_light + view);
    let NoL = saturate(dot(normal, incident_light));
    let NoH = saturate(dot(normal, half_vector));
    let LoH = saturate(dot(incident_light, half_vector));

    let diffuse = diffuseColor * Fd_Burley(roughness, NdotV, NoL, LoH);
    let specularIntensity = 1.0;
    let specular_light = specular(F0, roughness, half_vector, NdotV, NoL, NoH, LoH, specularIntensity, f_ab);

    return (specular_light + diffuse) * (*light).color.rgb * NoL;
}

```

### crates/bevy_pbr/src/render/wireframe

```rust
#import bevy_pbr::forward_io::VertexOutput

struct WireframeMaterial {
    color: vec4<f32>,
};

@group(2) @binding(0)
var<uniform> material: WireframeMaterial;
@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    return material.color;
}

```

### crates/bevy_pbr/src/render/mesh_preprocess

```rust
// GPU mesh uniform building.
//
// This is a compute shader that expands each `MeshInputUniform` out to a full
// `MeshUniform` for each view before rendering. (Thus `MeshInputUniform`
// and `MeshUniform` are in a 1:N relationship.) It runs in parallel for all
// meshes for all views. As part of this process, the shader gathers each
// mesh's transform on the previous frame and writes it into the `MeshUniform`
// so that TAA works.

#import bevy_pbr::mesh_types::Mesh
#import bevy_render::maths

// Per-frame data that the CPU supplies to the GPU.
struct MeshInput {
    // The model transform.
    model: mat3x4<f32>,
    // The lightmap UV rect, packed into 64 bits.
    lightmap_uv_rect: vec2<u32>,
    // Various flags.
    flags: u32,
    // The index of this mesh's `MeshInput` in the `previous_input` array, if
    // applicable. If not present, this is `u32::MAX`.
    previous_input_index: u32,
}

// One invocation of this compute shader: i.e. one mesh instance in a view.
struct PreprocessWorkItem {
    // The index of the `MeshInput` in the `current_input` buffer that we read
    // from.
    input_index: u32,
    // The index of the `Mesh` in `output` that we write to.
    output_index: u32,
}

// The current frame's `MeshInput`.
@group(0) @binding(0) var<storage> current_input: array<MeshInput>;
// The `MeshInput` values from the previous frame.
@group(0) @binding(1) var<storage> previous_input: array<MeshInput>;
// Indices into the `MeshInput` buffer.
//
// There may be many indices that map to the same `MeshInput`.
@group(0) @binding(2) var<storage> work_items: array<PreprocessWorkItem>;
// The output array of `Mesh`es.
@group(0) @binding(3) var<storage, read_write> output: array<Mesh>;

@compute
@workgroup_size(64)
fn main(@builtin(global_invocation_id) global_invocation_id: vec3<u32>) {
    let instance_index = global_invocation_id.x;
    if (instance_index >= arrayLength(&work_items)) {
        return;
    }

    // Unpack.
    let mesh_index = work_items[instance_index].input_index;
    let output_index = work_items[instance_index].output_index;
    let model_affine_transpose = current_input[mesh_index].model;
    let model = maths::affine3_to_square(model_affine_transpose);

    // Calculate inverse transpose.
    let inverse_transpose_model = transpose(maths::inverse_affine3(transpose(
        model_affine_transpose)));

    // Pack inverse transpose.
    let inverse_transpose_model_a = mat2x4<f32>(
        vec4<f32>(inverse_transpose_model[0].xyz, inverse_transpose_model[1].x),
        vec4<f32>(inverse_transpose_model[1].yz, inverse_transpose_model[2].xy));
    let inverse_transpose_model_b = inverse_transpose_model[2].z;

    // Look up the previous model matrix.
    let previous_input_index = current_input[mesh_index].previous_input_index;
    var previous_model: mat3x4<f32>;
    if (previous_input_index == 0xffffffff) {
        previous_model = model_affine_transpose;
    } else {
        previous_model = previous_input[previous_input_index].model;
    }

    // Write the output.
    output[output_index].model = model_affine_transpose;
    output[output_index].previous_model = previous_model;
    output[output_index].inverse_transpose_model_a = inverse_transpose_model_a;
    output[output_index].inverse_transpose_model_b = inverse_transpose_model_b;
    output[output_index].flags = current_input[mesh_index].flags;
    output[output_index].lightmap_uv_rect = current_input[mesh_index].lightmap_uv_rect;
}

```

### crates/bevy_pbr/src/render/pbr_prepass

```rust
#import bevy_pbr::{
    pbr_prepass_functions,
    pbr_bindings::material,
    pbr_types,
    pbr_functions,
    prepass_io,
    mesh_view_bindings::view,
}

#ifdef MESHLET_MESH_MATERIAL_PASS
#import bevy_pbr::meshlet_visibility_buffer_resolve::resolve_vertex_output
#endif

#ifdef PREPASS_FRAGMENT
@fragment
fn fragment(
#ifdef MESHLET_MESH_MATERIAL_PASS
    @builtin(position) frag_coord: vec4<f32>,
#else
    in: prepass_io::VertexOutput,
    @builtin(front_facing) is_front: bool,
#endif
) -> prepass_io::FragmentOutput {
#ifdef MESHLET_MESH_MATERIAL_PASS
    let in = resolve_vertex_output(frag_coord);
    let is_front = true;
#else
    pbr_prepass_functions::prepass_alpha_discard(in);
#endif

    var out: prepass_io::FragmentOutput;

#ifdef DEPTH_CLAMP_ORTHO
    out.frag_depth = in.clip_position_unclamped.z;
#endif // DEPTH_CLAMP_ORTHO

#ifdef NORMAL_PREPASS
    // NOTE: Unlit bit not set means == 0 is true, so the true case is if lit
    if (material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_UNLIT_BIT) == 0u {
        let double_sided = (material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_DOUBLE_SIDED_BIT) != 0u;

        let world_normal = pbr_functions::prepare_world_normal(
            in.world_normal,
            double_sided,
            is_front,
        );

        let normal = pbr_functions::apply_normal_mapping(
            material.flags,
            world_normal,
            double_sided,
            is_front,
#ifdef VERTEX_TANGENTS
#ifdef STANDARD_MATERIAL_NORMAL_MAP
            in.world_tangent,
#endif // STANDARD_MATERIAL_NORMAL_MAP
#endif // VERTEX_TANGENTS
#ifdef VERTEX_UVS
            in.uv,
#endif // VERTEX_UVS
            view.mip_bias,
#ifdef MESHLET_MESH_MATERIAL_PASS
            in.ddx_uv,
            in.ddy_uv,
#endif // MESHLET_MESH_MATERIAL_PASS
        );

        out.normal = vec4(normal * 0.5 + vec3(0.5), 1.0);
    } else {
        out.normal = vec4(in.world_normal * 0.5 + vec3(0.5), 1.0);
    }
#endif // NORMAL_PREPASS

#ifdef MOTION_VECTOR_PREPASS
#ifdef MESHLET_MESH_MATERIAL_PASS
    out.motion_vector = in.motion_vector;
#else
    out.motion_vector = pbr_prepass_functions::calculate_motion_vector(in.world_position, in.previous_world_position);
#endif
#endif

    return out;
}
#else
@fragment
fn fragment(in: prepass_io::VertexOutput) {
    pbr_prepass_functions::prepass_alpha_discard(in);
}
#endif // PREPASS_FRAGMENT

```

### crates/bevy_pbr/src/render/parallax_mapping

```rust
#define_import_path bevy_pbr::parallax_mapping

#import bevy_pbr::pbr_bindings::{depth_map_texture, depth_map_sampler}

fn sample_depth_map(uv: vec2<f32>) -> f32 {
    // We use `textureSampleLevel` over `textureSample` because the wgpu DX12
    // backend (Fxc) panics when using "gradient instructions" inside a loop.
    // It results in the whole loop being unrolled by the shader compiler,
    // which it can't do because the upper limit of the loop in steep parallax
    // mapping is a variable set by the user.
    // The "gradient instructions" comes from `textureSample` computing MIP level
    // based on UV derivative. With `textureSampleLevel`, we provide ourselves
    // the MIP level, so no gradient instructions are used, and we can use
    // sample_depth_map in our loop.
    // See https://stackoverflow.com/questions/56581141/direct3d11-gradient-instruction-used-in-a-loop-with-varying-iteration-forcing
    return textureSampleLevel(depth_map_texture, depth_map_sampler, uv, 0.0).r;
}

// An implementation of parallax mapping, see https://en.wikipedia.org/wiki/Parallax_mapping
// Code derived from: https://web.archive.org/web/20150419215321/http://sunandblackcat.com/tipFullView.php?l=eng&topicid=28
fn parallaxed_uv(
    depth_scale: f32,
    max_layer_count: f32,
    max_steps: u32,
    // The original interpolated uv
    original_uv: vec2<f32>,
    // The vector from the camera to the fragment at the surface in tangent space
    Vt: vec3<f32>,
) -> vec2<f32> {
    if max_layer_count < 1.0 {
        return original_uv;
    }
    var uv = original_uv;

    // Steep Parallax Mapping
    // ======================
    // Split the depth map into `layer_count` layers.
    // When Vt hits the surface of the mesh (excluding depth displacement),
    // if the depth is not below or on surface including depth displacement (textureSample), then
    // look forward (+= delta_uv) on depth texture according to
    // Vt and distance between hit surface and depth map surface,
    // repeat until below the surface.
    //
    // Where `layer_count` is interpolated between `1.0` and
    // `max_layer_count` according to the steepness of Vt.

    let view_steepness = abs(Vt.z);
    // We mix with minimum value 1.0 because otherwise,
    // with 0.0, we get a division by zero in surfaces parallel to viewport,
    // resulting in a singularity.
    let layer_count = mix(max_layer_count, 1.0, view_steepness);
    let layer_depth = 1.0 / layer_count;
    var delta_uv = depth_scale * layer_depth * Vt.xy * vec2(1.0, -1.0) / view_steepness;

    var current_layer_depth = 0.0;
    var texture_depth = sample_depth_map(uv);

    // texture_depth > current_layer_depth means the depth map depth is deeper
    // than the depth the ray would be at at this UV offset so the ray has not
    // intersected the surface
    for (var i: i32 = 0; texture_depth > current_layer_depth && i <= i32(layer_count); i++) {
        current_layer_depth += layer_depth;
        uv += delta_uv;
        texture_depth = sample_depth_map(uv);
    }

#ifdef RELIEF_MAPPING
    // Relief Mapping
    // ==============
    // "Refine" the rough result from Steep Parallax Mapping
    // with a **binary search** between the layer selected by steep parallax
    // and the next one to find a point closer to the depth map surface.
    // This reduces the jaggy step artifacts from steep parallax mapping.

    delta_uv *= 0.5;
    var delta_depth = 0.5 * layer_depth;

    uv -= delta_uv;
    current_layer_depth -= delta_depth;

    for (var i: u32 = 0u; i < max_steps; i++) {
        texture_depth = sample_depth_map(uv);

        // Halve the deltas for the next step
        delta_uv *= 0.5;
        delta_depth *= 0.5;

        // Step based on whether the current depth is above or below the depth map
        if (texture_depth > current_layer_depth) {
            uv += delta_uv;
            current_layer_depth += delta_depth;
        } else {
            uv -= delta_uv;
            current_layer_depth -= delta_depth;
        }
    }
#else
    // Parallax Occlusion mapping
    // ==========================
    // "Refine" Steep Parallax Mapping by interpolating between the
    // previous layer's depth and the computed layer depth.
    // Only requires a single lookup, unlike Relief Mapping, but
    // may skip small details and result in writhing material artifacts.
    let previous_uv = uv - delta_uv;
    let next_depth = texture_depth - current_layer_depth;
    let previous_depth = sample_depth_map(previous_uv) - current_layer_depth + layer_depth;

    let weight = next_depth / (next_depth - previous_depth);

    uv = mix(uv, previous_uv, weight);

    current_layer_depth += mix(next_depth, previous_depth, weight);
#endif

    // Note: `current_layer_depth` is not returned, but may be useful
    // for light computation later on in future improvements of the pbr shader.
    return uv;
}

```

### crates/bevy_pbr/src/render/pbr_fragment

```rust
#define_import_path bevy_pbr::pbr_fragment

#import bevy_pbr::{
    pbr_functions,
    pbr_bindings,
    pbr_types,
    prepass_utils,
    lighting,
    mesh_bindings::mesh,
    mesh_view_bindings::view,
    parallax_mapping::parallaxed_uv,
    lightmap::lightmap,
}

#ifdef SCREEN_SPACE_AMBIENT_OCCLUSION
#import bevy_pbr::mesh_view_bindings::screen_space_ambient_occlusion_texture
#import bevy_pbr::gtao_utils::gtao_multibounce
#endif

#ifdef MESHLET_MESH_MATERIAL_PASS
#import bevy_pbr::meshlet_visibility_buffer_resolve::VertexOutput
#else ifdef PREPASS_PIPELINE
#import bevy_pbr::prepass_io::VertexOutput
#else
#import bevy_pbr::forward_io::VertexOutput
#endif

// prepare a basic PbrInput from the vertex stage output, mesh binding and view binding
fn pbr_input_from_vertex_output(
    in: VertexOutput,
    is_front: bool,
    double_sided: bool,
) -> pbr_types::PbrInput {
    var pbr_input: pbr_types::PbrInput = pbr_types::pbr_input_new();

#ifdef MESHLET_MESH_MATERIAL_PASS
    pbr_input.flags = in.mesh_flags;
#else
    pbr_input.flags = mesh[in.instance_index].flags;
#endif

    pbr_input.is_orthographic = view.projection[3].w == 1.0;
    pbr_input.V = pbr_functions::calculate_view(in.world_position, pbr_input.is_orthographic);
    pbr_input.frag_coord = in.position;
    pbr_input.world_position = in.world_position;

#ifdef VERTEX_COLORS
    pbr_input.material.base_color = in.color;
#endif

    pbr_input.world_normal = pbr_functions::prepare_world_normal(
        in.world_normal,
        double_sided,
        is_front,
    );

#ifdef LOAD_PREPASS_NORMALS
    pbr_input.N = prepass_utils::prepass_normal(in.position, 0u);
#else
    pbr_input.N = normalize(pbr_input.world_normal);
#endif

    return pbr_input;
}

// Prepare a full PbrInput by sampling all textures to resolve
// the material members
fn pbr_input_from_standard_material(
    in: VertexOutput,
    is_front: bool,
) -> pbr_types::PbrInput {
    let double_sided = (pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_DOUBLE_SIDED_BIT) != 0u;

    var pbr_input: pbr_types::PbrInput = pbr_input_from_vertex_output(in, is_front, double_sided);
    pbr_input.material.flags = pbr_bindings::material.flags;
    pbr_input.material.base_color *= pbr_bindings::material.base_color;
    pbr_input.material.deferred_lighting_pass_id = pbr_bindings::material.deferred_lighting_pass_id;

    // Neubelt and Pettineo 2013, "Crafting a Next-gen Material Pipeline for The Order: 1886"
    let NdotV = max(dot(pbr_input.N, pbr_input.V), 0.0001);

#ifdef VERTEX_UVS
    let uv_transform = pbr_bindings::material.uv_transform;
    var uv = (uv_transform * vec3(in.uv, 1.0)).xy;

#ifdef VERTEX_TANGENTS
    if ((pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_DEPTH_MAP_BIT) != 0u) {
        let V = pbr_input.V;
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
#endif // VERTEX_TANGENTS

    if ((pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_BASE_COLOR_TEXTURE_BIT) != 0u) {
#ifdef MESHLET_MESH_MATERIAL_PASS
        pbr_input.material.base_color *= textureSampleGrad(pbr_bindings::base_color_texture, pbr_bindings::base_color_sampler, uv, in.ddx_uv, in.ddy_uv);
#else
        pbr_input.material.base_color *= textureSampleBias(pbr_bindings::base_color_texture, pbr_bindings::base_color_sampler, uv, view.mip_bias);
#endif

#ifdef ALPHA_TO_COVERAGE
    // Sharpen alpha edges.
    //
    // https://bgolus.medium.com/anti-aliased-alpha-test-the-esoteric-alpha-to-coverage-8b177335ae4f
    let alpha_mode = pbr_bindings::material.flags &
        pbr_types::STANDARD_MATERIAL_FLAGS_ALPHA_MODE_RESERVED_BITS;
    if alpha_mode == pbr_types::STANDARD_MATERIAL_FLAGS_ALPHA_MODE_ALPHA_TO_COVERAGE {
        pbr_input.material.base_color.a = (pbr_input.material.base_color.a -
                pbr_bindings::material.alpha_cutoff) /
                max(fwidth(pbr_input.material.base_color.a), 0.0001) + 0.5;
    }
#endif // ALPHA_TO_COVERAGE

    }
#endif // VERTEX_UVS

    pbr_input.material.flags = pbr_bindings::material.flags;

    // NOTE: Unlit bit not set means == 0 is true, so the true case is if lit
    if ((pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_UNLIT_BIT) == 0u) {
        pbr_input.material.reflectance = pbr_bindings::material.reflectance;
        pbr_input.material.ior = pbr_bindings::material.ior;
        pbr_input.material.attenuation_color = pbr_bindings::material.attenuation_color;
        pbr_input.material.attenuation_distance = pbr_bindings::material.attenuation_distance;
        pbr_input.material.alpha_cutoff = pbr_bindings::material.alpha_cutoff;

        // emissive
        // TODO use .a for exposure compensation in HDR
        var emissive: vec4<f32> = pbr_bindings::material.emissive;
#ifdef VERTEX_UVS
        if ((pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_EMISSIVE_TEXTURE_BIT) != 0u) {
#ifdef MESHLET_MESH_MATERIAL_PASS
            emissive = vec4<f32>(emissive.rgb * textureSampleGrad(pbr_bindings::emissive_texture, pbr_bindings::emissive_sampler, uv, in.ddx_uv, in.ddy_uv).rgb, 1.0);
#else
            emissive = vec4<f32>(emissive.rgb * textureSampleBias(pbr_bindings::emissive_texture, pbr_bindings::emissive_sampler, uv, view.mip_bias).rgb, 1.0);
#endif
        }
#endif
        pbr_input.material.emissive = emissive;

        // metallic and perceptual roughness
        var metallic: f32 = pbr_bindings::material.metallic;
        var perceptual_roughness: f32 = pbr_bindings::material.perceptual_roughness;
        let roughness = lighting::perceptualRoughnessToRoughness(perceptual_roughness);
#ifdef VERTEX_UVS
        if ((pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_METALLIC_ROUGHNESS_TEXTURE_BIT) != 0u) {
#ifdef MESHLET_MESH_MATERIAL_PASS
            let metallic_roughness = textureSampleGrad(pbr_bindings::metallic_roughness_texture, pbr_bindings::metallic_roughness_sampler, uv, in.ddx_uv, in.ddy_uv);
#else
            let metallic_roughness = textureSampleBias(pbr_bindings::metallic_roughness_texture, pbr_bindings::metallic_roughness_sampler, uv, view.mip_bias);
#endif
            // Sampling from GLTF standard channels for now
            metallic *= metallic_roughness.b;
            perceptual_roughness *= metallic_roughness.g;
        }
#endif
        pbr_input.material.metallic = metallic;
        pbr_input.material.perceptual_roughness = perceptual_roughness;

        var specular_transmission: f32 = pbr_bindings::material.specular_transmission;
#ifdef PBR_TRANSMISSION_TEXTURES_SUPPORTED
        if ((pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_SPECULAR_TRANSMISSION_TEXTURE_BIT) != 0u) {
#ifdef MESHLET_MESH_MATERIAL_PASS
            specular_transmission *= textureSampleGrad(pbr_bindings::specular_transmission_texture, pbr_bindings::specular_transmission_sampler, uv, in.ddx_uv, in.ddy_uv).r;
#else
            specular_transmission *= textureSampleBias(pbr_bindings::specular_transmission_texture, pbr_bindings::specular_transmission_sampler, uv, view.mip_bias).r;
#endif
        }
#endif
        pbr_input.material.specular_transmission = specular_transmission;

        var thickness: f32 = pbr_bindings::material.thickness;
#ifdef PBR_TRANSMISSION_TEXTURES_SUPPORTED
        if ((pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_THICKNESS_TEXTURE_BIT) != 0u) {
#ifdef MESHLET_MESH_MATERIAL_PASS
            thickness *= textureSampleGrad(pbr_bindings::thickness_texture, pbr_bindings::thickness_sampler, uv, in.ddx_uv, in.ddy_uv).g;
#else
            thickness *= textureSampleBias(pbr_bindings::thickness_texture, pbr_bindings::thickness_sampler, uv, view.mip_bias).g;
#endif
        }
#endif
        // scale thickness, accounting for non-uniform scaling (e.g. a “squished” mesh)
        // TODO: Meshlet support
#ifndef MESHLET_MESH_MATERIAL_PASS
        thickness *= length(
            (transpose(mesh[in.instance_index].model) * vec4(pbr_input.N, 0.0)).xyz
        );
#endif
        pbr_input.material.thickness = thickness;

        var diffuse_transmission = pbr_bindings::material.diffuse_transmission;
#ifdef PBR_TRANSMISSION_TEXTURES_SUPPORTED
        if ((pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_DIFFUSE_TRANSMISSION_TEXTURE_BIT) != 0u) {
#ifdef MESHLET_MESH_MATERIAL_PASS
            diffuse_transmission *= textureSampleGrad(pbr_bindings::diffuse_transmission_texture, pbr_bindings::diffuse_transmission_sampler, uv, in.ddx_uv, in.ddy_uv).a;
#else
            diffuse_transmission *= textureSampleBias(pbr_bindings::diffuse_transmission_texture, pbr_bindings::diffuse_transmission_sampler, uv, view.mip_bias).a;
#endif
        }
#endif
        pbr_input.material.diffuse_transmission = diffuse_transmission;

        var diffuse_occlusion: vec3<f32> = vec3(1.0);
        var specular_occlusion: f32 = 1.0;
#ifdef VERTEX_UVS
        if ((pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_OCCLUSION_TEXTURE_BIT) != 0u) {
#ifdef MESHLET_MESH_MATERIAL_PASS
            diffuse_occlusion = vec3(textureSampleGrad(pbr_bindings::occlusion_texture, pbr_bindings::occlusion_sampler, uv, in.ddx_uv, in.ddy_uv).r);
#else
            diffuse_occlusion = vec3(textureSampleBias(pbr_bindings::occlusion_texture, pbr_bindings::occlusion_sampler, uv, view.mip_bias).r);
#endif
        }
#endif
#ifdef SCREEN_SPACE_AMBIENT_OCCLUSION
        let ssao = textureLoad(screen_space_ambient_occlusion_texture, vec2<i32>(in.position.xy), 0i).r;
        let ssao_multibounce = gtao_multibounce(ssao, pbr_input.material.base_color.rgb);
        diffuse_occlusion = min(diffuse_occlusion, ssao_multibounce);
        // Use SSAO to estimate the specular occlusion.
        // Lagarde and Rousiers 2014, "Moving Frostbite to Physically Based Rendering"
        specular_occlusion =  saturate(pow(NdotV + ssao, exp2(-16.0 * roughness - 1.0)) - 1.0 + ssao);
#endif
        pbr_input.diffuse_occlusion = diffuse_occlusion;
        pbr_input.specular_occlusion = specular_occlusion;

        // N (normal vector)
#ifndef LOAD_PREPASS_NORMALS
        pbr_input.N = pbr_functions::apply_normal_mapping(
            pbr_bindings::material.flags,
            pbr_input.world_normal,
            double_sided,
            is_front,
#ifdef VERTEX_TANGENTS
#ifdef STANDARD_MATERIAL_NORMAL_MAP
            in.world_tangent,
#endif
#endif
#ifdef VERTEX_UVS
            uv,
#endif
            view.mip_bias,
#ifdef MESHLET_MESH_MATERIAL_PASS
            in.ddx_uv,
            in.ddy_uv,
#endif
        );
#endif

// TODO: Meshlet support
#ifdef LIGHTMAP
        pbr_input.lightmap_light = lightmap(
            in.uv_b,
            pbr_bindings::material.lightmap_exposure,
            in.instance_index);
#endif
    }

    return pbr_input;
}

```

### crates/bevy_pbr/src/render/utils

```rust
#define_import_path bevy_pbr::utils

#import bevy_pbr::rgb9e5

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

// Generates a random u32 in range [0, u32::MAX].
//
// `state` is a mutable reference to a u32 used as the seed.
//
// Values are generated via "white noise", with no correlation between values.
// In shaders, you often want spatial and/or temporal correlation. Use a different RNG method for these use cases.
//
// https://www.pcg-random.org
// https://www.reedbeta.com/blog/hash-functions-for-gpu-rendering
fn rand_u(state: ptr<function, u32>) -> u32 {
    *state = *state * 747796405u + 2891336453u;
    let word = ((*state >> ((*state >> 28u) + 4u)) ^ *state) * 277803737u;
    return (word >> 22u) ^ word;
}

// Generates a random f32 in range [0, 1.0].
fn rand_f(state: ptr<function, u32>) -> f32 {
    *state = *state * 747796405u + 2891336453u;
    let word = ((*state >> ((*state >> 28u) + 4u)) ^ *state) * 277803737u;
    return f32((word >> 22u) ^ word) * bitcast<f32>(0x2f800004u);
}

// Generates a random vec2<f32> where each value is in range [0, 1.0].
fn rand_vec2f(state: ptr<function, u32>) -> vec2<f32> {
    return vec2(rand_f(state), rand_f(state));
}

// Generates a random u32 in range [0, n).
fn rand_range_u(n: u32, state: ptr<function, u32>) -> u32 {
    return rand_u(state) % n;
}

// returns the (0-1, 0-1) position within the given viewport for the current buffer coords .
// buffer coords can be obtained from `@builtin(position).xy`.
// the view uniform struct contains the current camera viewport in `view.viewport`.
// topleft = 0,0
fn coords_to_viewport_uv(position: vec2<f32>, viewport: vec4<f32>) -> vec2<f32> {
    return (position - viewport.xy) / viewport.zw;
}

// https://jcgt.org/published/0003/02/01/paper.pdf

// For encoding normals or unit direction vectors as octahedral coordinates.
fn octahedral_encode(v: vec3<f32>) -> vec2<f32> {
    var n = v / (abs(v.x) + abs(v.y) + abs(v.z));
    let octahedral_wrap = (1.0 - abs(n.yx)) * select(vec2(-1.0), vec2(1.0), n.xy > vec2f(0.0));
    let n_xy = select(octahedral_wrap, n.xy, n.z >= 0.0);
    return n_xy * 0.5 + 0.5;
}

// For decoding normals or unit direction vectors from octahedral coordinates.
fn octahedral_decode(v: vec2<f32>) -> vec3<f32> {
    let f = v * 2.0 - 1.0;
    var n = vec3(f.xy, 1.0 - abs(f.x) - abs(f.y));
    let t = saturate(-n.z);
    let w = select(vec2(t), vec2(-t), n.xy >= vec2(0.0));
    n = vec3(n.xy + w, n.z);
    return normalize(n);
}

// https://blog.demofox.org/2022/01/01/interleaved-gradient-noise-a-different-kind-of-low-discrepancy-sequence
fn interleaved_gradient_noise(pixel_coordinates: vec2<f32>, frame: u32) -> f32 {
    let xy = pixel_coordinates + 5.588238 * f32(frame % 64u);
    return fract(52.9829189 * fract(0.06711056 * xy.x + 0.00583715 * xy.y));
}

// https://www.iryoku.com/next-generation-post-processing-in-call-of-duty-advanced-warfare (slides 120-135)
// TODO: Use an array here instead of a bunch of constants, once arrays work properly under DX12.
// NOTE: The names have a final underscore to avoid the following error:
// `Composable module identifiers must not require substitution according to naga writeback rules`
const SPIRAL_OFFSET_0_ = vec2<f32>(-0.7071,  0.7071);
const SPIRAL_OFFSET_1_ = vec2<f32>(-0.0000, -0.8750);
const SPIRAL_OFFSET_2_ = vec2<f32>( 0.5303,  0.5303);
const SPIRAL_OFFSET_3_ = vec2<f32>(-0.6250, -0.0000);
const SPIRAL_OFFSET_4_ = vec2<f32>( 0.3536, -0.3536);
const SPIRAL_OFFSET_5_ = vec2<f32>(-0.0000,  0.3750);
const SPIRAL_OFFSET_6_ = vec2<f32>(-0.1768, -0.1768);
const SPIRAL_OFFSET_7_ = vec2<f32>( 0.1250,  0.0000);

```

### crates/bevy_pbr/src/render/mesh_types

```rust
#define_import_path bevy_pbr::mesh_types

struct Mesh {
    // Affine 4x3 matrices transposed to 3x4
    // Use bevy_render::maths::affine3_to_square to unpack
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
    lightmap_uv_rect: vec2<u32>,
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
const MESH_FLAGS_TRANSMITTED_SHADOW_RECEIVER_BIT: u32 = 2u;
// 2^31 - if the flag is set, the sign is positive, else it is negative
const MESH_FLAGS_SIGN_DETERMINANT_MODEL_3X3_BIT: u32 = 2147483648u;

```

### crates/bevy_pbr/src/render/shadows

```rust
#define_import_path bevy_pbr::shadows

#import bevy_pbr::{
    mesh_view_types::POINT_LIGHT_FLAGS_SPOT_LIGHT_Y_NEGATIVE,
    mesh_view_bindings as view_bindings,
    utils::hsv2rgb,
    shadow_sampling::{SPOT_SHADOW_TEXEL_SIZE, sample_shadow_cubemap, sample_shadow_map}
}

const flip_z: vec3<f32> = vec3<f32>(1.0, 1.0, -1.0);

fn fetch_point_shadow(light_id: u32, frag_position: vec4<f32>, surface_normal: vec3<f32>) -> f32 {
    let light = &view_bindings::point_lights.data[light_id];

    // because the shadow maps align with the axes and the frustum planes are at 45 degrees
    // we can get the worldspace depth by taking the largest absolute axis
    let surface_to_light = (*light).position_radius.xyz - frag_position.xyz;
    let surface_to_light_abs = abs(surface_to_light);
    let distance_to_light = max(surface_to_light_abs.x, max(surface_to_light_abs.y, surface_to_light_abs.z));

    // The normal bias here is already scaled by the texel size at 1 world unit from the light.
    // The texel size increases proportionally with distance from the light so multiplying by
    // distance to light scales the normal bias to the texel size at the fragment distance.
    let normal_offset = (*light).shadow_normal_bias * distance_to_light * surface_normal.xyz;
    let depth_offset = (*light).shadow_depth_bias * normalize(surface_to_light.xyz);
    let offset_position = frag_position.xyz + normal_offset + depth_offset;

    // similar largest-absolute-axis trick as above, but now with the offset fragment position
    let frag_ls = offset_position.xyz - (*light).position_radius.xyz ;
    let abs_position_ls = abs(frag_ls);
    let major_axis_magnitude = max(abs_position_ls.x, max(abs_position_ls.y, abs_position_ls.z));

    // NOTE: These simplifications come from multiplying:
    // projection * vec4(0, 0, -major_axis_magnitude, 1.0)
    // and keeping only the terms that have any impact on the depth.
    // Projection-agnostic approach:
    let zw = -major_axis_magnitude * (*light).light_custom_data.xy + (*light).light_custom_data.zw;
    let depth = zw.x / zw.y;

    // Do the lookup, using HW PCF and comparison. Cubemaps assume a left-handed coordinate space,
    // so we have to flip the z-axis when sampling.
    return sample_shadow_cubemap(frag_ls * flip_z, distance_to_light, depth, light_id);
}

fn fetch_spot_shadow(light_id: u32, frag_position: vec4<f32>, surface_normal: vec3<f32>) -> f32 {
    let light = &view_bindings::point_lights.data[light_id];

    let surface_to_light = (*light).position_radius.xyz - frag_position.xyz;

    // construct the light view matrix
    var spot_dir = vec3<f32>((*light).light_custom_data.x, 0.0, (*light).light_custom_data.y);
    // reconstruct spot dir from x/z and y-direction flag
    spot_dir.y = sqrt(max(0.0, 1.0 - spot_dir.x * spot_dir.x - spot_dir.z * spot_dir.z));
    if (((*light).flags & POINT_LIGHT_FLAGS_SPOT_LIGHT_Y_NEGATIVE) != 0u) {
        spot_dir.y = -spot_dir.y;
    }

    // view matrix z_axis is the reverse of transform.forward()
    let fwd = -spot_dir;
    let distance_to_light = dot(fwd, surface_to_light);
    let offset_position =
        -surface_to_light
        + ((*light).shadow_depth_bias * normalize(surface_to_light))
        + (surface_normal.xyz * (*light).shadow_normal_bias) * distance_to_light;

    // the construction of the up and right vectors needs to precisely mirror the code
    // in render/light.rs:spot_light_view_matrix
    var sign = -1.0;
    if (fwd.z >= 0.0) {
        sign = 1.0;
    }
    let a = -1.0 / (fwd.z + sign);
    let b = fwd.x * fwd.y * a;
    let up_dir = vec3<f32>(1.0 + sign * fwd.x * fwd.x * a, sign * b, -sign * fwd.x);
    let right_dir = vec3<f32>(-b, -sign - fwd.y * fwd.y * a, fwd.y);
    let light_inv_rot = mat3x3<f32>(right_dir, up_dir, fwd);

    // because the matrix is a pure rotation matrix, the inverse is just the transpose, and to calculate
    // the product of the transpose with a vector we can just post-multiply instead of pre-multiplying.
    // this allows us to keep the matrix construction code identical between CPU and GPU.
    let projected_position = offset_position * light_inv_rot;

    // divide xy by perspective matrix "f" and by -projected.z (projected.z is -projection matrix's w)
    // to get ndc coordinates
    let f_div_minus_z = 1.0 / ((*light).spot_light_tan_angle * -projected_position.z);
    let shadow_xy_ndc = projected_position.xy * f_div_minus_z;
    // convert to uv coordinates
    let shadow_uv = shadow_xy_ndc * vec2<f32>(0.5, -0.5) + vec2<f32>(0.5, 0.5);

    // 0.1 must match POINT_LIGHT_NEAR_Z
    let depth = 0.1 / -projected_position.z;

    return sample_shadow_map(
        shadow_uv,
        depth,
        i32(light_id) + view_bindings::lights.spot_light_shadowmap_offset,
        SPOT_SHADOW_TEXEL_SIZE
    );
}

fn get_cascade_index(light_id: u32, view_z: f32) -> u32 {
    let light = &view_bindings::lights.directional_lights[light_id];

    for (var i: u32 = 0u; i < (*light).num_cascades; i = i + 1u) {
        if (-view_z < (*light).cascades[i].far_bound) {
            return i;
        }
    }
    return (*light).num_cascades;
}

fn sample_directional_cascade(light_id: u32, cascade_index: u32, frag_position: vec4<f32>, surface_normal: vec3<f32>) -> f32 {
    let light = &view_bindings::lights.directional_lights[light_id];
    let cascade = &(*light).cascades[cascade_index];

    // The normal bias is scaled to the texel size.
    let normal_offset = (*light).shadow_normal_bias * (*cascade).texel_size * surface_normal.xyz;
    let depth_offset = (*light).shadow_depth_bias * (*light).direction_to_light.xyz;
    let offset_position = vec4<f32>(frag_position.xyz + normal_offset + depth_offset, frag_position.w);

    let offset_position_clip = (*cascade).view_projection * offset_position;
    if (offset_position_clip.w <= 0.0) {
        return 1.0;
    }
    let offset_position_ndc = offset_position_clip.xyz / offset_position_clip.w;
    // No shadow outside the orthographic projection volume
    if (any(offset_position_ndc.xy < vec2<f32>(-1.0)) || offset_position_ndc.z < 0.0
            || any(offset_position_ndc > vec3<f32>(1.0))) {
        return 1.0;
    }

    // compute texture coordinates for shadow lookup, compensating for the Y-flip difference
    // between the NDC and texture coordinates
    let flip_correction = vec2<f32>(0.5, -0.5);
    let light_local = offset_position_ndc.xy * flip_correction + vec2<f32>(0.5, 0.5);

    let depth = offset_position_ndc.z;

    let array_index = i32((*light).depth_texture_base_index + cascade_index);
    return sample_shadow_map(light_local, depth, array_index, (*cascade).texel_size);
}

fn fetch_directional_shadow(light_id: u32, frag_position: vec4<f32>, surface_normal: vec3<f32>, view_z: f32) -> f32 {
    let light = &view_bindings::lights.directional_lights[light_id];
    let cascade_index = get_cascade_index(light_id, view_z);

    if (cascade_index >= (*light).num_cascades) {
        return 1.0;
    }

    var shadow = sample_directional_cascade(light_id, cascade_index, frag_position, surface_normal);

    // Blend with the next cascade, if there is one.
    let next_cascade_index = cascade_index + 1u;
    if (next_cascade_index < (*light).num_cascades) {
        let this_far_bound = (*light).cascades[cascade_index].far_bound;
        let next_near_bound = (1.0 - (*light).cascades_overlap_proportion) * this_far_bound;
        if (-view_z >= next_near_bound) {
            let next_shadow = sample_directional_cascade(light_id, next_cascade_index, frag_position, surface_normal);
            shadow = mix(shadow, next_shadow, (-view_z - next_near_bound) / (this_far_bound - next_near_bound));
        }
    }
    return shadow;
}

fn cascade_debug_visualization(
    output_color: vec3<f32>,
    light_id: u32,
    view_z: f32,
) -> vec3<f32> {
    let overlay_alpha = 0.95;
    let cascade_index = get_cascade_index(light_id, view_z);
    let cascade_color = hsv2rgb(f32(cascade_index) / f32(#{MAX_CASCADES_PER_LIGHT}u + 1u), 1.0, 0.5);
    return vec3<f32>(
        (1.0 - overlay_alpha) * output_color.rgb + overlay_alpha * cascade_color
    );
}

```

### crates/bevy_pbr/src/render/fog

```rust
#define_import_path bevy_pbr::fog

#import bevy_pbr::{
    mesh_view_bindings::fog,
    mesh_view_types::Fog,
}

// Fog formulas adapted from:
// https://learn.microsoft.com/en-us/windows/win32/direct3d9/fog-formulas
// https://catlikecoding.com/unity/tutorials/rendering/part-14/
// https://iquilezles.org/articles/fog/ (Atmospheric Fog and Scattering)

fn scattering_adjusted_fog_color(
    fog_params: Fog,
    scattering: vec3<f32>,
) -> vec4<f32> {
    if (fog_params.directional_light_color.a > 0.0) {
        return vec4<f32>(
            fog_params.base_color.rgb
                + scattering * fog_params.directional_light_color.rgb * fog_params.directional_light_color.a,
            fog_params.base_color.a,
        );
    } else {
        return fog_params.base_color;
    }
}

fn linear_fog(
    fog_params: Fog,
    input_color: vec4<f32>,
    distance: f32,
    scattering: vec3<f32>,
) -> vec4<f32> {
    var fog_color = scattering_adjusted_fog_color(fog_params, scattering);
    let start = fog_params.be.x;
    let end = fog_params.be.y;
    fog_color.a *= 1.0 - clamp((end - distance) / (end - start), 0.0, 1.0);
    return vec4<f32>(mix(input_color.rgb, fog_color.rgb, fog_color.a), input_color.a);
}

fn exponential_fog(
    fog_params: Fog,
    input_color: vec4<f32>,
    distance: f32,
    scattering: vec3<f32>,
) -> vec4<f32> {
    var fog_color = scattering_adjusted_fog_color(fog_params, scattering);
    let density = fog_params.be.x;
    fog_color.a *= 1.0 - 1.0 / exp(distance * density);
    return vec4<f32>(mix(input_color.rgb, fog_color.rgb, fog_color.a), input_color.a);
}

fn exponential_squared_fog(
    fog_params: Fog,
    input_color: vec4<f32>,
    distance: f32,
    scattering: vec3<f32>,
) -> vec4<f32> {
    var fog_color = scattering_adjusted_fog_color(fog_params, scattering);
    let distance_times_density = distance * fog_params.be.x;
    fog_color.a *= 1.0 - 1.0 / exp(distance_times_density * distance_times_density);
    return vec4<f32>(mix(input_color.rgb, fog_color.rgb, fog_color.a), input_color.a);
}

fn atmospheric_fog(
    fog_params: Fog,
    input_color: vec4<f32>,
    distance: f32,
    scattering: vec3<f32>,
) -> vec4<f32> {
    var fog_color = scattering_adjusted_fog_color(fog_params, scattering);
    let extinction_factor = 1.0 - 1.0 / exp(distance * fog_params.be);
    let inscattering_factor = 1.0 - 1.0 / exp(distance * fog_params.bi);
    return vec4<f32>(
        input_color.rgb * (1.0 - extinction_factor * fog_color.a)
            + fog_color.rgb * inscattering_factor * fog_color.a,
        input_color.a
    );
}

```

### crates/bevy_pbr/src/render/pbr_bindings

```rust
#define_import_path bevy_pbr::pbr_bindings

#import bevy_pbr::pbr_types::StandardMaterial

@group(2) @binding(0) var<uniform> material: StandardMaterial;
@group(2) @binding(1) var base_color_texture: texture_2d<f32>;
@group(2) @binding(2) var base_color_sampler: sampler;
@group(2) @binding(3) var emissive_texture: texture_2d<f32>;
@group(2) @binding(4) var emissive_sampler: sampler;
@group(2) @binding(5) var metallic_roughness_texture: texture_2d<f32>;
@group(2) @binding(6) var metallic_roughness_sampler: sampler;
@group(2) @binding(7) var occlusion_texture: texture_2d<f32>;
@group(2) @binding(8) var occlusion_sampler: sampler;
@group(2) @binding(9) var normal_map_texture: texture_2d<f32>;
@group(2) @binding(10) var normal_map_sampler: sampler;
@group(2) @binding(11) var depth_map_texture: texture_2d<f32>;
@group(2) @binding(12) var depth_map_sampler: sampler;
#ifdef PBR_TRANSMISSION_TEXTURES_SUPPORTED
@group(2) @binding(13) var specular_transmission_texture: texture_2d<f32>;
@group(2) @binding(14) var specular_transmission_sampler: sampler;
@group(2) @binding(15) var thickness_texture: texture_2d<f32>;
@group(2) @binding(16) var thickness_sampler: sampler;
@group(2) @binding(17) var diffuse_transmission_texture: texture_2d<f32>;
@group(2) @binding(18) var diffuse_transmission_sampler: sampler;
#endif

```

### crates/bevy_pbr/src/render/pbr_types

```rust
#define_import_path bevy_pbr::pbr_types

// Since this is a hot path, try to keep the alignment and size of the struct members in mind.
// You can find the alignment and sizes at <https://www.w3.org/TR/WGSL/#alignment-and-size>.
struct StandardMaterial {
    base_color: vec4<f32>,
    emissive: vec4<f32>,
    attenuation_color: vec4<f32>,
    uv_transform: mat3x3<f32>,
    perceptual_roughness: f32,
    metallic: f32,
    reflectance: f32,
    diffuse_transmission: f32,
    specular_transmission: f32,
    thickness: f32,
    ior: f32,
    attenuation_distance: f32,
    // 'flags' is a bit field indicating various options. u32 is 32 bits so we have up to 32 options.
    flags: u32,
    alpha_cutoff: f32,
    parallax_depth_scale: f32,
    max_parallax_layer_count: f32,
    lightmap_exposure: f32,
    max_relief_mapping_search_steps: u32,
    /// ID for specifying which deferred lighting pass should be used for rendering this material, if any.
    deferred_lighting_pass_id: u32,
};

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// NOTE: if these flags are updated or changed. Be sure to also update
// deferred_flags_from_mesh_material_flags and mesh_material_flags_from_deferred_flags
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
const STANDARD_MATERIAL_FLAGS_BASE_COLOR_TEXTURE_BIT: u32         = 1u;
const STANDARD_MATERIAL_FLAGS_EMISSIVE_TEXTURE_BIT: u32           = 2u;
const STANDARD_MATERIAL_FLAGS_METALLIC_ROUGHNESS_TEXTURE_BIT: u32 = 4u;
const STANDARD_MATERIAL_FLAGS_OCCLUSION_TEXTURE_BIT: u32          = 8u;
const STANDARD_MATERIAL_FLAGS_DOUBLE_SIDED_BIT: u32               = 16u;
const STANDARD_MATERIAL_FLAGS_UNLIT_BIT: u32                      = 32u;
const STANDARD_MATERIAL_FLAGS_TWO_COMPONENT_NORMAL_MAP: u32       = 64u;
const STANDARD_MATERIAL_FLAGS_FLIP_NORMAL_MAP_Y: u32              = 128u;
const STANDARD_MATERIAL_FLAGS_FOG_ENABLED_BIT: u32                = 256u;
const STANDARD_MATERIAL_FLAGS_DEPTH_MAP_BIT: u32                  = 512u;
const STANDARD_MATERIAL_FLAGS_SPECULAR_TRANSMISSION_TEXTURE_BIT: u32 = 1024u;
const STANDARD_MATERIAL_FLAGS_THICKNESS_TEXTURE_BIT: u32          = 2048u;
const STANDARD_MATERIAL_FLAGS_DIFFUSE_TRANSMISSION_TEXTURE_BIT: u32 = 4096u;
const STANDARD_MATERIAL_FLAGS_ATTENUATION_ENABLED_BIT: u32        = 8192u;
const STANDARD_MATERIAL_FLAGS_ALPHA_MODE_RESERVED_BITS: u32       = 3758096384u; // (0b111u32 << 29)
const STANDARD_MATERIAL_FLAGS_ALPHA_MODE_OPAQUE: u32              = 0u;          // (0u32 << 29)
const STANDARD_MATERIAL_FLAGS_ALPHA_MODE_MASK: u32                = 536870912u;  // (1u32 << 29)
const STANDARD_MATERIAL_FLAGS_ALPHA_MODE_BLEND: u32               = 1073741824u; // (2u32 << 29)
const STANDARD_MATERIAL_FLAGS_ALPHA_MODE_PREMULTIPLIED: u32       = 1610612736u; // (3u32 << 29)
const STANDARD_MATERIAL_FLAGS_ALPHA_MODE_ADD: u32                 = 2147483648u; // (4u32 << 29)
const STANDARD_MATERIAL_FLAGS_ALPHA_MODE_MULTIPLY: u32            = 2684354560u; // (5u32 << 29)
const STANDARD_MATERIAL_FLAGS_ALPHA_MODE_ALPHA_TO_COVERAGE: u32   = 3221225472u; // (6u32 << 29)
// ↑ To calculate/verify the values above, use the following playground:
// https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=7792f8dd6fc6a8d4d0b6b1776898a7f4


// Creates a StandardMaterial with default values
fn standard_material_new() -> StandardMaterial {
    var material: StandardMaterial;

    // NOTE: Keep in-sync with src/pbr_material.rs!
    material.base_color = vec4<f32>(1.0, 1.0, 1.0, 1.0);
    material.emissive = vec4<f32>(0.0, 0.0, 0.0, 1.0);
    material.perceptual_roughness = 0.5;
    material.metallic = 0.00;
    material.reflectance = 0.5;
    material.diffuse_transmission = 0.0;
    material.specular_transmission = 0.0;
    material.thickness = 0.0;
    material.ior = 1.5;
    material.attenuation_distance = 1.0;
    material.attenuation_color = vec4<f32>(1.0, 1.0, 1.0, 1.0);
    material.flags = STANDARD_MATERIAL_FLAGS_ALPHA_MODE_OPAQUE;
    material.alpha_cutoff = 0.5;
    material.parallax_depth_scale = 0.1;
    material.max_parallax_layer_count = 16.0;
    material.max_relief_mapping_search_steps = 5u;
    material.deferred_lighting_pass_id = 1u;
    // scale 1, translation 0, rotation 0
    material.uv_transform = mat3x3<f32>(1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0);

    return material;
}

struct PbrInput {
    material: StandardMaterial,
    // Note: this gets monochromized upon deferred PbrInput reconstruction.
    diffuse_occlusion: vec3<f32>,
    // Note: this is 1.0 (entirely unoccluded) when SSAO is off.
    specular_occlusion: f32,
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
    lightmap_light: vec3<f32>,
    is_orthographic: bool,
    flags: u32,
};

// Creates a PbrInput with default values
fn pbr_input_new() -> PbrInput {
    var pbr_input: PbrInput;

    pbr_input.material = standard_material_new();
    pbr_input.diffuse_occlusion = vec3<f32>(1.0);
    // If SSAO is enabled, then this gets overwritten with proper specular occlusion. If its not, then we get specular environment map unoccluded (we have no data with which to occlude it with).
    pbr_input.specular_occlusion = 1.0;

    pbr_input.frag_coord = vec4<f32>(0.0, 0.0, 0.0, 1.0);
    pbr_input.world_position = vec4<f32>(0.0, 0.0, 0.0, 1.0);
    pbr_input.world_normal = vec3<f32>(0.0, 0.0, 1.0);

    pbr_input.is_orthographic = false;

    pbr_input.N = vec3<f32>(0.0, 0.0, 1.0);
    pbr_input.V = vec3<f32>(1.0, 0.0, 0.0);

    pbr_input.lightmap_light = vec3<f32>(0.0);

    pbr_input.flags = 0u;

    return pbr_input;
}

```

### crates/bevy_pbr/src/render/mesh

```rust
#import bevy_pbr::{
    mesh_functions,
    skinning,
    morph::morph,
    forward_io::{Vertex, VertexOutput},
    view_transformations::position_world_to_clip,
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
        vertex.position += weight * morph(vertex.index, bevy_pbr::morph::position_offset, i);
#ifdef VERTEX_NORMALS
        vertex.normal += weight * morph(vertex.index, bevy_pbr::morph::normal_offset, i);
#endif
#ifdef VERTEX_TANGENTS
        vertex.tangent += vec4(weight * morph(vertex.index, bevy_pbr::morph::tangent_offset, i), 0.0);
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
    var model = skinning::skin_model(vertex.joint_indices, vertex.joint_weights);
#else
    // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
    // See https://github.com/gfx-rs/naga/issues/2416 .
    var model = mesh_functions::get_model_matrix(vertex_no_morph.instance_index);
#endif

#ifdef VERTEX_NORMALS
#ifdef SKINNED
    out.world_normal = skinning::skin_normals(model, vertex.normal);
#else
    out.world_normal = mesh_functions::mesh_normal_local_to_world(
        vertex.normal,
        // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
        // See https://github.com/gfx-rs/naga/issues/2416
        vertex_no_morph.instance_index
    );
#endif
#endif

#ifdef VERTEX_POSITIONS
    out.world_position = mesh_functions::mesh_position_local_to_world(model, vec4<f32>(vertex.position, 1.0));
    out.position = position_world_to_clip(out.world_position.xyz);
#endif

#ifdef VERTEX_UVS
    out.uv = vertex.uv;
#endif

#ifdef VERTEX_UVS_B
    out.uv_b = vertex.uv_b;
#endif

#ifdef VERTEX_TANGENTS
    out.world_tangent = mesh_functions::mesh_tangent_local_to_world(
        model,
        vertex.tangent,
        // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
        // See https://github.com/gfx-rs/naga/issues/2416
        vertex_no_morph.instance_index
    );
#endif

#ifdef VERTEX_COLORS
    out.color = vertex.color;
#endif

#ifdef VERTEX_OUTPUT_INSTANCE_INDEX
    // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
    // See https://github.com/gfx-rs/naga/issues/2416
    out.instance_index = vertex_no_morph.instance_index;
#endif

    return out;
}

@fragment
fn fragment(
    mesh: VertexOutput,
) -> @location(0) vec4<f32> {
#ifdef VERTEX_COLORS
    return mesh.color;
#else
    return vec4<f32>(1.0, 0.0, 1.0, 1.0);
#endif
}

```

### crates/bevy_pbr/src/render/pbr_ambient

```rust
#define_import_path bevy_pbr::ambient

#import bevy_pbr::{
    lighting::{EnvBRDFApprox, F_AB},
    mesh_view_bindings::lights,
}

// A precomputed `NdotV` is provided because it is computed regardless,
// but `world_normal` and the view vector `V` are provided separately for more advanced uses.
fn ambient_light(
    world_position: vec4<f32>,
    world_normal: vec3<f32>,
    V: vec3<f32>,
    NdotV: f32,
    diffuse_color: vec3<f32>,
    specular_color: vec3<f32>,
    perceptual_roughness: f32,
    occlusion: vec3<f32>,
) -> vec3<f32> {
    let diffuse_ambient = EnvBRDFApprox(diffuse_color, F_AB(1.0, NdotV));
    let specular_ambient = EnvBRDFApprox(specular_color, F_AB(perceptual_roughness, NdotV));

    // No real world material has specular values under 0.02, so we use this range as a
    // "pre-baked specular occlusion" that extinguishes the fresnel term, for artistic control.
    // See: https://google.github.io/filament/Filament.html#specularocclusion
    let specular_occlusion = saturate(dot(specular_color, vec3(50.0 * 0.33)));

    return (diffuse_ambient + specular_ambient * specular_occlusion) * lights.ambient_color.rgb * occlusion;
}

```

### crates/bevy_pbr/src/render/mesh_bindings

```rust
#define_import_path bevy_pbr::mesh_bindings

#import bevy_pbr::mesh_types::Mesh

#ifdef PER_OBJECT_BUFFER_BATCH_SIZE
@group(1) @binding(0) var<uniform> mesh: array<Mesh, #{PER_OBJECT_BUFFER_BATCH_SIZE}u>;
#else
@group(1) @binding(0) var<storage> mesh: array<Mesh>;
#endif // PER_OBJECT_BUFFER_BATCH_SIZE

```

### crates/bevy_pbr/src/render/pbr_prepass_functions

```rust
#define_import_path bevy_pbr::pbr_prepass_functions

#import bevy_pbr::{
    prepass_io::VertexOutput,
    prepass_bindings::previous_view_uniforms,
    mesh_view_bindings::view,
    pbr_bindings,
    pbr_types,
}

// Cutoff used for the premultiplied alpha modes BLEND, ADD, and ALPHA_TO_COVERAGE.
const PREMULTIPLIED_ALPHA_CUTOFF = 0.05;

// We can use a simplified version of alpha_discard() here since we only need to handle the alpha_cutoff
fn prepass_alpha_discard(in: VertexOutput) {

#ifdef MAY_DISCARD
    var output_color: vec4<f32> = pbr_bindings::material.base_color;

#ifdef VERTEX_UVS
    let uv_transform = pbr_bindings::material.uv_transform;
    let uv = (uv_transform * vec3(in.uv, 1.0)).xy;
    if (pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_BASE_COLOR_TEXTURE_BIT) != 0u {
        output_color = output_color * textureSampleBias(pbr_bindings::base_color_texture, pbr_bindings::base_color_sampler, uv, view.mip_bias);
    }
#endif // VERTEX_UVS

    let alpha_mode = pbr_bindings::material.flags & pbr_types::STANDARD_MATERIAL_FLAGS_ALPHA_MODE_RESERVED_BITS;
    if alpha_mode == pbr_types::STANDARD_MATERIAL_FLAGS_ALPHA_MODE_MASK {
        if output_color.a < pbr_bindings::material.alpha_cutoff {
            discard;
        }
    } else if (alpha_mode == pbr_types::STANDARD_MATERIAL_FLAGS_ALPHA_MODE_BLEND ||
            alpha_mode == pbr_types::STANDARD_MATERIAL_FLAGS_ALPHA_MODE_ADD ||
            alpha_mode == pbr_types::STANDARD_MATERIAL_FLAGS_ALPHA_MODE_ALPHA_TO_COVERAGE) {
        if output_color.a < PREMULTIPLIED_ALPHA_CUTOFF {
            discard;
        }
    } else if alpha_mode == pbr_types::STANDARD_MATERIAL_FLAGS_ALPHA_MODE_PREMULTIPLIED {
        if all(output_color < vec4(PREMULTIPLIED_ALPHA_CUTOFF)) {
            discard;
        }
    }

#endif // MAY_DISCARD
}

#ifdef MOTION_VECTOR_PREPASS
fn calculate_motion_vector(world_position: vec4<f32>, previous_world_position: vec4<f32>) -> vec2<f32> {
    let clip_position_t = view.unjittered_view_proj * world_position;
    let clip_position = clip_position_t.xy / clip_position_t.w;
    let previous_clip_position_t = previous_view_uniforms.view_proj * previous_world_position;
    let previous_clip_position = previous_clip_position_t.xy / previous_clip_position_t.w;
    // These motion vectors are used as offsets to UV positions and are stored
    // in the range -1,1 to allow offsetting from the one corner to the
    // diagonally-opposite corner in UV coordinates, in either direction.
    // A difference between diagonally-opposite corners of clip space is in the
    // range -2,2, so this needs to be scaled by 0.5. And the V direction goes
    // down where clip space y goes up, so y needs to be flipped.
    return (clip_position - previous_clip_position) * vec2(0.5, -0.5);
}
#endif // MOTION_VECTOR_PREPASS

```

### crates/bevy_pbr/src/render/shadow_sampling

```rust
#define_import_path bevy_pbr::shadow_sampling

#import bevy_pbr::{
    mesh_view_bindings as view_bindings,
    utils::{PI, interleaved_gradient_noise},
    utils,
}
#import bevy_render::maths::orthonormalize

// Do the lookup, using HW 2x2 PCF and comparison
fn sample_shadow_map_hardware(light_local: vec2<f32>, depth: f32, array_index: i32) -> f32 {
#ifdef NO_ARRAY_TEXTURES_SUPPORT
    return textureSampleCompare(
        view_bindings::directional_shadow_textures,
        view_bindings::directional_shadow_textures_sampler,
        light_local,
        depth,
    );
#else
    return textureSampleCompareLevel(
        view_bindings::directional_shadow_textures,
        view_bindings::directional_shadow_textures_sampler,
        light_local,
        array_index,
        depth,
    );
#endif
}

// Numbers determined by trial and error that gave nice results.
const SPOT_SHADOW_TEXEL_SIZE: f32 = 0.0134277345;
const POINT_SHADOW_SCALE: f32 = 0.003;
const POINT_SHADOW_TEMPORAL_OFFSET_SCALE: f32 = 0.5;

// These are the standard MSAA sample point positions from D3D. They were chosen
// to get a reasonable distribution that's not too regular.
//
// https://learn.microsoft.com/en-us/windows/win32/api/d3d11/ne-d3d11-d3d11_standard_multisample_quality_levels?redirectedfrom=MSDN
const D3D_SAMPLE_POINT_POSITIONS: array<vec2<f32>, 8> = array(
    vec2( 0.125, -0.375),
    vec2(-0.125,  0.375),
    vec2( 0.625,  0.125),
    vec2(-0.375, -0.625),
    vec2(-0.625,  0.625),
    vec2(-0.875, -0.125),
    vec2( 0.375,  0.875),
    vec2( 0.875, -0.875),
);

// And these are the coefficients corresponding to the probability distribution
// function of a 2D Gaussian lobe with zero mean and the identity covariance
// matrix at those points.
const D3D_SAMPLE_POINT_COEFFS: array<f32, 8> = array(
    0.157112,
    0.157112,
    0.138651,
    0.130251,
    0.114946,
    0.114946,
    0.107982,
    0.079001,
);

// https://web.archive.org/web/20230210095515/http://the-witness.net/news/2013/09/shadow-mapping-summary-part-1
fn sample_shadow_map_castano_thirteen(light_local: vec2<f32>, depth: f32, array_index: i32) -> f32 {
    let shadow_map_size = vec2<f32>(textureDimensions(view_bindings::directional_shadow_textures));
    let inv_shadow_map_size = 1.0 / shadow_map_size;

    let uv = light_local * shadow_map_size;
    var base_uv = floor(uv + 0.5);
    let s = (uv.x + 0.5 - base_uv.x);
    let t = (uv.y + 0.5 - base_uv.y);
    base_uv -= 0.5;
    base_uv *= inv_shadow_map_size;

    let uw0 = (4.0 - 3.0 * s);
    let uw1 = 7.0;
    let uw2 = (1.0 + 3.0 * s);

    let u0 = (3.0 - 2.0 * s) / uw0 - 2.0;
    let u1 = (3.0 + s) / uw1;
    let u2 = s / uw2 + 2.0;

    let vw0 = (4.0 - 3.0 * t);
    let vw1 = 7.0;
    let vw2 = (1.0 + 3.0 * t);

    let v0 = (3.0 - 2.0 * t) / vw0 - 2.0;
    let v1 = (3.0 + t) / vw1;
    let v2 = t / vw2 + 2.0;

    var sum = 0.0;

    sum += uw0 * vw0 * sample_shadow_map_hardware(base_uv + (vec2(u0, v0) * inv_shadow_map_size), depth, array_index);
    sum += uw1 * vw0 * sample_shadow_map_hardware(base_uv + (vec2(u1, v0) * inv_shadow_map_size), depth, array_index);
    sum += uw2 * vw0 * sample_shadow_map_hardware(base_uv + (vec2(u2, v0) * inv_shadow_map_size), depth, array_index);

    sum += uw0 * vw1 * sample_shadow_map_hardware(base_uv + (vec2(u0, v1) * inv_shadow_map_size), depth, array_index);
    sum += uw1 * vw1 * sample_shadow_map_hardware(base_uv + (vec2(u1, v1) * inv_shadow_map_size), depth, array_index);
    sum += uw2 * vw1 * sample_shadow_map_hardware(base_uv + (vec2(u2, v1) * inv_shadow_map_size), depth, array_index);

    sum += uw0 * vw2 * sample_shadow_map_hardware(base_uv + (vec2(u0, v2) * inv_shadow_map_size), depth, array_index);
    sum += uw1 * vw2 * sample_shadow_map_hardware(base_uv + (vec2(u1, v2) * inv_shadow_map_size), depth, array_index);
    sum += uw2 * vw2 * sample_shadow_map_hardware(base_uv + (vec2(u2, v2) * inv_shadow_map_size), depth, array_index);

    return sum * (1.0 / 144.0);
}

fn map(min1: f32, max1: f32, min2: f32, max2: f32, value: f32) -> f32 {
    return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
}

// Creates a random rotation matrix using interleaved gradient noise.
//
// See: https://www.iryoku.com/next-generation-post-processing-in-call-of-duty-advanced-warfare/
fn random_rotation_matrix(scale: vec2<f32>) -> mat2x2<f32> {
    let random_angle = 2.0 * PI * interleaved_gradient_noise(
        scale, view_bindings::globals.frame_count);
    let m = vec2(sin(random_angle), cos(random_angle));
    return mat2x2(
        m.y, -m.x,
        m.x, m.y
    );
}

fn sample_shadow_map_jimenez_fourteen(light_local: vec2<f32>, depth: f32, array_index: i32, texel_size: f32) -> f32 {
    let shadow_map_size = vec2<f32>(textureDimensions(view_bindings::directional_shadow_textures));
    let rotation_matrix = random_rotation_matrix(light_local * shadow_map_size);

    // Empirically chosen fudge factor to make PCF look better across different CSM cascades
    let f = map(0.00390625, 0.022949219, 0.015, 0.035, texel_size);
    let uv_offset_scale = f / (texel_size * shadow_map_size);

    // https://www.iryoku.com/next-generation-post-processing-in-call-of-duty-advanced-warfare (slides 120-135)
    let sample_offset0 = (rotation_matrix * utils::SPIRAL_OFFSET_0_) * uv_offset_scale;
    let sample_offset1 = (rotation_matrix * utils::SPIRAL_OFFSET_1_) * uv_offset_scale;
    let sample_offset2 = (rotation_matrix * utils::SPIRAL_OFFSET_2_) * uv_offset_scale;
    let sample_offset3 = (rotation_matrix * utils::SPIRAL_OFFSET_3_) * uv_offset_scale;
    let sample_offset4 = (rotation_matrix * utils::SPIRAL_OFFSET_4_) * uv_offset_scale;
    let sample_offset5 = (rotation_matrix * utils::SPIRAL_OFFSET_5_) * uv_offset_scale;
    let sample_offset6 = (rotation_matrix * utils::SPIRAL_OFFSET_6_) * uv_offset_scale;
    let sample_offset7 = (rotation_matrix * utils::SPIRAL_OFFSET_7_) * uv_offset_scale;

    var sum = 0.0;
    sum += sample_shadow_map_hardware(light_local + sample_offset0, depth, array_index);
    sum += sample_shadow_map_hardware(light_local + sample_offset1, depth, array_index);
    sum += sample_shadow_map_hardware(light_local + sample_offset2, depth, array_index);
    sum += sample_shadow_map_hardware(light_local + sample_offset3, depth, array_index);
    sum += sample_shadow_map_hardware(light_local + sample_offset4, depth, array_index);
    sum += sample_shadow_map_hardware(light_local + sample_offset5, depth, array_index);
    sum += sample_shadow_map_hardware(light_local + sample_offset6, depth, array_index);
    sum += sample_shadow_map_hardware(light_local + sample_offset7, depth, array_index);
    return sum / 8.0;
}

fn sample_shadow_map(light_local: vec2<f32>, depth: f32, array_index: i32, texel_size: f32) -> f32 {
#ifdef SHADOW_FILTER_METHOD_GAUSSIAN
    return sample_shadow_map_castano_thirteen(light_local, depth, array_index);
#else ifdef SHADOW_FILTER_METHOD_TEMPORAL
    return sample_shadow_map_jimenez_fourteen(light_local, depth, array_index, texel_size);
#else ifdef SHADOW_FILTER_METHOD_HARDWARE_2X2
    return sample_shadow_map_hardware(light_local, depth, array_index);
#else
    // This needs a default return value to avoid shader compilation errors if it's compiled with no SHADOW_FILTER_METHOD_* defined.
    // (eg. if the normal prepass is enabled it ends up compiling this due to the normal prepass depending on pbr_functions, which depends on shadows)
    // This should never actually get used, as anyone using bevy's lighting/shadows should always have a SHADOW_FILTER_METHOD defined.
    // Set to 0 to make it obvious that something is wrong.
    return 0.0;
#endif
}

// NOTE: Due to the non-uniform control flow in `shadows::fetch_point_shadow`,
// we must use the Level variant of textureSampleCompare to avoid undefined
// behavior due to some of the fragments in a quad (2x2 fragments) being
// processed not being sampled, and this messing with mip-mapping functionality.
// The shadow maps have no mipmaps so Level just samples from LOD 0.
fn sample_shadow_cubemap_hardware(light_local: vec3<f32>, depth: f32, light_id: u32) -> f32 {
#ifdef NO_CUBE_ARRAY_TEXTURES_SUPPORT
    return textureSampleCompare(view_bindings::point_shadow_textures, view_bindings::point_shadow_textures_sampler, light_local, depth);
#else
    return textureSampleCompareLevel(view_bindings::point_shadow_textures, view_bindings::point_shadow_textures_sampler, light_local, i32(light_id), depth);
#endif
}

fn sample_shadow_cubemap_at_offset(
    position: vec2<f32>,
    coeff: f32,
    x_basis: vec3<f32>,
    y_basis: vec3<f32>,
    light_local: vec3<f32>,
    depth: f32,
    light_id: u32,
) -> f32 {
    return sample_shadow_cubemap_hardware(
        light_local + position.x * x_basis + position.y * y_basis,
        depth,
        light_id
    ) * coeff;
}

// This more or less does what Castano13 does, but in 3D space. Castano13 is
// essentially an optimized 2D Gaussian filter that takes advantage of the
// bilinear filtering hardware to reduce the number of samples needed. This
// trick doesn't apply to cubemaps, so we manually apply a Gaussian filter over
// the standard 8xMSAA pattern instead.
fn sample_shadow_cubemap_gaussian(
    light_local: vec3<f32>,
    depth: f32,
    scale: f32,
    distance_to_light: f32,
    light_id: u32,
) -> f32 {
    // Create an orthonormal basis so we can apply a 2D sampling pattern to a
    // cubemap.
    var up = vec3(0.0, 1.0, 0.0);
    if (dot(up, normalize(light_local)) > 0.99) {
        up = vec3(1.0, 0.0, 0.0);   // Avoid creating a degenerate basis.
    }
    let basis = orthonormalize(light_local, up) * scale * distance_to_light;

    var sum: f32 = 0.0;
    sum += sample_shadow_cubemap_at_offset(
        D3D_SAMPLE_POINT_POSITIONS[0], D3D_SAMPLE_POINT_COEFFS[0],
        basis[0], basis[1], light_local, depth, light_id);
    sum += sample_shadow_cubemap_at_offset(
        D3D_SAMPLE_POINT_POSITIONS[1], D3D_SAMPLE_POINT_COEFFS[1],
        basis[0], basis[1], light_local, depth, light_id);
    sum += sample_shadow_cubemap_at_offset(
        D3D_SAMPLE_POINT_POSITIONS[2], D3D_SAMPLE_POINT_COEFFS[2],
        basis[0], basis[1], light_local, depth, light_id);
    sum += sample_shadow_cubemap_at_offset(
        D3D_SAMPLE_POINT_POSITIONS[3], D3D_SAMPLE_POINT_COEFFS[3],
        basis[0], basis[1], light_local, depth, light_id);
    sum += sample_shadow_cubemap_at_offset(
        D3D_SAMPLE_POINT_POSITIONS[4], D3D_SAMPLE_POINT_COEFFS[4],
        basis[0], basis[1], light_local, depth, light_id);
    sum += sample_shadow_cubemap_at_offset(
        D3D_SAMPLE_POINT_POSITIONS[5], D3D_SAMPLE_POINT_COEFFS[5],
        basis[0], basis[1], light_local, depth, light_id);
    sum += sample_shadow_cubemap_at_offset(
        D3D_SAMPLE_POINT_POSITIONS[6], D3D_SAMPLE_POINT_COEFFS[6],
        basis[0], basis[1], light_local, depth, light_id);
    sum += sample_shadow_cubemap_at_offset(
        D3D_SAMPLE_POINT_POSITIONS[7], D3D_SAMPLE_POINT_COEFFS[7],
        basis[0], basis[1], light_local, depth, light_id);
    return sum;
}

// This is a port of the Jimenez14 filter above to the 3D space. It jitters the
// points in the spiral pattern after first creating a 2D orthonormal basis
// along the principal light direction.
fn sample_shadow_cubemap_temporal(
    light_local: vec3<f32>,
    depth: f32,
    scale: f32,
    distance_to_light: f32,
    light_id: u32,
) -> f32 {
    // Create an orthonormal basis so we can apply a 2D sampling pattern to a
    // cubemap.
    var up = vec3(0.0, 1.0, 0.0);
    if (dot(up, normalize(light_local)) > 0.99) {
        up = vec3(1.0, 0.0, 0.0);   // Avoid creating a degenerate basis.
    }
    let basis = orthonormalize(light_local, up) * scale * distance_to_light;

    let rotation_matrix = random_rotation_matrix(vec2(1.0));

    let sample_offset0 = rotation_matrix * utils::SPIRAL_OFFSET_0_ *
        POINT_SHADOW_TEMPORAL_OFFSET_SCALE;
    let sample_offset1 = rotation_matrix * utils::SPIRAL_OFFSET_1_ *
        POINT_SHADOW_TEMPORAL_OFFSET_SCALE;
    let sample_offset2 = rotation_matrix * utils::SPIRAL_OFFSET_2_ *
        POINT_SHADOW_TEMPORAL_OFFSET_SCALE;
    let sample_offset3 = rotation_matrix * utils::SPIRAL_OFFSET_3_ *
        POINT_SHADOW_TEMPORAL_OFFSET_SCALE;
    let sample_offset4 = rotation_matrix * utils::SPIRAL_OFFSET_4_ *
        POINT_SHADOW_TEMPORAL_OFFSET_SCALE;
    let sample_offset5 = rotation_matrix * utils::SPIRAL_OFFSET_5_ *
        POINT_SHADOW_TEMPORAL_OFFSET_SCALE;
    let sample_offset6 = rotation_matrix * utils::SPIRAL_OFFSET_6_ *
        POINT_SHADOW_TEMPORAL_OFFSET_SCALE;
    let sample_offset7 = rotation_matrix * utils::SPIRAL_OFFSET_7_ *
        POINT_SHADOW_TEMPORAL_OFFSET_SCALE;

    var sum: f32 = 0.0;
    sum += sample_shadow_cubemap_at_offset(
        sample_offset0, 0.125, basis[0], basis[1], light_local, depth, light_id);
    sum += sample_shadow_cubemap_at_offset(
        sample_offset1, 0.125, basis[0], basis[1], light_local, depth, light_id);
    sum += sample_shadow_cubemap_at_offset(
        sample_offset2, 0.125, basis[0], basis[1], light_local, depth, light_id);
    sum += sample_shadow_cubemap_at_offset(
        sample_offset3, 0.125, basis[0], basis[1], light_local, depth, light_id);
    sum += sample_shadow_cubemap_at_offset(
        sample_offset4, 0.125, basis[0], basis[1], light_local, depth, light_id);
    sum += sample_shadow_cubemap_at_offset(
        sample_offset5, 0.125, basis[0], basis[1], light_local, depth, light_id);
    sum += sample_shadow_cubemap_at_offset(
        sample_offset6, 0.125, basis[0], basis[1], light_local, depth, light_id);
    sum += sample_shadow_cubemap_at_offset(
        sample_offset7, 0.125, basis[0], basis[1], light_local, depth, light_id);
    return sum;
}

fn sample_shadow_cubemap(
    light_local: vec3<f32>,
    distance_to_light: f32,
    depth: f32,
    light_id: u32,
) -> f32 {
#ifdef SHADOW_FILTER_METHOD_GAUSSIAN
    return sample_shadow_cubemap_gaussian(
        light_local, depth, POINT_SHADOW_SCALE, distance_to_light, light_id);
#else ifdef SHADOW_FILTER_METHOD_TEMPORAL
    return sample_shadow_cubemap_temporal(
        light_local, depth, POINT_SHADOW_SCALE, distance_to_light, light_id);
#else ifdef SHADOW_FILTER_METHOD_HARDWARE_2X2
    return sample_shadow_cubemap_hardware(light_local, depth, light_id);
#else
    // This needs a default return value to avoid shader compilation errors if it's compiled with no SHADOW_FILTER_METHOD_* defined.
    // (eg. if the normal prepass is enabled it ends up compiling this due to the normal prepass depending on pbr_functions, which depends on shadows)
    // This should never actually get used, as anyone using bevy's lighting/shadows should always have a SHADOW_FILTER_METHOD defined.
    // Set to 0 to make it obvious that something is wrong.
    return 0.0;
#endif
}

```

### crates/bevy_pbr/src/render/mesh_view_types

```rust
#define_import_path bevy_pbr::mesh_view_types

struct PointLight {
    // For point lights: the lower-right 2x2 values of the projection matrix [2][2] [2][3] [3][2] [3][3]
    // For spot lights: the direction (x,z), spot_scale and spot_offset
    light_custom_data: vec4<f32>,
    color_inverse_square_range: vec4<f32>,
    position_radius: vec4<f32>,
    // 'flags' is a bit field indicating various options. u32 is 32 bits so we have up to 32 options.
    flags: u32,
    shadow_depth_bias: f32,
    shadow_normal_bias: f32,
    spot_light_tan_angle: f32,
};

const POINT_LIGHT_FLAGS_SHADOWS_ENABLED_BIT: u32   = 1u;
const POINT_LIGHT_FLAGS_SPOT_LIGHT_Y_NEGATIVE: u32 = 2u;

struct DirectionalCascade {
    view_projection: mat4x4<f32>,
    texel_size: f32,
    far_bound: f32,
}

struct DirectionalLight {
    cascades: array<DirectionalCascade, #{MAX_CASCADES_PER_LIGHT}>,
    color: vec4<f32>,
    direction_to_light: vec3<f32>,
    // 'flags' is a bit field indicating various options. u32 is 32 bits so we have up to 32 options.
    flags: u32,
    shadow_depth_bias: f32,
    shadow_normal_bias: f32,
    num_cascades: u32,
    cascades_overlap_proportion: f32,
    depth_texture_base_index: u32,
    render_layers: u32,
};

const DIRECTIONAL_LIGHT_FLAGS_SHADOWS_ENABLED_BIT: u32 = 1u;

struct Lights {
    // NOTE: this array size must be kept in sync with the constants defined in bevy_pbr/src/render/light.rs
    directional_lights: array<DirectionalLight, #{MAX_DIRECTIONAL_LIGHTS}u>,
    ambient_color: vec4<f32>,
    // x/y/z dimensions and n_clusters in w
    cluster_dimensions: vec4<u32>,
    // xy are vec2<f32>(cluster_dimensions.xy) / vec2<f32>(view.width, view.height)
    //
    // For perspective projections:
    // z is cluster_dimensions.z / log(far / near)
    // w is cluster_dimensions.z * log(near) / log(far / near)
    //
    // For orthographic projections:
    // NOTE: near and far are +ve but -z is infront of the camera
    // z is -near
    // w is cluster_dimensions.z / (-far - -near)
    cluster_factors: vec4<f32>,
    n_directional_lights: u32,
    spot_light_shadowmap_offset: i32,
    environment_map_smallest_specular_mip_level: u32,
    environment_map_intensity: f32,
};

struct Fog {
    base_color: vec4<f32>,
    directional_light_color: vec4<f32>,
    // `be` and `bi` are allocated differently depending on the fog mode
    //
    // For Linear Fog:
    //     be.x = start, be.y = end
    // For Exponential and ExponentialSquared Fog:
    //     be.x = density
    // For Atmospheric Fog:
    //     be = per-channel extinction density
    //     bi = per-channel inscattering density
    be: vec3<f32>,
    directional_light_exponent: f32,
    bi: vec3<f32>,
    mode: u32,
}

// Important: These must be kept in sync with `fog.rs`
const FOG_MODE_OFF: u32                   = 0u;
const FOG_MODE_LINEAR: u32                = 1u;
const FOG_MODE_EXPONENTIAL: u32           = 2u;
const FOG_MODE_EXPONENTIAL_SQUARED: u32   = 3u;
const FOG_MODE_ATMOSPHERIC: u32           = 4u;

#if AVAILABLE_STORAGE_BUFFER_BINDINGS >= 3
struct PointLights {
    data: array<PointLight>,
};
struct ClusterLightIndexLists {
    data: array<u32>,
};
struct ClusterOffsetsAndCounts {
    data: array<vec4<u32>>,
};
#else
struct PointLights {
    data: array<PointLight, 256u>,
};
struct ClusterLightIndexLists {
    // each u32 contains 4 u8 indices into the PointLights array
    data: array<vec4<u32>, 1024u>,
};
struct ClusterOffsetsAndCounts {
    // each u32 contains a 24-bit index into ClusterLightIndexLists in the high 24 bits
    // and an 8-bit count of the number of lights in the low 8 bits
    data: array<vec4<u32>, 1024u>,
};
#endif

struct LightProbe {
    // This is stored as the transpose in order to save space in this structure.
    // It'll be transposed in the `environment_map_light` function.
    inverse_transpose_transform: mat3x4<f32>,
    cubemap_index: i32,
    intensity: f32,
};

struct LightProbes {
    // This must match `MAX_VIEW_REFLECTION_PROBES` on the Rust side.
    reflection_probes: array<LightProbe, 8u>,
    irradiance_volumes: array<LightProbe, 8u>,
    reflection_probe_count: i32,
    irradiance_volume_count: i32,
    // The index of the view environment map cubemap binding, or -1 if there's
    // no such cubemap.
    view_cubemap_index: i32,
    // The smallest valid mipmap level for the specular environment cubemap
    // associated with the view.
    smallest_specular_mip_level_for_view: u32,
    // The intensity of the environment map associated with the view.
    intensity_for_view: f32,
};

```

### crates/bevy_pbr/src/render/forward_io

```rust
#define_import_path bevy_pbr::forward_io

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
#ifdef VERTEX_UVS_B
    @location(3) uv_b: vec2<f32>,
#endif
#ifdef VERTEX_TANGENTS
    @location(4) tangent: vec4<f32>,
#endif
#ifdef VERTEX_COLORS
    @location(5) color: vec4<f32>,
#endif
#ifdef SKINNED
    @location(6) joint_indices: vec4<u32>,
    @location(7) joint_weights: vec4<f32>,
#endif
#ifdef MORPH_TARGETS
    @builtin(vertex_index) index: u32,
#endif
};

struct VertexOutput {
    // This is `clip position` when the struct is used as a vertex stage output
    // and `frag coord` when used as a fragment stage input
    @builtin(position) position: vec4<f32>,
    @location(0) world_position: vec4<f32>,
    @location(1) world_normal: vec3<f32>,
#ifdef VERTEX_UVS
    @location(2) uv: vec2<f32>,
#endif
#ifdef VERTEX_UVS_B
    @location(3) uv_b: vec2<f32>,
#endif
#ifdef VERTEX_TANGENTS
    @location(4) world_tangent: vec4<f32>,
#endif
#ifdef VERTEX_COLORS
    @location(5) color: vec4<f32>,
#endif
#ifdef VERTEX_OUTPUT_INSTANCE_INDEX
    @location(6) @interpolate(flat) instance_index: u32,
#endif
}

struct FragmentOutput {
    @location(0) color: vec4<f32>,
}

```

### crates/bevy_pbr/src/render/rgb9e5

```rust
#define_import_path bevy_pbr::rgb9e5

const RGB9E5_EXPONENT_BITS        = 5u;
const RGB9E5_MANTISSA_BITS        = 9;
const RGB9E5_MANTISSA_BITSU       = 9u;
const RGB9E5_EXP_BIAS             = 15;
const RGB9E5_MAX_VALID_BIASED_EXP = 31u;

//#define MAX_RGB9E5_EXP               (RGB9E5_MAX_VALID_BIASED_EXP - RGB9E5_EXP_BIAS)
//#define RGB9E5_MANTISSA_VALUES       (1<<RGB9E5_MANTISSA_BITS)
//#define MAX_RGB9E5_MANTISSA          (RGB9E5_MANTISSA_VALUES-1)
//#define MAX_RGB9E5                   ((f32(MAX_RGB9E5_MANTISSA))/RGB9E5_MANTISSA_VALUES * (1<<MAX_RGB9E5_EXP))
//#define EPSILON_RGB9E5_              ((1.0/RGB9E5_MANTISSA_VALUES) / (1<<RGB9E5_EXP_BIAS))

const MAX_RGB9E5_EXP              = 16u;
const RGB9E5_MANTISSA_VALUES      = 512;
const MAX_RGB9E5_MANTISSA         = 511;
const MAX_RGB9E5_MANTISSAU        = 511u;
const MAX_RGB9E5_                 = 65408.0;
const EPSILON_RGB9E5_             = 0.000000059604645;

fn floor_log2_(x: f32) -> i32 {
    let f = bitcast<u32>(x);
    let biasedexponent = (f & 0x7F800000u) >> 23u;
    return i32(biasedexponent) - 127;
}

// https://www.khronos.org/registry/OpenGL/extensions/EXT/EXT_texture_shared_exponent.txt
fn vec3_to_rgb9e5_(rgb_in: vec3<f32>) -> u32 {
    let rgb = clamp(rgb_in, vec3(0.0), vec3(MAX_RGB9E5_));

    let maxrgb = max(rgb.r, max(rgb.g, rgb.b));
    var exp_shared = max(-RGB9E5_EXP_BIAS - 1, floor_log2_(maxrgb)) + 1 + RGB9E5_EXP_BIAS;
    var denom = exp2(f32(exp_shared - RGB9E5_EXP_BIAS - RGB9E5_MANTISSA_BITS));

    let maxm = i32(floor(maxrgb / denom + 0.5));
    if (maxm == RGB9E5_MANTISSA_VALUES) {
        denom *= 2.0;
        exp_shared += 1;
    }

    let n = vec3<u32>(floor(rgb / denom + 0.5));
    
    return (u32(exp_shared) << 27u) | (n.b << 18u) | (n.g << 9u) | (n.r << 0u);
}

// Builtin extractBits() is not working on WEBGL or DX12
// DX12: HLSL: Unimplemented("write_expr_math ExtractBits")
fn extract_bits(value: u32, offset: u32, bits: u32) -> u32 {
    let mask = (1u << bits) - 1u;
    return (value >> offset) & mask;
}

fn rgb9e5_to_vec3_(v: u32) -> vec3<f32> {
    let exponent = i32(extract_bits(v, 27u, RGB9E5_EXPONENT_BITS)) - RGB9E5_EXP_BIAS - RGB9E5_MANTISSA_BITS;
    let scale = exp2(f32(exponent));

    return vec3(
        f32(extract_bits(v, 0u, RGB9E5_MANTISSA_BITSU)),
        f32(extract_bits(v, 9u, RGB9E5_MANTISSA_BITSU)),
        f32(extract_bits(v, 18u, RGB9E5_MANTISSA_BITSU))
    ) * scale;
}

```

### crates/bevy_pbr/src/render/morph

```rust
#define_import_path bevy_pbr::morph

#ifdef MORPH_TARGETS

#import bevy_pbr::mesh_types::MorphWeights;

@group(1) @binding(2) var<uniform> morph_weights: MorphWeights;
@group(1) @binding(3) var morph_targets: texture_3d<f32>;

// NOTE: Those are the "hardcoded" values found in `MorphAttributes` struct
// in crates/bevy_render/src/mesh/morph/visitors.rs
// In an ideal world, the offsets are established dynamically and passed as #defines
// to the shader, but it's out of scope for the initial implementation of morph targets.
const position_offset: u32 = 0u;
const normal_offset: u32 = 3u;
const tangent_offset: u32 = 6u;
const total_component_count: u32 = 9u;

fn layer_count() -> u32 {
    let dimensions = textureDimensions(morph_targets);
    return u32(dimensions.z);
}
fn component_texture_coord(vertex_index: u32, component_offset: u32) -> vec2<u32> {
    let width = u32(textureDimensions(morph_targets).x);
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
    return textureLoad(morph_targets, vec3(coord, weight), 0).r;
}
fn morph(vertex_index: u32, component_offset: u32, weight_index: u32) -> vec3<f32> {
    return vec3<f32>(
        morph_pixel(vertex_index, component_offset, weight_index),
        morph_pixel(vertex_index, component_offset + 1u, weight_index),
        morph_pixel(vertex_index, component_offset + 2u, weight_index),
    );
}

#endif // MORPH_TARGETS

```

### crates/bevy_pbr/src/render/clustered_forward

```rust
#define_import_path bevy_pbr::clustered_forward

#import bevy_pbr::{
    mesh_view_bindings as bindings,
    utils::{hsv2rgb, rand_f},
}

// NOTE: Keep in sync with bevy_pbr/src/light.rs
fn view_z_to_z_slice(view_z: f32, is_orthographic: bool) -> u32 {
    var z_slice: u32 = 0u;
    if is_orthographic {
        // NOTE: view_z is correct in the orthographic case
        z_slice = u32(floor((view_z - bindings::lights.cluster_factors.z) * bindings::lights.cluster_factors.w));
    } else {
        // NOTE: had to use -view_z to make it positive else log(negative) is nan
        z_slice = u32(log(-view_z) * bindings::lights.cluster_factors.z - bindings::lights.cluster_factors.w + 1.0);
    }
    // NOTE: We use min as we may limit the far z plane used for clustering to be closer than
    // the furthest thing being drawn. This means that we need to limit to the maximum cluster.
    return min(z_slice, bindings::lights.cluster_dimensions.z - 1u);
}

fn fragment_cluster_index(frag_coord: vec2<f32>, view_z: f32, is_orthographic: bool) -> u32 {
    let xy = vec2<u32>(floor((frag_coord - bindings::view.viewport.xy) * bindings::lights.cluster_factors.xy));
    let z_slice = view_z_to_z_slice(view_z, is_orthographic);
    // NOTE: Restricting cluster index to avoid undefined behavior when accessing uniform buffer
    // arrays based on the cluster index.
    return min(
        (xy.y * bindings::lights.cluster_dimensions.x + xy.x) * bindings::lights.cluster_dimensions.z + z_slice,
        bindings::lights.cluster_dimensions.w - 1u
    );
}

// this must match CLUSTER_COUNT_SIZE in light.rs
const CLUSTER_COUNT_SIZE = 9u;
fn unpack_offset_and_counts(cluster_index: u32) -> vec3<u32> {
#if AVAILABLE_STORAGE_BUFFER_BINDINGS >= 3
    return bindings::cluster_offsets_and_counts.data[cluster_index].xyz;
#else
    let offset_and_counts = bindings::cluster_offsets_and_counts.data[cluster_index >> 2u][cluster_index & ((1u << 2u) - 1u)];
    //  [ 31     ..     18 | 17      ..      9 | 8       ..     0 ]
    //  [      offset      | point light count | spot light count ]
    return vec3<u32>(
        (offset_and_counts >> (CLUSTER_COUNT_SIZE * 2u)) & ((1u << (32u - (CLUSTER_COUNT_SIZE * 2u))) - 1u),
        (offset_and_counts >> CLUSTER_COUNT_SIZE)        & ((1u << CLUSTER_COUNT_SIZE) - 1u),
        offset_and_counts                                & ((1u << CLUSTER_COUNT_SIZE) - 1u),
    );
#endif
}

fn get_light_id(index: u32) -> u32 {
#if AVAILABLE_STORAGE_BUFFER_BINDINGS >= 3
    return bindings::cluster_light_index_lists.data[index];
#else
    // The index is correct but in cluster_light_index_lists we pack 4 u8s into a u32
    // This means the index into cluster_light_index_lists is index / 4
    let indices = bindings::cluster_light_index_lists.data[index >> 4u][(index >> 2u) & ((1u << 2u) - 1u)];
    // And index % 4 gives the sub-index of the u8 within the u32 so we shift by 8 * sub-index
    return (indices >> (8u * (index & ((1u << 2u) - 1u)))) & ((1u << 8u) - 1u);
#endif
}

fn cluster_debug_visualization(
    input_color: vec4<f32>,
    view_z: f32,
    is_orthographic: bool,
    offset_and_counts: vec3<u32>,
    cluster_index: u32,
) -> vec4<f32> {
    var output_color = input_color;

    // Cluster allocation debug (using 'over' alpha blending)
#ifdef CLUSTERED_FORWARD_DEBUG_Z_SLICES
    // NOTE: This debug mode visualises the z-slices
    let cluster_overlay_alpha = 0.1;
    var z_slice: u32 = view_z_to_z_slice(view_z, is_orthographic);
    // A hack to make the colors alternate a bit more
    if (z_slice & 1u) == 1u {
        z_slice = z_slice + bindings::lights.cluster_dimensions.z / 2u;
    }
    let slice_color = hsv2rgb(f32(z_slice) / f32(bindings::lights.cluster_dimensions.z + 1u), 1.0, 0.5);
    output_color = vec4<f32>(
        (1.0 - cluster_overlay_alpha) * output_color.rgb + cluster_overlay_alpha * slice_color,
        output_color.a
    );
#endif // CLUSTERED_FORWARD_DEBUG_Z_SLICES
#ifdef CLUSTERED_FORWARD_DEBUG_CLUSTER_LIGHT_COMPLEXITY
    // NOTE: This debug mode visualises the number of lights within the cluster that contains
    // the fragment. It shows a sort of lighting complexity measure.
    let cluster_overlay_alpha = 0.1;
    let max_light_complexity_per_cluster = 64.0;
    output_color.r = (1.0 - cluster_overlay_alpha) * output_color.r + cluster_overlay_alpha * smoothStep(0.0, max_light_complexity_per_cluster, f32(offset_and_counts[1] + offset_and_counts[2]));
    output_color.g = (1.0 - cluster_overlay_alpha) * output_color.g + cluster_overlay_alpha * (1.0 - smoothStep(0.0, max_light_complexity_per_cluster, f32(offset_and_counts[1] + offset_and_counts[2])));
#endif // CLUSTERED_FORWARD_DEBUG_CLUSTER_LIGHT_COMPLEXITY
#ifdef CLUSTERED_FORWARD_DEBUG_CLUSTER_COHERENCY
    // NOTE: Visualizes the cluster to which the fragment belongs
    let cluster_overlay_alpha = 0.1;
    var rng = cluster_index;
    let cluster_color = hsv2rgb(rand_f(&rng), 1.0, 0.5);
    output_color = vec4<f32>(
        (1.0 - cluster_overlay_alpha) * output_color.rgb + cluster_overlay_alpha * cluster_color,
        output_color.a
    );
#endif // CLUSTERED_FORWARD_DEBUG_CLUSTER_COHERENCY

    return output_color;
}

```

### crates/bevy_pbr/src/render/mesh_functions

```rust
#define_import_path bevy_pbr::mesh_functions

#import bevy_pbr::{
    mesh_view_bindings::view,
    mesh_bindings::mesh,
    mesh_types::MESH_FLAGS_SIGN_DETERMINANT_MODEL_3X3_BIT,
    view_transformations::position_world_to_clip,
}
#import bevy_render::maths::{affine3_to_square, mat2x4_f32_to_mat3x3_unpack}


fn get_model_matrix(instance_index: u32) -> mat4x4<f32> {
    return affine3_to_square(mesh[instance_index].model);
}

fn get_previous_model_matrix(instance_index: u32) -> mat4x4<f32> {
    return affine3_to_square(mesh[instance_index].previous_model);
}

fn mesh_position_local_to_world(model: mat4x4<f32>, vertex_position: vec4<f32>) -> vec4<f32> {
    return model * vertex_position;
}

// NOTE: The intermediate world_position assignment is important
// for precision purposes when using the 'equals' depth comparison
// function.
fn mesh_position_local_to_clip(model: mat4x4<f32>, vertex_position: vec4<f32>) -> vec4<f32> {
    let world_position = mesh_position_local_to_world(model, vertex_position);
    return position_world_to_clip(world_position.xyz);
}

fn mesh_normal_local_to_world(vertex_normal: vec3<f32>, instance_index: u32) -> vec3<f32> {
    // NOTE: The mikktspace method of normal mapping requires that the world normal is
    // re-normalized in the vertex shader to match the way mikktspace bakes vertex tangents
    // and normal maps so that the exact inverse process is applied when shading. Blender, Unity,
    // Unreal Engine, Godot, and more all use the mikktspace method.
    // We only skip normalization for invalid normals so that they don't become NaN.
    // Do not change this code unless you really know what you are doing.
    // http://www.mikktspace.com/
    if any(vertex_normal != vec3<f32>(0.0)) {
        return normalize(
            mat2x4_f32_to_mat3x3_unpack(
                mesh[instance_index].inverse_transpose_model_a,
                mesh[instance_index].inverse_transpose_model_b,
            ) * vertex_normal
        );
    } else {
        return vertex_normal;
    }
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
    // Unreal Engine, Godot, and more all use the mikktspace method.
    // We only skip normalization for invalid tangents so that they don't become NaN.
    // Do not change this code unless you really know what you are doing.
    // http://www.mikktspace.com/
    if any(vertex_tangent != vec4<f32>(0.0)) {
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
    } else {
        return vertex_tangent;
    }
}

```

### crates/bevy_pbr/src/render/pbr_transmission

```rust
#define_import_path bevy_pbr::transmission

#import bevy_pbr::{
    lighting,
    prepass_utils,
    utils::{PI, interleaved_gradient_noise},
    utils,
    mesh_view_bindings as view_bindings,
};

#import bevy_core_pipeline::tonemapping::{
    approximate_inverse_tone_mapping
};

fn specular_transmissive_light(world_position: vec4<f32>, frag_coord: vec3<f32>, view_z: f32, N: vec3<f32>, V: vec3<f32>, F0: vec3<f32>, ior: f32, thickness: f32, perceptual_roughness: f32, specular_transmissive_color: vec3<f32>, transmitted_environment_light_specular: vec3<f32>) -> vec3<f32> {
    // Calculate the ratio between refaction indexes. Assume air/vacuum for the space outside the mesh
    let eta = 1.0 / ior;

    // Calculate incidence vector (opposite to view vector) and its dot product with the mesh normal
    let I = -V;
    let NdotI = dot(N, I);

    // Calculate refracted direction using Snell's law
    let k = 1.0 - eta * eta * (1.0 - NdotI * NdotI);
    let T = eta * I - (eta * NdotI + sqrt(k)) * N;

    // Calculate the exit position of the refracted ray, by propagating refacted direction through thickness
    let exit_position = world_position.xyz + T * thickness;

    // Transform exit_position into clip space
    let clip_exit_position = view_bindings::view.view_proj * vec4<f32>(exit_position, 1.0);

    // Scale / offset position so that coordinate is in right space for sampling transmissive background texture
    let offset_position = (clip_exit_position.xy / clip_exit_position.w) * vec2<f32>(0.5, -0.5) + 0.5;

    // Fetch background color
    var background_color: vec4<f32>;
    if perceptual_roughness == 0.0 {
        // If the material has zero roughness, we can use a faster approach without the blur
        background_color = fetch_transmissive_background_non_rough(offset_position, frag_coord);
    } else {
        background_color = fetch_transmissive_background(offset_position, frag_coord, view_z, perceptual_roughness);
    }

    // Compensate for exposure, since the background color is coming from an already exposure-adjusted texture
    background_color = vec4(background_color.rgb / view_bindings::view.exposure, background_color.a);

    // Dot product of the refracted direction with the exit normal (Note: We assume the exit normal is the entry normal but inverted)
    let MinusNdotT = dot(-N, T);

    // Calculate 1.0 - fresnel factor (how much light is _NOT_ reflected, i.e. how much is transmitted)
    let F = vec3(1.0) - lighting::fresnel(F0, MinusNdotT);

    // Calculate final color by applying fresnel multiplied specular transmissive color to a mix of background color and transmitted specular environment light
    return F * specular_transmissive_color * mix(transmitted_environment_light_specular, background_color.rgb, background_color.a);
}

fn fetch_transmissive_background_non_rough(offset_position: vec2<f32>, frag_coord: vec3<f32>) -> vec4<f32> {
    var background_color = textureSampleLevel(
        view_bindings::view_transmission_texture,
        view_bindings::view_transmission_sampler,
        offset_position,
        0.0
    );

#ifdef DEPTH_PREPASS
#ifndef WEBGL2
    // Use depth prepass data to reject values that are in front of the current fragment
    if prepass_utils::prepass_depth(vec4<f32>(offset_position * view_bindings::view.viewport.zw, 0.0, 0.0), 0u) > frag_coord.z {
        background_color.a = 0.0;
    }
#endif
#endif

#ifdef TONEMAP_IN_SHADER
    background_color = approximate_inverse_tone_mapping(background_color, view_bindings::view.color_grading);
#endif

    return background_color;
}

fn fetch_transmissive_background(offset_position: vec2<f32>, frag_coord: vec3<f32>, view_z: f32, perceptual_roughness: f32) -> vec4<f32> {
    // Calculate view aspect ratio, used to scale offset so that it's proportionate
    let aspect = view_bindings::view.viewport.z / view_bindings::view.viewport.w;

    // Calculate how “blurry” the transmission should be.
    // Blur is more or less eyeballed to look approximately “right”, since the “correct”
    // approach would involve projecting many scattered rays and figuring out their individual
    // exit positions. IRL, light rays can be scattered when entering/exiting a material (due to
    // roughness) or inside the material (due to subsurface scattering). Here, we only consider
    // the first scenario.
    //
    // Blur intensity is:
    // - proportional to the square of `perceptual_roughness`
    // - proportional to the inverse of view z
    let blur_intensity = (perceptual_roughness * perceptual_roughness) / view_z;

#ifdef SCREEN_SPACE_SPECULAR_TRANSMISSION_BLUR_TAPS
    let num_taps = #{SCREEN_SPACE_SPECULAR_TRANSMISSION_BLUR_TAPS}; // Controlled by the `Camera3d::screen_space_specular_transmission_quality` property
#else
    let num_taps = 8; // Fallback to 8 taps, if not specified
#endif
    let num_spirals = i32(ceil(f32(num_taps) / 8.0));
#ifdef TEMPORAL_JITTER
    let random_angle = interleaved_gradient_noise(frag_coord.xy, view_bindings::globals.frame_count);
#else
    let random_angle = interleaved_gradient_noise(frag_coord.xy, 0u);
#endif
    // Pixel checkerboard pattern (helps make the interleaved gradient noise pattern less visible)
    let pixel_checkboard = (
#ifdef TEMPORAL_JITTER
        // 0 or 1 on even/odd pixels, alternates every frame
        (i32(frag_coord.x) + i32(frag_coord.y) + i32(view_bindings::globals.frame_count)) % 2
#else
        // 0 or 1 on even/odd pixels
        (i32(frag_coord.x) + i32(frag_coord.y)) % 2
#endif
    );

    var result = vec4<f32>(0.0);
    for (var i: i32 = 0; i < num_taps; i = i + 1) {
        let current_spiral = (i >> 3u);
        let angle = (random_angle + f32(current_spiral) / f32(num_spirals)) * 2.0 * PI;
        let m = vec2(sin(angle), cos(angle));
        let rotation_matrix = mat2x2(
            m.y, -m.x,
            m.x, m.y
        );

        // Get spiral offset
        var spiral_offset: vec2<f32>;
        switch i & 7 {
            // https://www.iryoku.com/next-generation-post-processing-in-call-of-duty-advanced-warfare (slides 120-135)
            // TODO: Figure out a more reasonable way of doing this, as WGSL
            // seems to only allow constant indexes into constant arrays at the moment.
            // The downstream shader compiler should be able to optimize this into a single
            // constant when unrolling the for loop, but it's still not ideal.
            case 0: { spiral_offset = utils::SPIRAL_OFFSET_0_; } // Note: We go even first and then odd, so that the lowest
            case 1: { spiral_offset = utils::SPIRAL_OFFSET_2_; } // quality possible (which does 4 taps) still does a full spiral
            case 2: { spiral_offset = utils::SPIRAL_OFFSET_4_; } // instead of just the first half of it
            case 3: { spiral_offset = utils::SPIRAL_OFFSET_6_; }
            case 4: { spiral_offset = utils::SPIRAL_OFFSET_1_; }
            case 5: { spiral_offset = utils::SPIRAL_OFFSET_3_; }
            case 6: { spiral_offset = utils::SPIRAL_OFFSET_5_; }
            case 7: { spiral_offset = utils::SPIRAL_OFFSET_7_; }
            default: {}
        }

        // Make each consecutive spiral slightly smaller than the previous one
        spiral_offset *= 1.0 - (0.5 * f32(current_spiral + 1) / f32(num_spirals));

        // Rotate and correct for aspect ratio
        let rotated_spiral_offset = (rotation_matrix * spiral_offset) * vec2(1.0, aspect);

        // Calculate final offset position, with blur and spiral offset
        let modified_offset_position = offset_position + rotated_spiral_offset * blur_intensity * (1.0 - f32(pixel_checkboard) * 0.1);

        // Sample the view transmission texture at the offset position + noise offset, to get the background color
        var sample = textureSampleLevel(
            view_bindings::view_transmission_texture,
            view_bindings::view_transmission_sampler,
            modified_offset_position,
            0.0
        );

#ifdef DEPTH_PREPASS
#ifndef WEBGL2
        // Use depth prepass data to reject values that are in front of the current fragment
        if prepass_utils::prepass_depth(vec4<f32>(modified_offset_position * view_bindings::view.viewport.zw, 0.0, 0.0), 0u) > frag_coord.z {
            sample = vec4<f32>(0.0);
        }
#endif
#endif

        // As blur intensity grows higher, gradually limit *very bright* color RGB values towards a
        // maximum length of 1.0 to prevent stray “firefly” pixel artifacts. This can potentially make
        // very strong emissive meshes appear much dimmer, but the artifacts are noticeable enough to
        // warrant this treatment.
        let normalized_rgb = normalize(sample.rgb);
        result += vec4(min(sample.rgb, normalized_rgb / saturate(blur_intensity / 2.0)), sample.a);
    }

    result /= f32(num_taps);

#ifdef TONEMAP_IN_SHADER
    result = approximate_inverse_tone_mapping(result, view_bindings::view.color_grading);
#endif

    return result;
}

```

### crates/bevy_pbr/src/render/mesh_view_bindings

```rust
#define_import_path bevy_pbr::mesh_view_bindings

#import bevy_pbr::mesh_view_types as types
#import bevy_render::{
    view::View,
    globals::Globals,
}

@group(0) @binding(0) var<uniform> view: View;
@group(0) @binding(1) var<uniform> lights: types::Lights;
#ifdef NO_CUBE_ARRAY_TEXTURES_SUPPORT
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
@group(0) @binding(11) var<uniform> light_probes: types::LightProbes;

@group(0) @binding(12) var screen_space_ambient_occlusion_texture: texture_2d<f32>;

#ifdef MULTIPLE_LIGHT_PROBES_IN_ARRAY
@group(0) @binding(13) var diffuse_environment_maps: binding_array<texture_cube<f32>, 8u>;
@group(0) @binding(14) var specular_environment_maps: binding_array<texture_cube<f32>, 8u>;
#else
@group(0) @binding(13) var diffuse_environment_map: texture_cube<f32>;
@group(0) @binding(14) var specular_environment_map: texture_cube<f32>;
#endif
@group(0) @binding(15) var environment_map_sampler: sampler;

#ifdef IRRADIANCE_VOLUMES_ARE_USABLE
#ifdef MULTIPLE_LIGHT_PROBES_IN_ARRAY
@group(0) @binding(16) var irradiance_volumes: binding_array<texture_3d<f32>, 8u>;
#else
@group(0) @binding(16) var irradiance_volume: texture_3d<f32>;
#endif
@group(0) @binding(17) var irradiance_volume_sampler: sampler;
#endif

// NB: If you change these, make sure to update `tonemapping_shared.wgsl` too.
@group(0) @binding(18) var dt_lut_texture: texture_3d<f32>;
@group(0) @binding(19) var dt_lut_sampler: sampler;

#ifdef MULTISAMPLED
#ifdef DEPTH_PREPASS
@group(0) @binding(20) var depth_prepass_texture: texture_depth_multisampled_2d;
#endif // DEPTH_PREPASS
#ifdef NORMAL_PREPASS
@group(0) @binding(21) var normal_prepass_texture: texture_multisampled_2d<f32>;
#endif // NORMAL_PREPASS
#ifdef MOTION_VECTOR_PREPASS
@group(0) @binding(22) var motion_vector_prepass_texture: texture_multisampled_2d<f32>;
#endif // MOTION_VECTOR_PREPASS

#else // MULTISAMPLED

#ifdef DEPTH_PREPASS
@group(0) @binding(20) var depth_prepass_texture: texture_depth_2d;
#endif // DEPTH_PREPASS
#ifdef NORMAL_PREPASS
@group(0) @binding(21) var normal_prepass_texture: texture_2d<f32>;
#endif // NORMAL_PREPASS
#ifdef MOTION_VECTOR_PREPASS
@group(0) @binding(22) var motion_vector_prepass_texture: texture_2d<f32>;
#endif // MOTION_VECTOR_PREPASS

#endif // MULTISAMPLED

#ifdef DEFERRED_PREPASS
@group(0) @binding(23) var deferred_prepass_texture: texture_2d<u32>;
#endif // DEFERRED_PREPASS

@group(0) @binding(24) var view_transmission_texture: texture_2d<f32>;
@group(0) @binding(25) var view_transmission_sampler: sampler;

```

### crates/bevy_pbr/src/render/view_transformations

```rust
#define_import_path bevy_pbr::view_transformations

#import bevy_pbr::mesh_view_bindings as view_bindings

/// World space:
/// +y is up

/// View space:
/// -z is forward, +x is right, +y is up
/// Forward is from the camera position into the scene.
/// (0.0, 0.0, -1.0) is linear distance of 1.0 in front of the camera's view relative to the camera's rotation
/// (0.0, 1.0, 0.0) is linear distance of 1.0 above the camera's view relative to the camera's rotation

/// NDC (normalized device coordinate):
/// https://www.w3.org/TR/webgpu/#coordinate-systems
/// (-1.0, -1.0) in NDC is located at the bottom-left corner of NDC
/// (1.0, 1.0) in NDC is located at the top-right corner of NDC
/// Z is depth where: 
///    1.0 is near clipping plane
///    Perspective projection: 0.0 is inf far away
///    Orthographic projection: 0.0 is far clipping plane

/// UV space:
/// 0.0, 0.0 is the top left
/// 1.0, 1.0 is the bottom right


// -----------------
// TO WORLD --------
// -----------------

/// Convert a view space position to world space
fn position_view_to_world(view_pos: vec3<f32>) -> vec3<f32> {
    let world_pos = view_bindings::view.view * vec4(view_pos, 1.0);
    return world_pos.xyz;
}

/// Convert a clip space position to world space
fn position_clip_to_world(clip_pos: vec4<f32>) -> vec3<f32> {
    let world_pos = view_bindings::view.inverse_view_proj * clip_pos;
    return world_pos.xyz;
}

/// Convert a ndc space position to world space
fn position_ndc_to_world(ndc_pos: vec3<f32>) -> vec3<f32> {
    let world_pos = view_bindings::view.inverse_view_proj * vec4(ndc_pos, 1.0);
    return world_pos.xyz / world_pos.w;
}

/// Convert a view space direction to world space
fn direction_view_to_world(view_dir: vec3<f32>) -> vec3<f32> {
    let world_dir = view_bindings::view.view * vec4(view_dir, 0.0);
    return world_dir.xyz;
}

/// Convert a clip space direction to world space
fn direction_clip_to_world(clip_dir: vec4<f32>) -> vec3<f32> {
    let world_dir = view_bindings::view.inverse_view_proj * clip_dir;
    return world_dir.xyz;
}

// -----------------
// TO VIEW ---------
// -----------------

/// Convert a world space position to view space
fn position_world_to_view(world_pos: vec3<f32>) -> vec3<f32> {
    let view_pos = view_bindings::view.inverse_view * vec4(world_pos, 1.0);
    return view_pos.xyz;
}

/// Convert a clip space position to view space
fn position_clip_to_view(clip_pos: vec4<f32>) -> vec3<f32> {
    let view_pos = view_bindings::view.inverse_projection * clip_pos;
    return view_pos.xyz;
}

/// Convert a ndc space position to view space
fn position_ndc_to_view(ndc_pos: vec3<f32>) -> vec3<f32> {
    let view_pos = view_bindings::view.inverse_projection * vec4(ndc_pos, 1.0);
    return view_pos.xyz / view_pos.w;
}

/// Convert a world space direction to view space
fn direction_world_to_view(world_dir: vec3<f32>) -> vec3<f32> {
    let view_dir = view_bindings::view.inverse_view * vec4(world_dir, 0.0);
    return view_dir.xyz;
}

/// Convert a clip space direction to view space
fn direction_clip_to_view(clip_dir: vec4<f32>) -> vec3<f32> {
    let view_dir = view_bindings::view.inverse_projection * clip_dir;
    return view_dir.xyz;
}

// -----------------
// TO CLIP ---------
// -----------------

/// Convert a world space position to clip space
fn position_world_to_clip(world_pos: vec3<f32>) -> vec4<f32> {
    let clip_pos = view_bindings::view.view_proj * vec4(world_pos, 1.0);
    return clip_pos;
}

/// Convert a view space position to clip space
fn position_view_to_clip(view_pos: vec3<f32>) -> vec4<f32> {
    let clip_pos = view_bindings::view.projection * vec4(view_pos, 1.0);
    return clip_pos;
}

/// Convert a world space direction to clip space
fn direction_world_to_clip(world_dir: vec3<f32>) -> vec4<f32> {
    let clip_dir = view_bindings::view.view_proj * vec4(world_dir, 0.0);
    return clip_dir;
}

/// Convert a view space direction to clip space
fn direction_view_to_clip(view_dir: vec3<f32>) -> vec4<f32> {
    let clip_dir = view_bindings::view.projection * vec4(view_dir, 0.0);
    return clip_dir;
}

// -----------------
// TO NDC ----------
// -----------------

/// Convert a world space position to ndc space
fn position_world_to_ndc(world_pos: vec3<f32>) -> vec3<f32> {
    let ndc_pos = view_bindings::view.view_proj * vec4(world_pos, 1.0);
    return ndc_pos.xyz / ndc_pos.w;
}

/// Convert a view space position to ndc space
fn position_view_to_ndc(view_pos: vec3<f32>) -> vec3<f32> {
    let ndc_pos = view_bindings::view.projection * vec4(view_pos, 1.0);
    return ndc_pos.xyz / ndc_pos.w;
}

// -----------------
// DEPTH -----------
// -----------------

/// Retrieve the perspective camera near clipping plane
fn perspective_camera_near() -> f32 {
    return view_bindings::view.projection[3][2];
}

/// Convert ndc depth to linear view z. 
/// Note: Depth values in front of the camera will be negative as -z is forward
fn depth_ndc_to_view_z(ndc_depth: f32) -> f32 {
#ifdef VIEW_PROJECTION_PERSPECTIVE
    return -perspective_camera_near() / ndc_depth;
#else ifdef VIEW_PROJECTION_ORTHOGRAPHIC
    return -(view_bindings::view.projection[3][2] - ndc_depth) / view_bindings::view.projection[2][2];
#else
    let view_pos = view_bindings::view.inverse_projection * vec4(0.0, 0.0, ndc_depth, 1.0);
    return view_pos.z / view_pos.w;
#endif
}

/// Convert linear view z to ndc depth. 
/// Note: View z input should be negative for values in front of the camera as -z is forward
fn view_z_to_depth_ndc(view_z: f32) -> f32 {
#ifdef VIEW_PROJECTION_PERSPECTIVE
    return -perspective_camera_near() / view_z;
#else ifdef VIEW_PROJECTION_ORTHOGRAPHIC
    return view_bindings::view.projection[3][2] + view_z * view_bindings::view.projection[2][2];
#else
    let ndc_pos = view_bindings::view.projection * vec4(0.0, 0.0, view_z, 1.0);
    return ndc_pos.z / ndc_pos.w;
#endif
}

// -----------------
// UV --------------
// -----------------

/// Convert ndc space xy coordinate [-1.0 .. 1.0] to uv [0.0 .. 1.0]
fn ndc_to_uv(ndc: vec2<f32>) -> vec2<f32> {
    return ndc * vec2(0.5, -0.5) + vec2(0.5);
}

/// Convert uv [0.0 .. 1.0] coordinate to ndc space xy [-1.0 .. 1.0]
fn uv_to_ndc(uv: vec2<f32>) -> vec2<f32> {
    return uv * vec2(2.0, -2.0) + vec2(-1.0, 1.0);
}

/// returns the (0.0, 0.0) .. (1.0, 1.0) position within the viewport for the current render target
/// [0 .. render target viewport size] eg. [(0.0, 0.0) .. (1280.0, 720.0)] to [(0.0, 0.0) .. (1.0, 1.0)]
fn frag_coord_to_uv(frag_coord: vec2<f32>) -> vec2<f32> {
    return (frag_coord - view_bindings::view.viewport.xy) / view_bindings::view.viewport.zw;
}

/// Convert frag coord to ndc
fn frag_coord_to_ndc(frag_coord: vec4<f32>) -> vec3<f32> {
    return vec3(uv_to_ndc(frag_coord_to_uv(frag_coord.xy)), frag_coord.z);
}

```

### crates/bevy_pbr/src/render/skinning

```rust
#define_import_path bevy_pbr::skinning

#import bevy_pbr::mesh_types::SkinnedMesh

#ifdef SKINNED

@group(1) @binding(1) var<uniform> joint_matrices: SkinnedMesh;

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

```

### crates/bevy_pbr/src/prepass/prepass_utils

```rust
#define_import_path bevy_pbr::prepass_utils

#import bevy_pbr::mesh_view_bindings as view_bindings

#ifdef DEPTH_PREPASS
fn prepass_depth(frag_coord: vec4<f32>, sample_index: u32) -> f32 {
#ifdef MULTISAMPLED
    return textureLoad(view_bindings::depth_prepass_texture, vec2<i32>(frag_coord.xy), i32(sample_index));
#else // MULTISAMPLED
    return textureLoad(view_bindings::depth_prepass_texture, vec2<i32>(frag_coord.xy), 0);
#endif // MULTISAMPLED
}
#endif // DEPTH_PREPASS

#ifdef NORMAL_PREPASS
fn prepass_normal(frag_coord: vec4<f32>, sample_index: u32) -> vec3<f32> {
#ifdef MULTISAMPLED
    let normal_sample = textureLoad(view_bindings::normal_prepass_texture, vec2<i32>(frag_coord.xy), i32(sample_index));
#else
    let normal_sample = textureLoad(view_bindings::normal_prepass_texture, vec2<i32>(frag_coord.xy), 0);
#endif // MULTISAMPLED
    return normalize(normal_sample.xyz * 2.0 - vec3(1.0));
}
#endif // NORMAL_PREPASS

#ifdef MOTION_VECTOR_PREPASS
fn prepass_motion_vector(frag_coord: vec4<f32>, sample_index: u32) -> vec2<f32> {
#ifdef MULTISAMPLED
    let motion_vector_sample = textureLoad(view_bindings::motion_vector_prepass_texture, vec2<i32>(frag_coord.xy), i32(sample_index));
#else
    let motion_vector_sample = textureLoad(view_bindings::motion_vector_prepass_texture, vec2<i32>(frag_coord.xy), 0);
#endif
    return motion_vector_sample.rg;
}
#endif // MOTION_VECTOR_PREPASS

```

### crates/bevy_pbr/src/prepass/prepass_bindings

```rust
#define_import_path bevy_pbr::prepass_bindings

struct PreviousViewUniforms {
    inverse_view: mat4x4<f32>,
    view_proj: mat4x4<f32>,
}

#ifdef MOTION_VECTOR_PREPASS
@group(0) @binding(2) var<uniform> previous_view_uniforms: PreviousViewUniforms;
#endif // MOTION_VECTOR_PREPASS

// Material bindings will be in @group(2)

```

### crates/bevy_pbr/src/prepass/prepass

```rust
#import bevy_pbr::{
    prepass_bindings,
    mesh_functions,
    prepass_io::{Vertex, VertexOutput, FragmentOutput},
    skinning,
    morph,
    mesh_view_bindings::view,
}

#ifdef DEFERRED_PREPASS
#import bevy_pbr::rgb9e5
#endif

#ifdef MORPH_TARGETS
fn morph_vertex(vertex_in: Vertex) -> Vertex {
    var vertex = vertex_in;
    let weight_count = morph::layer_count();
    for (var i: u32 = 0u; i < weight_count; i ++) {
        let weight = morph::weight_at(i);
        if weight == 0.0 {
            continue;
        }
        vertex.position += weight * morph::morph(vertex.index, morph::position_offset, i);
#ifdef VERTEX_NORMALS
        vertex.normal += weight * morph::morph(vertex.index, morph::normal_offset, i);
#endif
#ifdef VERTEX_TANGENTS
        vertex.tangent += vec4(weight * morph::morph(vertex.index, morph::tangent_offset, i), 0.0);
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
    var model = skinning::skin_model(vertex.joint_indices, vertex.joint_weights);
#else // SKINNED
    // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
    // See https://github.com/gfx-rs/naga/issues/2416
    var model = mesh_functions::get_model_matrix(vertex_no_morph.instance_index);
#endif // SKINNED

    out.position = mesh_functions::mesh_position_local_to_clip(model, vec4(vertex.position, 1.0));
#ifdef DEPTH_CLAMP_ORTHO
    out.clip_position_unclamped = out.position;
    out.position.z = min(out.position.z, 1.0);
#endif // DEPTH_CLAMP_ORTHO

#ifdef VERTEX_UVS
    out.uv = vertex.uv;
#endif // VERTEX_UVS

#ifdef VERTEX_UVS_B
    out.uv_b = vertex.uv_b;
#endif // VERTEX_UVS_B

#ifdef NORMAL_PREPASS_OR_DEFERRED_PREPASS
#ifdef SKINNED
    out.world_normal = skinning::skin_normals(model, vertex.normal);
#else // SKINNED
    out.world_normal = mesh_functions::mesh_normal_local_to_world(
        vertex.normal,
        // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
        // See https://github.com/gfx-rs/naga/issues/2416
        vertex_no_morph.instance_index
    );
#endif // SKINNED

#ifdef VERTEX_TANGENTS
    out.world_tangent = mesh_functions::mesh_tangent_local_to_world(
        model,
        vertex.tangent,
        // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
        // See https://github.com/gfx-rs/naga/issues/2416
        vertex_no_morph.instance_index
    );
#endif // VERTEX_TANGENTS
#endif // NORMAL_PREPASS_OR_DEFERRED_PREPASS

#ifdef VERTEX_COLORS
    out.color = vertex.color;
#endif

    out.world_position = mesh_functions::mesh_position_local_to_world(model, vec4<f32>(vertex.position, 1.0));

#ifdef MOTION_VECTOR_PREPASS
    // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
    // See https://github.com/gfx-rs/naga/issues/2416
    out.previous_world_position = mesh_functions::mesh_position_local_to_world(
        mesh_functions::get_previous_model_matrix(vertex_no_morph.instance_index),
        vec4<f32>(vertex.position, 1.0)
    );
#endif // MOTION_VECTOR_PREPASS

#ifdef VERTEX_OUTPUT_INSTANCE_INDEX
    // Use vertex_no_morph.instance_index instead of vertex.instance_index to work around a wgpu dx12 bug.
    // See https://github.com/gfx-rs/naga/issues/2416
    out.instance_index = vertex_no_morph.instance_index;
#endif

    return out;
}

#ifdef PREPASS_FRAGMENT
@fragment
fn fragment(in: VertexOutput) -> FragmentOutput {
    var out: FragmentOutput;

#ifdef NORMAL_PREPASS
    out.normal = vec4(in.world_normal * 0.5 + vec3(0.5), 1.0);
#endif

#ifdef DEPTH_CLAMP_ORTHO
    out.frag_depth = in.clip_position_unclamped.z;
#endif // DEPTH_CLAMP_ORTHO

#ifdef MOTION_VECTOR_PREPASS
    let clip_position_t = view.unjittered_view_proj * in.world_position;
    let clip_position = clip_position_t.xy / clip_position_t.w;
    let previous_clip_position_t = prepass_bindings::previous_view_uniforms.view_proj * in.previous_world_position;
    let previous_clip_position = previous_clip_position_t.xy / previous_clip_position_t.w;
    // These motion vectors are used as offsets to UV positions and are stored
    // in the range -1,1 to allow offsetting from the one corner to the
    // diagonally-opposite corner in UV coordinates, in either direction.
    // A difference between diagonally-opposite corners of clip space is in the
    // range -2,2, so this needs to be scaled by 0.5. And the V direction goes
    // down where clip space y goes up, so y needs to be flipped.
    out.motion_vector = (clip_position - previous_clip_position) * vec2(0.5, -0.5);
#endif // MOTION_VECTOR_PREPASS

#ifdef DEFERRED_PREPASS
    // There isn't any material info available for this default prepass shader so we are just writing 
    // emissive magenta out to the deferred gbuffer to be rendered by the first deferred lighting pass layer.
    // This is here so if the default prepass fragment is used for deferred magenta will be rendered, and also
    // as an example to show that a user could write to the deferred gbuffer if they were to start from this shader.
    out.deferred = vec4(0u, bevy_pbr::rgb9e5::vec3_to_rgb9e5_(vec3(1.0, 0.0, 1.0)), 0u, 0u);
    out.deferred_lighting_pass_id = 1u;
#endif

    return out;
}
#endif // PREPASS_FRAGMENT

```

### crates/bevy_pbr/src/prepass/prepass_io

```rust
#define_import_path bevy_pbr::prepass_io

// Most of these attributes are not used in the default prepass fragment shader, but they are still needed so we can
// pass them to custom prepass shaders like pbr_prepass.wgsl.
struct Vertex {
    @builtin(instance_index) instance_index: u32,
    @location(0) position: vec3<f32>,

#ifdef VERTEX_UVS
    @location(1) uv: vec2<f32>,
#endif

#ifdef VERTEX_UVS_B
    @location(2) uv_b: vec2<f32>,
#endif

#ifdef NORMAL_PREPASS_OR_DEFERRED_PREPASS
    @location(3) normal: vec3<f32>,
#ifdef VERTEX_TANGENTS
    @location(4) tangent: vec4<f32>,
#endif
#endif // NORMAL_PREPASS_OR_DEFERRED_PREPASS

#ifdef SKINNED
    @location(5) joint_indices: vec4<u32>,
    @location(6) joint_weights: vec4<f32>,
#endif

#ifdef VERTEX_COLORS
    @location(7) color: vec4<f32>,
#endif

#ifdef MORPH_TARGETS
    @builtin(vertex_index) index: u32,
#endif // MORPH_TARGETS
}

struct VertexOutput {
    // This is `clip position` when the struct is used as a vertex stage output
    // and `frag coord` when used as a fragment stage input
    @builtin(position) position: vec4<f32>,

#ifdef VERTEX_UVS
    @location(0) uv: vec2<f32>,
#endif

#ifdef VERTEX_UVS_B
    @location(1) uv_b: vec2<f32>,
#endif

#ifdef NORMAL_PREPASS_OR_DEFERRED_PREPASS
    @location(2) world_normal: vec3<f32>,
#ifdef VERTEX_TANGENTS
    @location(3) world_tangent: vec4<f32>,
#endif
#endif // NORMAL_PREPASS_OR_DEFERRED_PREPASS

    @location(4) world_position: vec4<f32>,
#ifdef MOTION_VECTOR_PREPASS
    @location(5) previous_world_position: vec4<f32>,
#endif

#ifdef DEPTH_CLAMP_ORTHO
    @location(6) clip_position_unclamped: vec4<f32>,
#endif // DEPTH_CLAMP_ORTHO
#ifdef VERTEX_OUTPUT_INSTANCE_INDEX
    @location(7) instance_index: u32,
#endif

#ifdef VERTEX_COLORS
    @location(8) color: vec4<f32>,
#endif
}

#ifdef PREPASS_FRAGMENT
struct FragmentOutput {
#ifdef NORMAL_PREPASS
    @location(0) normal: vec4<f32>,
#endif

#ifdef MOTION_VECTOR_PREPASS
    @location(1) motion_vector: vec2<f32>,
#endif

#ifdef DEFERRED_PREPASS
    @location(2) deferred: vec4<u32>,
    @location(3) deferred_lighting_pass_id: u32,
#endif

#ifdef DEPTH_CLAMP_ORTHO
    @builtin(frag_depth) frag_depth: f32,
#endif // DEPTH_CLAMP_ORTHO
}
#endif //PREPASS_FRAGMENT

```

### crates/bevy_pbr/src/meshlet/copy_material_depth

```rust
#import bevy_core_pipeline::fullscreen_vertex_shader::FullscreenVertexOutput

@group(0) @binding(0) var material_depth: texture_2d<u32>;

/// This pass copies the R16Uint material depth texture to an actual Depth16Unorm depth texture.

@fragment
fn copy_material_depth(in: FullscreenVertexOutput) -> @builtin(frag_depth) f32 {
    return f32(textureLoad(material_depth, vec2<i32>(in.position.xy), 0).r) / 65535.0;
}

```

### crates/bevy_pbr/src/meshlet/write_index_buffer

```rust
#import bevy_pbr::meshlet_bindings::{
    meshlet_thread_meshlet_ids,
    meshlets,
    draw_indirect_args,
    draw_index_buffer,
    get_meshlet_occlusion,
    get_meshlet_previous_occlusion,
}

var<workgroup> draw_index_buffer_start_workgroup: u32;

/// This pass writes out a buffer of cluster + triangle IDs for the draw_indirect() call to rasterize each visible meshlet.

@compute
@workgroup_size(64, 1, 1) // 64 threads per workgroup, 1 workgroup per cluster, 1 thread per triangle
fn write_index_buffer(@builtin(workgroup_id) workgroup_id: vec3<u32>, @builtin(num_workgroups) num_workgroups: vec3<u32>, @builtin(local_invocation_index) triangle_id: u32) {
    // Calculate the cluster ID for this workgroup
    let cluster_id = dot(workgroup_id, vec3(num_workgroups.x * num_workgroups.x, num_workgroups.x, 1u));
    if cluster_id >= arrayLength(&meshlet_thread_meshlet_ids) { return; }

    // If the meshlet was culled, then we don't need to draw it
    if !get_meshlet_occlusion(cluster_id) { return; }

    // If the meshlet was drawn in the first pass, and this is the second pass, then we don't need to draw it
#ifdef MESHLET_SECOND_WRITE_INDEX_BUFFER_PASS
    if get_meshlet_previous_occlusion(cluster_id) { return; }
#endif

    let meshlet_id = meshlet_thread_meshlet_ids[cluster_id];
    let meshlet = meshlets[meshlet_id];

    // Reserve space in the buffer for this meshlet's triangles, and broadcast the start of that slice to all threads
    if triangle_id == 0u {
        draw_index_buffer_start_workgroup = atomicAdd(&draw_indirect_args.vertex_count, meshlet.triangle_count * 3u);
        draw_index_buffer_start_workgroup /= 3u;
    }
    workgroupBarrier();

    // Each thread writes one triangle of the meshlet to the buffer slice reserved for the meshlet
    if triangle_id < meshlet.triangle_count {
        draw_index_buffer[draw_index_buffer_start_workgroup + triangle_id] = (cluster_id << 8u) | triangle_id;
    }
}

```

### crates/bevy_pbr/src/meshlet/meshlet_bindings

```rust
#define_import_path bevy_pbr::meshlet_bindings

#import bevy_pbr::mesh_types::Mesh
#import bevy_render::view::View

struct PackedMeshletVertex {
    a: vec4<f32>,
    b: vec4<f32>,
    tangent: vec4<f32>,
}

// TODO: Octahedral encode normal, remove tangent and derive from UV derivatives
struct MeshletVertex {
    position: vec3<f32>,
    normal: vec3<f32>,
    uv: vec2<f32>,
    tangent: vec4<f32>,
}

fn unpack_meshlet_vertex(packed: PackedMeshletVertex) -> MeshletVertex {
    var vertex: MeshletVertex;
    vertex.position = packed.a.xyz;
    vertex.normal = vec3(packed.a.w, packed.b.xy);
    vertex.uv = packed.b.zw;
    vertex.tangent = packed.tangent;
    return vertex;
}

struct Meshlet {
    start_vertex_id: u32,
    start_index_id: u32,
    triangle_count: u32,
}

struct MeshletBoundingSphere {
    center: vec3<f32>,
    radius: f32,
}

struct DrawIndirectArgs {
    vertex_count: atomic<u32>,
    instance_count: u32,
    first_vertex: u32,
    first_instance: u32,
}

#ifdef MESHLET_CULLING_PASS
@group(0) @binding(0) var<storage, read> meshlet_thread_meshlet_ids: array<u32>; // Per cluster (instance of a meshlet)
@group(0) @binding(1) var<storage, read> meshlet_bounding_spheres: array<MeshletBoundingSphere>; // Per asset meshlet
@group(0) @binding(2) var<storage, read> meshlet_thread_instance_ids: array<u32>; // Per cluster (instance of a meshlet)
@group(0) @binding(3) var<storage, read> meshlet_instance_uniforms: array<Mesh>; // Per entity instance
@group(0) @binding(4) var<storage, read> meshlet_view_instance_visibility: array<u32>; // 1 bit per entity instance, packed as a bitmask
@group(0) @binding(5) var<storage, read_write> meshlet_occlusion: array<atomic<u32>>; // 1 bit per cluster (instance of a meshlet), packed as a bitmask
@group(0) @binding(6) var<storage, read> meshlet_previous_cluster_ids: array<u32>; // Per cluster (instance of a meshlet)
@group(0) @binding(7) var<storage, read> meshlet_previous_occlusion: array<u32>; // 1 bit per cluster (instance of a meshlet), packed as a bitmask
@group(0) @binding(8) var<uniform> view: View;
@group(0) @binding(9) var depth_pyramid: texture_2d<f32>; // Generated from the first raster pass (unused in the first pass but still bound)

fn should_cull_instance(instance_id: u32) -> bool {
    let bit_offset = instance_id % 32u;
    let packed_visibility = meshlet_view_instance_visibility[instance_id / 32u];
    return bool(extractBits(packed_visibility, bit_offset, 1u));
}

fn get_meshlet_previous_occlusion(cluster_id: u32) -> bool {
    let previous_cluster_id = meshlet_previous_cluster_ids[cluster_id];
    let packed_occlusion = meshlet_previous_occlusion[previous_cluster_id / 32u];
    let bit_offset = previous_cluster_id % 32u;
    return bool(extractBits(packed_occlusion, bit_offset, 1u));
}
#endif

#ifdef MESHLET_WRITE_INDEX_BUFFER_PASS
@group(0) @binding(0) var<storage, read> meshlet_occlusion: array<u32>; // 1 bit per cluster (instance of a meshlet), packed as a bitmask
@group(0) @binding(1) var<storage, read> meshlet_thread_meshlet_ids: array<u32>; // Per cluster (instance of a meshlet)
@group(0) @binding(2) var<storage, read> meshlet_previous_cluster_ids: array<u32>; // Per cluster (instance of a meshlet)
@group(0) @binding(3) var<storage, read> meshlet_previous_occlusion: array<u32>; // 1 bit per cluster (instance of a meshlet), packed as a bitmask
@group(0) @binding(4) var<storage, read> meshlets: array<Meshlet>; // Per asset meshlet
@group(0) @binding(5) var<storage, read_write> draw_indirect_args: DrawIndirectArgs; // Single object shared between all workgroups/meshlets/triangles
@group(0) @binding(6) var<storage, read_write> draw_index_buffer: array<u32>; // Single object shared between all workgroups/meshlets/triangles

fn get_meshlet_occlusion(cluster_id: u32) -> bool {
    let packed_occlusion = meshlet_occlusion[cluster_id / 32u];
    let bit_offset = cluster_id % 32u;
    return bool(extractBits(packed_occlusion, bit_offset, 1u));
}

fn get_meshlet_previous_occlusion(cluster_id: u32) -> bool {
    let previous_cluster_id = meshlet_previous_cluster_ids[cluster_id];
    let packed_occlusion = meshlet_previous_occlusion[previous_cluster_id / 32u];
    let bit_offset = previous_cluster_id % 32u;
    return bool(extractBits(packed_occlusion, bit_offset, 1u));
}
#endif

#ifdef MESHLET_VISIBILITY_BUFFER_RASTER_PASS
@group(0) @binding(0) var<storage, read> meshlet_thread_meshlet_ids: array<u32>; // Per cluster (instance of a meshlet)
@group(0) @binding(1) var<storage, read> meshlets: array<Meshlet>; // Per asset meshlet
@group(0) @binding(2) var<storage, read> meshlet_indices: array<u32>; // Many per asset meshlet
@group(0) @binding(3) var<storage, read> meshlet_vertex_ids: array<u32>; // Many per asset meshlet
@group(0) @binding(4) var<storage, read> meshlet_vertex_data: array<PackedMeshletVertex>; // Many per asset meshlet
@group(0) @binding(5) var<storage, read> meshlet_thread_instance_ids: array<u32>; // Per cluster (instance of a meshlet)
@group(0) @binding(6) var<storage, read> meshlet_instance_uniforms: array<Mesh>; // Per entity instance
@group(0) @binding(7) var<storage, read> meshlet_instance_material_ids: array<u32>; // Per entity instance
@group(0) @binding(8) var<storage, read> draw_index_buffer: array<u32>; // Single object shared between all workgroups/meshlets/triangles
@group(0) @binding(9) var<uniform> view: View;

fn get_meshlet_index(index_id: u32) -> u32 {
    let packed_index = meshlet_indices[index_id / 4u];
    let bit_offset = (index_id % 4u) * 8u;
    return extractBits(packed_index, bit_offset, 8u);
}
#endif

#ifdef MESHLET_MESH_MATERIAL_PASS
@group(1) @binding(0) var meshlet_visibility_buffer: texture_2d<u32>; // Generated from the meshlet raster passes
@group(1) @binding(1) var<storage, read> meshlet_thread_meshlet_ids: array<u32>; // Per cluster (instance of a meshlet)
@group(1) @binding(2) var<storage, read> meshlets: array<Meshlet>; // Per asset meshlet
@group(1) @binding(3) var<storage, read> meshlet_indices: array<u32>; // Many per asset meshlet
@group(1) @binding(4) var<storage, read> meshlet_vertex_ids: array<u32>; // Many per asset meshlet
@group(1) @binding(5) var<storage, read> meshlet_vertex_data: array<PackedMeshletVertex>; // Many per asset meshlet
@group(1) @binding(6) var<storage, read> meshlet_thread_instance_ids: array<u32>; // Per cluster (instance of a meshlet)
@group(1) @binding(7) var<storage, read> meshlet_instance_uniforms: array<Mesh>; // Per entity instance

fn get_meshlet_index(index_id: u32) -> u32 {
    let packed_index = meshlet_indices[index_id / 4u];
    let bit_offset = (index_id % 4u) * 8u;
    return extractBits(packed_index, bit_offset, 8u);
}
#endif

```

### crates/bevy_pbr/src/meshlet/downsample_depth

```rust
#import bevy_core_pipeline::fullscreen_vertex_shader::FullscreenVertexOutput

@group(0) @binding(0) var input_depth: texture_2d<f32>;
@group(0) @binding(1) var samplr: sampler;

/// Performs a 2x2 downsample on a depth texture to generate the next mip level of a hierarchical depth buffer.

@fragment
fn downsample_depth(in: FullscreenVertexOutput) -> @location(0) vec4<f32> {
    let depth_quad = textureGather(0, input_depth, samplr, in.uv);
    let downsampled_depth = min(
        min(depth_quad.x, depth_quad.y),
        min(depth_quad.z, depth_quad.w),
    );
    return vec4(downsampled_depth, 0.0, 0.0, 0.0);
}

```

### crates/bevy_pbr/src/meshlet/cull_meshlets

```rust
#import bevy_pbr::meshlet_bindings::{
    meshlet_thread_meshlet_ids,
    meshlet_bounding_spheres,
    meshlet_thread_instance_ids,
    meshlet_instance_uniforms,
    meshlet_occlusion,
    view,
    should_cull_instance,
    get_meshlet_previous_occlusion,
}
#ifdef MESHLET_SECOND_CULLING_PASS
#import bevy_pbr::meshlet_bindings::depth_pyramid
#endif
#import bevy_render::maths::affine3_to_square

/// Culls individual clusters (1 per thread) in two passes (two pass occlusion culling), and outputs a bitmask of which clusters survived.
/// 1. The first pass is only frustum culling, on only the clusters that were visible last frame.
/// 2. The second pass performs both frustum and occlusion culling (using the depth buffer generated from the first pass), on all clusters.

@compute
@workgroup_size(128, 1, 1) // 128 threads per workgroup, 1 instanced meshlet per thread
fn cull_meshlets(@builtin(global_invocation_id) cluster_id: vec3<u32>) {
    // Fetch the instanced meshlet data
    if cluster_id.x >= arrayLength(&meshlet_thread_meshlet_ids) { return; }
    let instance_id = meshlet_thread_instance_ids[cluster_id.x];
    if should_cull_instance(instance_id) {
        return;
    }
    let meshlet_id = meshlet_thread_meshlet_ids[cluster_id.x];
    let bounding_sphere = meshlet_bounding_spheres[meshlet_id];
    let instance_uniform = meshlet_instance_uniforms[instance_id];
    let model = affine3_to_square(instance_uniform.model);
    let model_scale = max(length(model[0]), max(length(model[1]), length(model[2])));
    let bounding_sphere_center = model * vec4(bounding_sphere.center, 1.0);
    let bounding_sphere_radius = model_scale * bounding_sphere.radius;

    // In the first pass, operate only on the clusters visible last frame. In the second pass, operate on all clusters.
#ifdef MESHLET_SECOND_CULLING_PASS
    var meshlet_visible = true;
#else
    var meshlet_visible = get_meshlet_previous_occlusion(cluster_id.x);
    if !meshlet_visible { return; }
#endif

    // Frustum culling
    // TODO: Faster method from https://vkguide.dev/docs/gpudriven/compute_culling/#frustum-culling-function
    for (var i = 0u; i < 6u; i++) {
        if !meshlet_visible { break; }
        meshlet_visible &= dot(view.frustum[i], bounding_sphere_center) > -bounding_sphere_radius;
    }

#ifdef MESHLET_SECOND_CULLING_PASS
    // In the second culling pass, cull against the depth pyramid generated from the first pass
    if meshlet_visible {
        let bounding_sphere_center_view_space = (view.inverse_view * vec4(bounding_sphere_center.xyz, 1.0)).xyz;
        let aabb = project_view_space_sphere_to_screen_space_aabb(bounding_sphere_center_view_space, bounding_sphere_radius);

        // Halve the AABB size because the first depth mip resampling pass cut the full screen resolution into a power of two conservatively
        let depth_pyramid_size_mip_0 = vec2<f32>(textureDimensions(depth_pyramid, 0)) * 0.5;
        let width = (aabb.z - aabb.x) * depth_pyramid_size_mip_0.x;
        let height = (aabb.w - aabb.y) * depth_pyramid_size_mip_0.y;
        let depth_level = max(0, i32(ceil(log2(max(width, height))))); // TODO: Naga doesn't like this being a u32
        let depth_pyramid_size = vec2<f32>(textureDimensions(depth_pyramid, depth_level));
        let aabb_top_left = vec2<u32>(aabb.xy * depth_pyramid_size);

        let depth_quad_a = textureLoad(depth_pyramid, aabb_top_left, depth_level).x;
        let depth_quad_b = textureLoad(depth_pyramid, aabb_top_left + vec2(1u, 0u), depth_level).x;
        let depth_quad_c = textureLoad(depth_pyramid, aabb_top_left + vec2(0u, 1u), depth_level).x;
        let depth_quad_d = textureLoad(depth_pyramid, aabb_top_left + vec2(1u, 1u), depth_level).x;

        let occluder_depth = min(min(depth_quad_a, depth_quad_b), min(depth_quad_c, depth_quad_d));
        if view.projection[3][3] == 1.0 {
            // Orthographic
            let sphere_depth = view.projection[3][2] + (bounding_sphere_center_view_space.z + bounding_sphere_radius) * view.projection[2][2];
            meshlet_visible &= sphere_depth >= occluder_depth;
        } else {
            // Perspective
            let sphere_depth = -view.projection[3][2] / (bounding_sphere_center_view_space.z + bounding_sphere_radius);
            meshlet_visible &= sphere_depth >= occluder_depth;
        }
    }
#endif

    // Write the bitmask of whether or not the cluster was culled
    let occlusion_bit = u32(meshlet_visible) << (cluster_id.x % 32u);
    atomicOr(&meshlet_occlusion[cluster_id.x / 32u], occlusion_bit);
}

// https://zeux.io/2023/01/12/approximate-projected-bounds
fn project_view_space_sphere_to_screen_space_aabb(cp: vec3<f32>, r: f32) -> vec4<f32> {
    let inv_width = view.projection[0][0] * 0.5;
    let inv_height = view.projection[1][1] * 0.5;
    if view.projection[3][3] == 1.0 {
        // Orthographic
        let min_x = cp.x - r;
        let max_x = cp.x + r;

        let min_y = cp.y - r;
        let max_y = cp.y + r;

        return vec4(min_x * inv_width, 1.0 - max_y * inv_height, max_x * inv_width, 1.0 - min_y * inv_height);
    } else {
        // Perspective
        let c = vec3(cp.xy, -cp.z);
        let cr = c * r;
        let czr2 = c.z * c.z - r * r;

        let vx = sqrt(c.x * c.x + czr2);
        let min_x = (vx * c.x - cr.z) / (vx * c.z + cr.x);
        let max_x = (vx * c.x + cr.z) / (vx * c.z - cr.x);

        let vy = sqrt(c.y * c.y + czr2);
        let min_y = (vy * c.y - cr.z) / (vy * c.z + cr.y);
        let max_y = (vy * c.y + cr.z) / (vy * c.z - cr.y);

        return vec4(min_x * inv_width, -max_y * inv_height, max_x * inv_width, -min_y * inv_height) + vec4(0.5);
    }
}

```

### crates/bevy_pbr/src/meshlet/meshlet_mesh_material

```rust
#import bevy_pbr::{
    meshlet_visibility_buffer_resolve::resolve_vertex_output,
    view_transformations::uv_to_ndc,
    prepass_io,
    pbr_prepass_functions,
    utils::rand_f,
}

@vertex
fn vertex(@builtin(vertex_index) vertex_input: u32) -> @builtin(position) vec4<f32> {
    let vertex_index = vertex_input % 3u;
    let material_id = vertex_input / 3u;
    let material_depth = f32(material_id) / 65535.0;
    let uv = vec2<f32>(vec2(vertex_index >> 1u, vertex_index & 1u)) * 2.0;
    return vec4(uv_to_ndc(uv), material_depth, 1.0);
}

@fragment
fn fragment(@builtin(position) frag_coord: vec4<f32>) -> @location(0) vec4<f32> {
    let vertex_output = resolve_vertex_output(frag_coord);
    var rng = vertex_output.meshlet_id;
    let color = vec3(rand_f(&rng), rand_f(&rng), rand_f(&rng));
    return vec4(color, 1.0);
}

#ifdef PREPASS_FRAGMENT
@fragment
fn prepass_fragment(@builtin(position) frag_coord: vec4<f32>) -> prepass_io::FragmentOutput {
    let vertex_output = resolve_vertex_output(frag_coord);

    var out: prepass_io::FragmentOutput;

#ifdef NORMAL_PREPASS
    out.normal = vec4(vertex_output.world_normal * 0.5 + vec3(0.5), 1.0);
#endif

#ifdef MOTION_VECTOR_PREPASS
    out.motion_vector = vertex_output.motion_vector;
#endif

#ifdef DEFERRED_PREPASS
    // There isn't any material info available for this default prepass shader so we are just writing 
    // emissive magenta out to the deferred gbuffer to be rendered by the first deferred lighting pass layer.
    // This is here so if the default prepass fragment is used for deferred magenta will be rendered, and also
    // as an example to show that a user could write to the deferred gbuffer if they were to start from this shader.
    out.deferred = vec4(0u, bevy_pbr::rgb9e5::vec3_to_rgb9e5_(vec3(1.0, 0.0, 1.0)), 0u, 0u);
    out.deferred_lighting_pass_id = 1u;
#endif

    return out;
}
#endif

```

### crates/bevy_pbr/src/meshlet/visibility_buffer_resolve

```rust
#define_import_path bevy_pbr::meshlet_visibility_buffer_resolve

#import bevy_pbr::{
    meshlet_bindings::{
        meshlet_visibility_buffer,
        meshlet_thread_meshlet_ids,
        meshlets,
        meshlet_vertex_ids,
        meshlet_vertex_data,
        meshlet_thread_instance_ids,
        meshlet_instance_uniforms,
        get_meshlet_index,
        unpack_meshlet_vertex,
    },
    mesh_view_bindings::view,
    mesh_functions::mesh_position_local_to_world,
    mesh_types::MESH_FLAGS_SIGN_DETERMINANT_MODEL_3X3_BIT,
    view_transformations::{position_world_to_clip, frag_coord_to_ndc},
}
#import bevy_render::maths::{affine3_to_square, mat2x4_f32_to_mat3x3_unpack}

#ifdef PREPASS_FRAGMENT
#ifdef MOTION_VECTOR_PREPASS
#import bevy_pbr::{
    prepass_bindings::previous_view_uniforms,
    pbr_prepass_functions::calculate_motion_vector,
}
#endif
#endif

/// Functions to be used by materials for reading from a meshlet visibility buffer texture.

#ifdef MESHLET_MESH_MATERIAL_PASS
struct PartialDerivatives {
    barycentrics: vec3<f32>,
    ddx: vec3<f32>,
    ddy: vec3<f32>,
}

// https://github.com/ConfettiFX/The-Forge/blob/2d453f376ef278f66f97cbaf36c0d12e4361e275/Examples_3/Visibility_Buffer/src/Shaders/FSL/visibilityBuffer_shade.frag.fsl#L83-L139
fn compute_partial_derivatives(vertex_clip_positions: array<vec4<f32>, 3>, ndc_uv: vec2<f32>, screen_size: vec2<f32>) -> PartialDerivatives {
    var result: PartialDerivatives;

    let inv_w = 1.0 / vec3(vertex_clip_positions[0].w, vertex_clip_positions[1].w, vertex_clip_positions[2].w);
    let ndc_0 = vertex_clip_positions[0].xy * inv_w[0];
    let ndc_1 = vertex_clip_positions[1].xy * inv_w[1];
    let ndc_2 = vertex_clip_positions[2].xy * inv_w[2];

    let inv_det = 1.0 / determinant(mat2x2(ndc_2 - ndc_1, ndc_0 - ndc_1));
    result.ddx = vec3(ndc_1.y - ndc_2.y, ndc_2.y - ndc_0.y, ndc_0.y - ndc_1.y) * inv_det * inv_w;
    result.ddy = vec3(ndc_2.x - ndc_1.x, ndc_0.x - ndc_2.x, ndc_1.x - ndc_0.x) * inv_det * inv_w;

    var ddx_sum = dot(result.ddx, vec3(1.0));
    var ddy_sum = dot(result.ddy, vec3(1.0));

    let delta_v = ndc_uv - ndc_0;
    let interp_inv_w = inv_w.x + delta_v.x * ddx_sum + delta_v.y * ddy_sum;
    let interp_w = 1.0 / interp_inv_w;

    result.barycentrics = vec3(
        interp_w * (delta_v.x * result.ddx.x + delta_v.y * result.ddy.x + inv_w.x),
        interp_w * (delta_v.x * result.ddx.y + delta_v.y * result.ddy.y),
        interp_w * (delta_v.x * result.ddx.z + delta_v.y * result.ddy.z),
    );

    result.ddx *= 2.0 / screen_size.x;
    result.ddy *= 2.0 / screen_size.y;
    ddx_sum *= 2.0 / screen_size.x;
    ddy_sum *= 2.0 / screen_size.y;

    let interp_ddx_w = 1.0 / (interp_inv_w + ddx_sum);
    let interp_ddy_w = 1.0 / (interp_inv_w + ddy_sum);

    result.ddx = interp_ddx_w * (result.barycentrics * interp_inv_w + result.ddx) - result.barycentrics;
    result.ddy = interp_ddy_w * (result.barycentrics * interp_inv_w + result.ddy) - result.barycentrics;
    return result;
}

struct VertexOutput {
    position: vec4<f32>,
    world_position: vec4<f32>,
    world_normal: vec3<f32>,
    uv: vec2<f32>,
    ddx_uv: vec2<f32>,
    ddy_uv: vec2<f32>,
    world_tangent: vec4<f32>,
    mesh_flags: u32,
    meshlet_id: u32,
#ifdef PREPASS_FRAGMENT
#ifdef MOTION_VECTOR_PREPASS
    motion_vector: vec2<f32>,
#endif
#endif
}

/// Load the visibility buffer texture and resolve it into a VertexOutput.
fn resolve_vertex_output(frag_coord: vec4<f32>) -> VertexOutput {
    let vbuffer = textureLoad(meshlet_visibility_buffer, vec2<i32>(frag_coord.xy), 0).r;
    let cluster_id = vbuffer >> 8u;
    let meshlet_id = meshlet_thread_meshlet_ids[cluster_id];
    let meshlet = meshlets[meshlet_id];
    let triangle_id = extractBits(vbuffer, 0u, 8u);
    let index_ids = meshlet.start_index_id + vec3(triangle_id * 3u) + vec3(0u, 1u, 2u);
    let indices = meshlet.start_vertex_id + vec3(get_meshlet_index(index_ids.x), get_meshlet_index(index_ids.y), get_meshlet_index(index_ids.z));
    let vertex_ids = vec3(meshlet_vertex_ids[indices.x], meshlet_vertex_ids[indices.y], meshlet_vertex_ids[indices.z]);
    let vertex_1 = unpack_meshlet_vertex(meshlet_vertex_data[vertex_ids.x]);
    let vertex_2 = unpack_meshlet_vertex(meshlet_vertex_data[vertex_ids.y]);
    let vertex_3 = unpack_meshlet_vertex(meshlet_vertex_data[vertex_ids.z]);

    let instance_id = meshlet_thread_instance_ids[cluster_id];
    let instance_uniform = meshlet_instance_uniforms[instance_id];
    let model = affine3_to_square(instance_uniform.model);

    let world_position_1 = mesh_position_local_to_world(model, vec4(vertex_1.position, 1.0));
    let world_position_2 = mesh_position_local_to_world(model, vec4(vertex_2.position, 1.0));
    let world_position_3 = mesh_position_local_to_world(model, vec4(vertex_3.position, 1.0));
    let clip_position_1 = position_world_to_clip(world_position_1.xyz);
    let clip_position_2 = position_world_to_clip(world_position_2.xyz);
    let clip_position_3 = position_world_to_clip(world_position_3.xyz);
    let frag_coord_ndc = frag_coord_to_ndc(frag_coord).xy;
    let partial_derivatives = compute_partial_derivatives(
        array(clip_position_1, clip_position_2, clip_position_3),
        frag_coord_ndc,
        view.viewport.zw,
    );

    let world_position = mat3x4(world_position_1, world_position_2, world_position_3) * partial_derivatives.barycentrics;
    let vertex_normal = mat3x3(vertex_1.normal, vertex_2.normal, vertex_3.normal) * partial_derivatives.barycentrics;
    let world_normal = normalize(
        mat2x4_f32_to_mat3x3_unpack(
            instance_uniform.inverse_transpose_model_a,
            instance_uniform.inverse_transpose_model_b,
        ) * vertex_normal
    );
    let uv = mat3x2(vertex_1.uv, vertex_2.uv, vertex_3.uv) * partial_derivatives.barycentrics;
    let ddx_uv = mat3x2(vertex_1.uv, vertex_2.uv, vertex_3.uv) * partial_derivatives.ddx;
    let ddy_uv = mat3x2(vertex_1.uv, vertex_2.uv, vertex_3.uv) * partial_derivatives.ddy;
    let vertex_tangent = mat3x4(vertex_1.tangent, vertex_2.tangent, vertex_3.tangent) * partial_derivatives.barycentrics;
    let world_tangent = vec4(
        normalize(
            mat3x3(
                model[0].xyz,
                model[1].xyz,
                model[2].xyz
            ) * vertex_tangent.xyz
        ),
        vertex_tangent.w * (f32(bool(instance_uniform.flags & MESH_FLAGS_SIGN_DETERMINANT_MODEL_3X3_BIT)) * 2.0 - 1.0)
    );

#ifdef PREPASS_FRAGMENT
#ifdef MOTION_VECTOR_PREPASS
    let previous_model = affine3_to_square(instance_uniform.previous_model);
    let previous_world_position_1 = mesh_position_local_to_world(previous_model, vec4(vertex_1.position, 1.0));
    let previous_world_position_2 = mesh_position_local_to_world(previous_model, vec4(vertex_2.position, 1.0));
    let previous_world_position_3 = mesh_position_local_to_world(previous_model, vec4(vertex_3.position, 1.0));
    let previous_clip_position_1 = previous_view_uniforms.view_proj * vec4(previous_world_position_1.xyz, 1.0);
    let previous_clip_position_2 = previous_view_uniforms.view_proj * vec4(previous_world_position_2.xyz, 1.0);
    let previous_clip_position_3 = previous_view_uniforms.view_proj * vec4(previous_world_position_3.xyz, 1.0);
    let previous_partial_derivatives = compute_partial_derivatives(
        array(previous_clip_position_1, previous_clip_position_2, previous_clip_position_3),
        frag_coord_ndc,
        view.viewport.zw,
    );
    let previous_world_position = mat3x4(previous_world_position_1, previous_world_position_2, previous_world_position_3) * previous_partial_derivatives.barycentrics;
    let motion_vector = calculate_motion_vector(world_position, previous_world_position);
#endif
#endif

    return VertexOutput(
        frag_coord,
        world_position,
        world_normal,
        uv,
        ddx_uv,
        ddy_uv,
        world_tangent,
        instance_uniform.flags,
        meshlet_id,
#ifdef PREPASS_FRAGMENT
#ifdef MOTION_VECTOR_PREPASS
        motion_vector,
#endif
#endif
    );
}
#endif

```

### crates/bevy_pbr/src/meshlet/dummy_visibility_buffer_resolve

```rust
#define_import_path bevy_pbr::meshlet_visibility_buffer_resolve

/// Dummy shader to prevent naga_oil from complaining about missing imports when the MeshletPlugin is not loaded,
/// as naga_oil tries to resolve imports even if they're behind an #ifdef.

```

### crates/bevy_pbr/src/meshlet/visibility_buffer_raster

```rust
#import bevy_pbr::{
    meshlet_bindings::{
        meshlet_thread_meshlet_ids,
        meshlets,
        meshlet_vertex_ids,
        meshlet_vertex_data,
        meshlet_thread_instance_ids,
        meshlet_instance_uniforms,
        meshlet_instance_material_ids,
        draw_index_buffer,
        view,
        get_meshlet_index,
        unpack_meshlet_vertex,
    },
    mesh_functions::mesh_position_local_to_world,
}
#import bevy_render::maths::affine3_to_square

/// Vertex/fragment shader for rasterizing meshlets into a visibility buffer.

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
#ifdef MESHLET_VISIBILITY_BUFFER_RASTER_PASS_OUTPUT
    @location(0) @interpolate(flat) visibility: u32,
    @location(1) @interpolate(flat) material_depth: u32,
#endif
#ifdef DEPTH_CLAMP_ORTHO
    @location(0) unclamped_clip_depth: f32,
#endif
}

#ifdef MESHLET_VISIBILITY_BUFFER_RASTER_PASS_OUTPUT
struct FragmentOutput {
    @location(0) visibility: vec4<u32>,
    @location(1) material_depth: vec4<u32>,
}
#endif

@vertex
fn vertex(@builtin(vertex_index) vertex_index: u32) -> VertexOutput {
    let packed_ids = draw_index_buffer[vertex_index / 3u];
    let cluster_id = packed_ids >> 8u;
    let triangle_id = extractBits(packed_ids, 0u, 8u);
    let index_id = (triangle_id * 3u) + (vertex_index % 3u);
    let meshlet_id = meshlet_thread_meshlet_ids[cluster_id];
    let meshlet = meshlets[meshlet_id];
    let index = get_meshlet_index(meshlet.start_index_id + index_id);
    let vertex_id = meshlet_vertex_ids[meshlet.start_vertex_id + index];
    let vertex = unpack_meshlet_vertex(meshlet_vertex_data[vertex_id]);
    let instance_id = meshlet_thread_instance_ids[cluster_id];
    let instance_uniform = meshlet_instance_uniforms[instance_id];

    let model = affine3_to_square(instance_uniform.model);
    let world_position = mesh_position_local_to_world(model, vec4(vertex.position, 1.0));
    var clip_position = view.view_proj * vec4(world_position.xyz, 1.0);
#ifdef DEPTH_CLAMP_ORTHO
    let unclamped_clip_depth = clip_position.z;
    clip_position.z = min(clip_position.z, 1.0);
#endif

    return VertexOutput(
        clip_position,
#ifdef MESHLET_VISIBILITY_BUFFER_RASTER_PASS_OUTPUT
        packed_ids,
        meshlet_instance_material_ids[instance_id],
#endif
#ifdef DEPTH_CLAMP_ORTHO
        unclamped_clip_depth,
#endif
    );
}

#ifdef MESHLET_VISIBILITY_BUFFER_RASTER_PASS_OUTPUT
@fragment
fn fragment(vertex_output: VertexOutput) -> FragmentOutput {
    return FragmentOutput(
        vec4(vertex_output.visibility, 0u, 0u, 0u),
        vec4(vertex_output.material_depth, 0u, 0u, 0u),
    );
}
#endif

#ifdef DEPTH_CLAMP_ORTHO
@fragment
fn fragment(vertex_output: VertexOutput) -> @builtin(frag_depth) f32 {
    return vertex_output.unclamped_clip_depth;
}
#endif

```

### crates/bevy_pbr/src/light_probe/environment_map

```rust
#define_import_path bevy_pbr::environment_map

#import bevy_pbr::light_probe::query_light_probe
#import bevy_pbr::mesh_view_bindings as bindings
#import bevy_pbr::mesh_view_bindings::light_probes

struct EnvironmentMapLight {
    diffuse: vec3<f32>,
    specular: vec3<f32>,
};

struct EnvironmentMapRadiances {
    irradiance: vec3<f32>,
    radiance: vec3<f32>,
}

// Define two versions of this function, one for the case in which there are
// multiple light probes and one for the case in which only the view light probe
// is present.

#ifdef MULTIPLE_LIGHT_PROBES_IN_ARRAY

fn compute_radiances(
    perceptual_roughness: f32,
    N: vec3<f32>,
    R: vec3<f32>,
    world_position: vec3<f32>,
    found_diffuse_indirect: bool,
) -> EnvironmentMapRadiances {
    var radiances: EnvironmentMapRadiances;

    // Search for a reflection probe that contains the fragment.
    var query_result = query_light_probe(world_position, /*is_irradiance_volume=*/ false);

    // If we didn't find a reflection probe, use the view environment map if applicable.
    if (query_result.texture_index < 0) {
        query_result.texture_index = light_probes.view_cubemap_index;
        query_result.intensity = light_probes.intensity_for_view;
    }

    // If there's no cubemap, bail out.
    if (query_result.texture_index < 0) {
        radiances.irradiance = vec3(0.0);
        radiances.radiance = vec3(0.0);
        return radiances;
    }

    // Split-sum approximation for image based lighting: https://cdn2.unrealengine.com/Resources/files/2013SiggraphPresentationsNotes-26915738.pdf
    let radiance_level = perceptual_roughness * f32(textureNumLevels(
        bindings::specular_environment_maps[query_result.texture_index]) - 1u);

    if (!found_diffuse_indirect) {
        radiances.irradiance = textureSampleLevel(
            bindings::diffuse_environment_maps[query_result.texture_index],
            bindings::environment_map_sampler,
            vec3(N.xy, -N.z),
            0.0).rgb * query_result.intensity;
    }

    radiances.radiance = textureSampleLevel(
        bindings::specular_environment_maps[query_result.texture_index],
        bindings::environment_map_sampler,
        vec3(R.xy, -R.z),
        radiance_level).rgb * query_result.intensity;

    return radiances;
}

#else   // MULTIPLE_LIGHT_PROBES_IN_ARRAY

fn compute_radiances(
    perceptual_roughness: f32,
    N: vec3<f32>,
    R: vec3<f32>,
    world_position: vec3<f32>,
    found_diffuse_indirect: bool,
) -> EnvironmentMapRadiances {
    var radiances: EnvironmentMapRadiances;

    if (light_probes.view_cubemap_index < 0) {
        radiances.irradiance = vec3(0.0);
        radiances.radiance = vec3(0.0);
        return radiances;
    }

    // Split-sum approximation for image based lighting: https://cdn2.unrealengine.com/Resources/files/2013SiggraphPresentationsNotes-26915738.pdf
    // Technically we could use textureNumLevels(specular_environment_map) - 1 here, but we use a uniform
    // because textureNumLevels() does not work on WebGL2
    let radiance_level = perceptual_roughness * f32(light_probes.smallest_specular_mip_level_for_view);

    let intensity = light_probes.intensity_for_view;

    if (!found_diffuse_indirect) {
        radiances.irradiance = textureSampleLevel(
            bindings::diffuse_environment_map,
            bindings::environment_map_sampler,
            vec3(N.xy, -N.z),
            0.0).rgb * intensity;
    }

    radiances.radiance = textureSampleLevel(
        bindings::specular_environment_map,
        bindings::environment_map_sampler,
        vec3(R.xy, -R.z),
        radiance_level).rgb * intensity;

    return radiances;
}

#endif  // MULTIPLE_LIGHT_PROBES_IN_ARRAY

fn environment_map_light(
    perceptual_roughness: f32,
    roughness: f32,
    diffuse_color: vec3<f32>,
    NdotV: f32,
    f_ab: vec2<f32>,
    N: vec3<f32>,
    R: vec3<f32>,
    F0: vec3<f32>,
    world_position: vec3<f32>,
    found_diffuse_indirect: bool,
) -> EnvironmentMapLight {
    var out: EnvironmentMapLight;

    let radiances = compute_radiances(
        perceptual_roughness,
        N,
        R,
        world_position,
        found_diffuse_indirect);
    if (all(radiances.irradiance == vec3(0.0)) && all(radiances.radiance == vec3(0.0))) {
        out.diffuse = vec3(0.0);
        out.specular = vec3(0.0);
        return out;
    }

    // No real world material has specular values under 0.02, so we use this range as a
    // "pre-baked specular occlusion" that extinguishes the fresnel term, for artistic control.
    // See: https://google.github.io/filament/Filament.html#specularocclusion
    let specular_occlusion = saturate(dot(F0, vec3(50.0 * 0.33)));

    // Multiscattering approximation: https://www.jcgt.org/published/0008/01/03/paper.pdf
    // Useful reference: https://bruop.github.io/ibl
    let Fr = max(vec3(1.0 - roughness), F0) - F0;
    let kS = F0 + Fr * pow(1.0 - NdotV, 5.0);
    let Ess = f_ab.x + f_ab.y;
    let FssEss = kS * Ess * specular_occlusion;
    let Ems = 1.0 - Ess;
    let Favg = F0 + (1.0 - F0) / 21.0;
    let Fms = FssEss * Favg / (1.0 - Ems * Favg);
    let FmsEms = Fms * Ems;
    let Edss = 1.0 - (FssEss + FmsEms);
    let kD = diffuse_color * Edss;


    if (!found_diffuse_indirect) {
        out.diffuse = (FmsEms + kD) * radiances.irradiance;
    } else {
        out.diffuse = vec3(0.0);
    }

    out.specular = FssEss * radiances.radiance;
    return out;
}

```

### crates/bevy_pbr/src/light_probe/light_probe

```rust
#define_import_path bevy_pbr::light_probe

#import bevy_pbr::mesh_view_bindings::light_probes
#import bevy_pbr::mesh_view_types::LightProbe

// The result of searching for a light probe.
struct LightProbeQueryResult {
    // The index of the light probe texture or textures in the binding array or
    // arrays.
    texture_index: i32,
    // A scale factor that's applied to the diffuse and specular light from the
    // light probe. This is in units of cd/m² (candela per square meter).
    intensity: f32,
    // Transform from world space to the light probe model space. In light probe
    // model space, the light probe is a 1×1×1 cube centered on the origin.
    inverse_transform: mat4x4<f32>,
};

fn transpose_affine_matrix(matrix: mat3x4<f32>) -> mat4x4<f32> {
    let matrix4x4 = mat4x4<f32>(
        matrix[0],
        matrix[1],
        matrix[2],
        vec4<f32>(0.0, 0.0, 0.0, 1.0));
    return transpose(matrix4x4);
}

// Searches for a light probe that contains the fragment.
//
// TODO: Interpolate between multiple light probes.
fn query_light_probe(
    world_position: vec3<f32>,
    is_irradiance_volume: bool,
) -> LightProbeQueryResult {
    var result: LightProbeQueryResult;
    result.texture_index = -1;

    var light_probe_count: i32;
    if is_irradiance_volume {
        light_probe_count = light_probes.irradiance_volume_count;
    } else {
        light_probe_count = light_probes.reflection_probe_count;
    }

    for (var light_probe_index: i32 = 0;
            light_probe_index < light_probe_count && result.texture_index < 0;
            light_probe_index += 1) {
        var light_probe: LightProbe;
        if is_irradiance_volume {
            light_probe = light_probes.irradiance_volumes[light_probe_index];
        } else {
            light_probe = light_probes.reflection_probes[light_probe_index];
        }

        // Unpack the inverse transform.
        let inverse_transform =
            transpose_affine_matrix(light_probe.inverse_transpose_transform);

        // Check to see if the transformed point is inside the unit cube
        // centered at the origin.
        let probe_space_pos = (inverse_transform * vec4<f32>(world_position, 1.0f)).xyz;
        if (all(abs(probe_space_pos) <= vec3(0.5f))) {
            result.texture_index = light_probe.cubemap_index;
            result.intensity = light_probe.intensity;
            result.inverse_transform = inverse_transform;

            // TODO: Workaround for ICE in DXC https://github.com/microsoft/DirectXShaderCompiler/issues/6183
            // We can't use `break` here because of the ICE.
            // So instead we rely on the fact that we set `result.texture_index`
            // above and check its value in the `for` loop header before
            // looping.
            // break;
        }
    }

    return result;
}


```

### crates/bevy_pbr/src/light_probe/irradiance_volume

```rust
#define_import_path bevy_pbr::irradiance_volume

#import bevy_pbr::light_probe::query_light_probe
#import bevy_pbr::mesh_view_bindings::{
    irradiance_volumes,
    irradiance_volume,
    irradiance_volume_sampler,
    light_probes,
};

#ifdef IRRADIANCE_VOLUMES_ARE_USABLE

// See:
// https://advances.realtimerendering.com/s2006/Mitchell-ShadingInValvesSourceEngine.pdf
// Slide 28, "Ambient Cube Basis"
fn irradiance_volume_light(world_position: vec3<f32>, N: vec3<f32>) -> vec3<f32> {
    // Search for an irradiance volume that contains the fragment.
    let query_result = query_light_probe(world_position, /*is_irradiance_volume=*/ true);

    // If there was no irradiance volume found, bail out.
    if (query_result.texture_index < 0) {
        return vec3(0.0f);
    }

#ifdef MULTIPLE_LIGHT_PROBES_IN_ARRAY
    let irradiance_volume_texture = irradiance_volumes[query_result.texture_index];
#else
    let irradiance_volume_texture = irradiance_volume;
#endif

    let atlas_resolution = vec3<f32>(textureDimensions(irradiance_volume_texture));
    let resolution = vec3<f32>(textureDimensions(irradiance_volume_texture) / vec3(1u, 2u, 3u));

    // Make sure to clamp to the edges to avoid texture bleed.
    var unit_pos = (query_result.inverse_transform * vec4(world_position, 1.0f)).xyz;
    let stp = clamp((unit_pos + 0.5) * resolution, vec3(0.5f), resolution - vec3(0.5f));
    let uvw = stp / atlas_resolution;

    // The bottom half of each cube slice is the negative part, so choose it if applicable on each
    // slice.
    let neg_offset = select(vec3(0.0f), vec3(0.5f), N < vec3(0.0f));

    let uvw_x = uvw + vec3(0.0f, neg_offset.x, 0.0f);
    let uvw_y = uvw + vec3(0.0f, neg_offset.y, 1.0f / 3.0f);
    let uvw_z = uvw + vec3(0.0f, neg_offset.z, 2.0f / 3.0f);

    let rgb_x = textureSampleLevel(irradiance_volume_texture, irradiance_volume_sampler, uvw_x, 0.0).rgb;
    let rgb_y = textureSampleLevel(irradiance_volume_texture, irradiance_volume_sampler, uvw_y, 0.0).rgb;
    let rgb_z = textureSampleLevel(irradiance_volume_texture, irradiance_volume_sampler, uvw_z, 0.0).rgb;

    // Use Valve's formula to sample.
    let NN = N * N;
    return (rgb_x * NN.x + rgb_y * NN.y + rgb_z * NN.z) * query_result.intensity;
}

#endif  // IRRADIANCE_VOLUMES_ARE_USABLE

```

### crates/bevy_pbr/src/lightmap/lightmap

```rust
#define_import_path bevy_pbr::lightmap

#import bevy_pbr::mesh_bindings::mesh

@group(1) @binding(4) var lightmaps_texture: texture_2d<f32>;
@group(1) @binding(5) var lightmaps_sampler: sampler;

// Samples the lightmap, if any, and returns indirect illumination from it.
fn lightmap(uv: vec2<f32>, exposure: f32, instance_index: u32) -> vec3<f32> {
    let packed_uv_rect = mesh[instance_index].lightmap_uv_rect;
    let uv_rect = vec4<f32>(vec4<u32>(
        packed_uv_rect.x & 0xffffu,
        packed_uv_rect.x >> 16u,
        packed_uv_rect.y & 0xffffu,
        packed_uv_rect.y >> 16u)) / 65535.0;

    let lightmap_uv = mix(uv_rect.xy, uv_rect.zw, uv);

    // Mipmapping lightmaps is usually a bad idea due to leaking across UV
    // islands, so there's no harm in using mip level 0 and it lets us avoid
    // control flow uniformity problems.
    //
    // TODO(pcwalton): Consider bicubic filtering.
    return textureSampleLevel(
        lightmaps_texture,
        lightmaps_sampler,
        lightmap_uv,
        0.0).rgb * exposure;
}

```

### crates/bevy_pbr/src/ssao/spatial_denoise

```rust
// 3x3 bilaterial filter (edge-preserving blur)
// https://people.csail.mit.edu/sparis/bf_course/course_notes.pdf

// Note: Does not use the Gaussian kernel part of a typical bilateral blur
// From the paper: "use the information gathered on a neighborhood of 4 × 4 using a bilateral filter for
// reconstruction, using _uniform_ convolution weights"

// Note: The paper does a 4x4 (not quite centered) filter, offset by +/- 1 pixel every other frame
// XeGTAO does a 3x3 filter, on two pixels at a time per compute thread, applied twice
// We do a 3x3 filter, on 1 pixel per compute thread, applied once

#import bevy_render::view::View

@group(0) @binding(0) var ambient_occlusion_noisy: texture_2d<f32>;
@group(0) @binding(1) var depth_differences: texture_2d<u32>;
@group(0) @binding(2) var ambient_occlusion: texture_storage_2d<r16float, write>;
@group(1) @binding(0) var point_clamp_sampler: sampler;
@group(1) @binding(1) var<uniform> view: View;

@compute
@workgroup_size(8, 8, 1)
fn spatial_denoise(@builtin(global_invocation_id) global_id: vec3<u32>) {
    let pixel_coordinates = vec2<i32>(global_id.xy);
    let uv = vec2<f32>(pixel_coordinates) / view.viewport.zw;

    let edges0 = textureGather(0, depth_differences, point_clamp_sampler, uv);
    let edges1 = textureGather(0, depth_differences, point_clamp_sampler, uv, vec2<i32>(2i, 0i));
    let edges2 = textureGather(0, depth_differences, point_clamp_sampler, uv, vec2<i32>(1i, 2i));
    let visibility0 = textureGather(0, ambient_occlusion_noisy, point_clamp_sampler, uv);
    let visibility1 = textureGather(0, ambient_occlusion_noisy, point_clamp_sampler, uv, vec2<i32>(2i, 0i));
    let visibility2 = textureGather(0, ambient_occlusion_noisy, point_clamp_sampler, uv, vec2<i32>(0i, 2i));
    let visibility3 = textureGather(0, ambient_occlusion_noisy, point_clamp_sampler, uv, vec2<i32>(2i, 2i));

    let left_edges = unpack4x8unorm(edges0.x);
    let right_edges = unpack4x8unorm(edges1.x);
    let top_edges = unpack4x8unorm(edges0.z);
    let bottom_edges = unpack4x8unorm(edges2.w);
    var center_edges = unpack4x8unorm(edges0.y);
    center_edges *= vec4<f32>(left_edges.y, right_edges.x, top_edges.w, bottom_edges.z);

    let center_weight = 1.2;
    let left_weight = center_edges.x;
    let right_weight = center_edges.y;
    let top_weight = center_edges.z;
    let bottom_weight = center_edges.w;
    let top_left_weight = 0.425 * (top_weight * top_edges.x + left_weight * left_edges.z);
    let top_right_weight = 0.425 * (top_weight * top_edges.y + right_weight * right_edges.z);
    let bottom_left_weight = 0.425 * (bottom_weight * bottom_edges.x + left_weight * left_edges.w);
    let bottom_right_weight = 0.425 * (bottom_weight * bottom_edges.y + right_weight * right_edges.w);

    let center_visibility = visibility0.y;
    let left_visibility = visibility0.x;
    let right_visibility = visibility0.z;
    let top_visibility = visibility1.x;
    let bottom_visibility = visibility2.z;
    let top_left_visibility = visibility0.w;
    let top_right_visibility = visibility1.w;
    let bottom_left_visibility = visibility2.w;
    let bottom_right_visibility = visibility3.w;

    var sum = center_visibility;
    sum += left_visibility * left_weight;
    sum += right_visibility * right_weight;
    sum += top_visibility * top_weight;
    sum += bottom_visibility * bottom_weight;
    sum += top_left_visibility * top_left_weight;
    sum += top_right_visibility * top_right_weight;
    sum += bottom_left_visibility * bottom_left_weight;
    sum += bottom_right_visibility * bottom_right_weight;

    var sum_weight = center_weight;
    sum_weight += left_weight;
    sum_weight += right_weight;
    sum_weight += top_weight;
    sum_weight += bottom_weight;
    sum_weight += top_left_weight;
    sum_weight += top_right_weight;
    sum_weight += bottom_left_weight;
    sum_weight += bottom_right_weight;

    let denoised_visibility = sum / sum_weight;

    textureStore(ambient_occlusion, pixel_coordinates, vec4<f32>(denoised_visibility, 0.0, 0.0, 0.0));
}

```

### crates/bevy_pbr/src/ssao/gtao

```rust
// Ground Truth-based Ambient Occlusion (GTAO)
// Paper: https://www.activision.com/cdn/research/Practical_Real_Time_Strategies_for_Accurate_Indirect_Occlusion_NEW%20VERSION_COLOR.pdf
// Presentation: https://blog.selfshadow.com/publications/s2016-shading-course/activision/s2016_pbs_activision_occlusion.pdf

// Source code heavily based on XeGTAO v1.30 from Intel
// https://github.com/GameTechDev/XeGTAO/blob/0d177ce06bfa642f64d8af4de1197ad1bcb862d4/Source/Rendering/Shaders/XeGTAO.hlsli

#import bevy_pbr::{
    gtao_utils::fast_acos,
    utils::{PI, HALF_PI},
}
#import bevy_render::{
    view::View,
    globals::Globals,
}

@group(0) @binding(0) var preprocessed_depth: texture_2d<f32>;
@group(0) @binding(1) var normals: texture_2d<f32>;
@group(0) @binding(2) var hilbert_index_lut: texture_2d<u32>;
@group(0) @binding(3) var ambient_occlusion: texture_storage_2d<r16float, write>;
@group(0) @binding(4) var depth_differences: texture_storage_2d<r32uint, write>;
@group(0) @binding(5) var<uniform> globals: Globals;
@group(1) @binding(0) var point_clamp_sampler: sampler;
@group(1) @binding(1) var<uniform> view: View;

fn load_noise(pixel_coordinates: vec2<i32>) -> vec2<f32> {
    var index = textureLoad(hilbert_index_lut, pixel_coordinates % 64, 0).r;

#ifdef TEMPORAL_JITTER
    index += 288u * (globals.frame_count % 64u);
#endif

    // R2 sequence - http://extremelearning.com.au/unreasonable-effectiveness-of-quasirandom-sequences
    return fract(0.5 + f32(index) * vec2<f32>(0.75487766624669276005, 0.5698402909980532659114));
}

// Calculate differences in depth between neighbor pixels (later used by the spatial denoiser pass to preserve object edges)
fn calculate_neighboring_depth_differences(pixel_coordinates: vec2<i32>) -> f32 {
    // Sample the pixel's depth and 4 depths around it
    let uv = vec2<f32>(pixel_coordinates) / view.viewport.zw;
    let depths_upper_left = textureGather(0, preprocessed_depth, point_clamp_sampler, uv);
    let depths_bottom_right = textureGather(0, preprocessed_depth, point_clamp_sampler, uv, vec2<i32>(1i, 1i));
    let depth_center = depths_upper_left.y;
    let depth_left = depths_upper_left.x;
    let depth_top = depths_upper_left.z;
    let depth_bottom = depths_bottom_right.x;
    let depth_right = depths_bottom_right.z;

    // Calculate the depth differences (large differences represent object edges)
    var edge_info = vec4<f32>(depth_left, depth_right, depth_top, depth_bottom) - depth_center;
    let slope_left_right = (edge_info.y - edge_info.x) * 0.5;
    let slope_top_bottom = (edge_info.w - edge_info.z) * 0.5;
    let edge_info_slope_adjusted = edge_info + vec4<f32>(slope_left_right, -slope_left_right, slope_top_bottom, -slope_top_bottom);
    edge_info = min(abs(edge_info), abs(edge_info_slope_adjusted));
    let bias = 0.25; // Using the bias and then saturating nudges the values a bit
    let scale = depth_center * 0.011; // Weight the edges by their distance from the camera
    edge_info = saturate((1.0 + bias) - edge_info / scale); // Apply the bias and scale, and invert edge_info so that small values become large, and vice versa

    // Pack the edge info into the texture
    let edge_info_packed = vec4<u32>(pack4x8unorm(edge_info), 0u, 0u, 0u);
    textureStore(depth_differences, pixel_coordinates, edge_info_packed);

    return depth_center;
}

fn load_normal_view_space(uv: vec2<f32>) -> vec3<f32> {
    var world_normal = textureSampleLevel(normals, point_clamp_sampler, uv, 0.0).xyz;
    world_normal = (world_normal * 2.0) - 1.0;
    let inverse_view = mat3x3<f32>(
        view.inverse_view[0].xyz,
        view.inverse_view[1].xyz,
        view.inverse_view[2].xyz,
    );
    return inverse_view * world_normal;
}

fn reconstruct_view_space_position(depth: f32, uv: vec2<f32>) -> vec3<f32> {
    let clip_xy = vec2<f32>(uv.x * 2.0 - 1.0, 1.0 - 2.0 * uv.y);
    let t = view.inverse_projection * vec4<f32>(clip_xy, depth, 1.0);
    let view_xyz = t.xyz / t.w;
    return view_xyz;
}

fn load_and_reconstruct_view_space_position(uv: vec2<f32>, sample_mip_level: f32) -> vec3<f32> {
    let depth = textureSampleLevel(preprocessed_depth, point_clamp_sampler, uv, sample_mip_level).r;
    return reconstruct_view_space_position(depth, uv);
}

@compute
@workgroup_size(8, 8, 1)
fn gtao(@builtin(global_invocation_id) global_id: vec3<u32>) {
    let slice_count = f32(#SLICE_COUNT);
    let samples_per_slice_side = f32(#SAMPLES_PER_SLICE_SIDE);
    let effect_radius = 0.5 * 1.457;
    let falloff_range = 0.615 * effect_radius;
    let falloff_from = effect_radius * (1.0 - 0.615);
    let falloff_mul = -1.0 / falloff_range;
    let falloff_add = falloff_from / falloff_range + 1.0;

    let pixel_coordinates = vec2<i32>(global_id.xy);
    let uv = (vec2<f32>(pixel_coordinates) + 0.5) / view.viewport.zw;

    var pixel_depth = calculate_neighboring_depth_differences(pixel_coordinates);
    pixel_depth += 0.00001; // Avoid depth precision issues

    let pixel_position = reconstruct_view_space_position(pixel_depth, uv);
    let pixel_normal = load_normal_view_space(uv);
    let view_vec = normalize(-pixel_position);

    let noise = load_noise(pixel_coordinates);
    let sample_scale = (-0.5 * effect_radius * view.projection[0][0]) / pixel_position.z;

    var visibility = 0.0;
    for (var slice_t = 0.0; slice_t < slice_count; slice_t += 1.0) {
        let slice = slice_t + noise.x;
        let phi = (PI / slice_count) * slice;
        let omega = vec2<f32>(cos(phi), sin(phi));

        let direction = vec3<f32>(omega.xy, 0.0);
        let orthographic_direction = direction - (dot(direction, view_vec) * view_vec);
        let axis = cross(direction, view_vec);
        let projected_normal = pixel_normal - axis * dot(pixel_normal, axis);
        let projected_normal_length = length(projected_normal);

        let sign_norm = sign(dot(orthographic_direction, projected_normal));
        let cos_norm = saturate(dot(projected_normal, view_vec) / projected_normal_length);
        let n = sign_norm * fast_acos(cos_norm);

        let min_cos_horizon_1 = cos(n + HALF_PI);
        let min_cos_horizon_2 = cos(n - HALF_PI);
        var cos_horizon_1 = min_cos_horizon_1;
        var cos_horizon_2 = min_cos_horizon_2;
        let sample_mul = vec2<f32>(omega.x, -omega.y) * sample_scale;
        for (var sample_t = 0.0; sample_t < samples_per_slice_side; sample_t += 1.0) {
            var sample_noise = (slice_t + sample_t * samples_per_slice_side) * 0.6180339887498948482;
            sample_noise = fract(noise.y + sample_noise);

            var s = (sample_t + sample_noise) / samples_per_slice_side;
            s *= s; // https://github.com/GameTechDev/XeGTAO#sample-distribution
            let sample = s * sample_mul;

            // * view.viewport.zw gets us from [0, 1] to [0, viewport_size], which is needed for this to get the correct mip levels
            let sample_mip_level = clamp(log2(length(sample * view.viewport.zw)) - 3.3, 0.0, 5.0); // https://github.com/GameTechDev/XeGTAO#memory-bandwidth-bottleneck
            let sample_position_1 = load_and_reconstruct_view_space_position(uv + sample, sample_mip_level);
            let sample_position_2 = load_and_reconstruct_view_space_position(uv - sample, sample_mip_level);

            let sample_difference_1 = sample_position_1 - pixel_position;
            let sample_difference_2 = sample_position_2 - pixel_position;
            let sample_distance_1 = length(sample_difference_1);
            let sample_distance_2 = length(sample_difference_2);
            var sample_cos_horizon_1 = dot(sample_difference_1 / sample_distance_1, view_vec);
            var sample_cos_horizon_2 = dot(sample_difference_2 / sample_distance_2, view_vec);

            let weight_1 = saturate(sample_distance_1 * falloff_mul + falloff_add);
            let weight_2 = saturate(sample_distance_2 * falloff_mul + falloff_add);
            sample_cos_horizon_1 = mix(min_cos_horizon_1, sample_cos_horizon_1, weight_1);
            sample_cos_horizon_2 = mix(min_cos_horizon_2, sample_cos_horizon_2, weight_2);

            cos_horizon_1 = max(cos_horizon_1, sample_cos_horizon_1);
            cos_horizon_2 = max(cos_horizon_2, sample_cos_horizon_2);
        }

        let horizon_1 = fast_acos(cos_horizon_1);
        let horizon_2 = -fast_acos(cos_horizon_2);
        let v1 = (cos_norm + 2.0 * horizon_1 * sin(n) - cos(2.0 * horizon_1 - n)) / 4.0;
        let v2 = (cos_norm + 2.0 * horizon_2 * sin(n) - cos(2.0 * horizon_2 - n)) / 4.0;
        visibility += projected_normal_length * (v1 + v2);
    }
    visibility /= slice_count;
    visibility = clamp(visibility, 0.03, 1.0);

    textureStore(ambient_occlusion, pixel_coordinates, vec4<f32>(visibility, 0.0, 0.0, 0.0));
}

```

### crates/bevy_pbr/src/ssao/gtao_utils

```rust
#define_import_path bevy_pbr::gtao_utils

#import bevy_pbr::utils::{PI, HALF_PI}

// Approximates single-bounce ambient occlusion to multi-bounce ambient occlusion
// https://blog.selfshadow.com/publications/s2016-shading-course/activision/s2016_pbs_activision_occlusion.pdf#page=78
fn gtao_multibounce(visibility: f32, base_color: vec3<f32>) -> vec3<f32> {
    let a = 2.0404 * base_color - 0.3324;
    let b = -4.7951 * base_color + 0.6417;
    let c = 2.7552 * base_color + 0.6903;
    let x = vec3<f32>(visibility);
    return max(x, ((x * a + b) * x + c) * x);
}

fn fast_sqrt(x: f32) -> f32 {
    return bitcast<f32>(0x1fbd1df5 + (bitcast<i32>(x) >> 1u));
}

fn fast_acos(in_x: f32) -> f32 {
    let x = abs(in_x);
    var res = -0.156583 * x + HALF_PI;
    res *= fast_sqrt(1.0 - x);
    return select(PI - res, res, in_x >= 0.0);
}

```

### crates/bevy_pbr/src/ssao/preprocess_depth

```rust
// Inputs a depth texture and outputs a MIP-chain of depths.
//
// Because SSAO's performance is bound by texture reads, this increases
// performance over using the full resolution depth for every sample.

// Reference: https://research.nvidia.com/sites/default/files/pubs/2012-06_Scalable-Ambient-Obscurance/McGuire12SAO.pdf, section 2.2

#import bevy_render::view::View

@group(0) @binding(0) var input_depth: texture_depth_2d;
@group(0) @binding(1) var preprocessed_depth_mip0: texture_storage_2d<r16float, write>;
@group(0) @binding(2) var preprocessed_depth_mip1: texture_storage_2d<r16float, write>;
@group(0) @binding(3) var preprocessed_depth_mip2: texture_storage_2d<r16float, write>;
@group(0) @binding(4) var preprocessed_depth_mip3: texture_storage_2d<r16float, write>;
@group(0) @binding(5) var preprocessed_depth_mip4: texture_storage_2d<r16float, write>;
@group(1) @binding(0) var point_clamp_sampler: sampler;
@group(1) @binding(1) var<uniform> view: View;


// Using 4 depths from the previous MIP, compute a weighted average for the depth of the current MIP
fn weighted_average(depth0: f32, depth1: f32, depth2: f32, depth3: f32) -> f32 {
    let depth_range_scale_factor = 0.75;
    let effect_radius = depth_range_scale_factor * 0.5 * 1.457;
    let falloff_range = 0.615 * effect_radius;
    let falloff_from = effect_radius * (1.0 - 0.615);
    let falloff_mul = -1.0 / falloff_range;
    let falloff_add = falloff_from / falloff_range + 1.0;

    let min_depth = min(min(depth0, depth1), min(depth2, depth3));
    let weight0 = saturate((depth0 - min_depth) * falloff_mul + falloff_add);
    let weight1 = saturate((depth1 - min_depth) * falloff_mul + falloff_add);
    let weight2 = saturate((depth2 - min_depth) * falloff_mul + falloff_add);
    let weight3 = saturate((depth3 - min_depth) * falloff_mul + falloff_add);
    let weight_total = weight0 + weight1 + weight2 + weight3;

    return ((weight0 * depth0) + (weight1 * depth1) + (weight2 * depth2) + (weight3 * depth3)) / weight_total;
}

// Used to share the depths from the previous MIP level between all invocations in a workgroup
var<workgroup> previous_mip_depth: array<array<f32, 8>, 8>;

@compute
@workgroup_size(8, 8, 1)
fn preprocess_depth(@builtin(global_invocation_id) global_id: vec3<u32>, @builtin(local_invocation_id) local_id: vec3<u32>) {
    let base_coordinates = vec2<i32>(global_id.xy);

    // MIP 0 - Copy 4 texels from the input depth (per invocation, 8x8 invocations per workgroup)
    let pixel_coordinates0 = base_coordinates * 2i;
    let pixel_coordinates1 = pixel_coordinates0 + vec2<i32>(1i, 0i);
    let pixel_coordinates2 = pixel_coordinates0 + vec2<i32>(0i, 1i);
    let pixel_coordinates3 = pixel_coordinates0 + vec2<i32>(1i, 1i);
    let depths_uv = vec2<f32>(pixel_coordinates0) / view.viewport.zw;
    let depths = textureGather(0, input_depth, point_clamp_sampler, depths_uv, vec2<i32>(1i, 1i));
    textureStore(preprocessed_depth_mip0, pixel_coordinates0, vec4<f32>(depths.w, 0.0, 0.0, 0.0));
    textureStore(preprocessed_depth_mip0, pixel_coordinates1, vec4<f32>(depths.z, 0.0, 0.0, 0.0));
    textureStore(preprocessed_depth_mip0, pixel_coordinates2, vec4<f32>(depths.x, 0.0, 0.0, 0.0));
    textureStore(preprocessed_depth_mip0, pixel_coordinates3, vec4<f32>(depths.y, 0.0, 0.0, 0.0));

    // MIP 1 - Weighted average of MIP 0's depth values (per invocation, 8x8 invocations per workgroup)
    let depth_mip1 = weighted_average(depths.w, depths.z, depths.x, depths.y);
    textureStore(preprocessed_depth_mip1, base_coordinates, vec4<f32>(depth_mip1, 0.0, 0.0, 0.0));
    previous_mip_depth[local_id.x][local_id.y] = depth_mip1;

    workgroupBarrier();

    // MIP 2 - Weighted average of MIP 1's depth values (per invocation, 4x4 invocations per workgroup)
    if all(local_id.xy % vec2<u32>(2u) == vec2<u32>(0u)) {
        let depth0 = previous_mip_depth[local_id.x + 0u][local_id.y + 0u];
        let depth1 = previous_mip_depth[local_id.x + 1u][local_id.y + 0u];
        let depth2 = previous_mip_depth[local_id.x + 0u][local_id.y + 1u];
        let depth3 = previous_mip_depth[local_id.x + 1u][local_id.y + 1u];
        let depth_mip2 = weighted_average(depth0, depth1, depth2, depth3);
        textureStore(preprocessed_depth_mip2, base_coordinates / 2i, vec4<f32>(depth_mip2, 0.0, 0.0, 0.0));
        previous_mip_depth[local_id.x][local_id.y] = depth_mip2;
    }

    workgroupBarrier();

    // MIP 3 - Weighted average of MIP 2's depth values (per invocation, 2x2 invocations per workgroup)
    if all(local_id.xy % vec2<u32>(4u) == vec2<u32>(0u)) {
        let depth0 = previous_mip_depth[local_id.x + 0u][local_id.y + 0u];
        let depth1 = previous_mip_depth[local_id.x + 2u][local_id.y + 0u];
        let depth2 = previous_mip_depth[local_id.x + 0u][local_id.y + 2u];
        let depth3 = previous_mip_depth[local_id.x + 2u][local_id.y + 2u];
        let depth_mip3 = weighted_average(depth0, depth1, depth2, depth3);
        textureStore(preprocessed_depth_mip3, base_coordinates / 4i, vec4<f32>(depth_mip3, 0.0, 0.0, 0.0));
        previous_mip_depth[local_id.x][local_id.y] = depth_mip3;
    }

    workgroupBarrier();

    // MIP 4 - Weighted average of MIP 3's depth values (per invocation, 1 invocation per workgroup)
    if all(local_id.xy % vec2<u32>(8u) == vec2<u32>(0u)) {
        let depth0 = previous_mip_depth[local_id.x + 0u][local_id.y + 0u];
        let depth1 = previous_mip_depth[local_id.x + 4u][local_id.y + 0u];
        let depth2 = previous_mip_depth[local_id.x + 0u][local_id.y + 4u];
        let depth3 = previous_mip_depth[local_id.x + 4u][local_id.y + 4u];
        let depth_mip4 = weighted_average(depth0, depth1, depth2, depth3);
        textureStore(preprocessed_depth_mip4, base_coordinates / 8i, vec4<f32>(depth_mip4, 0.0, 0.0, 0.0));
    }
}

```

### crates/bevy_pbr/src/deferred/deferred_lighting

```rust
#import bevy_pbr::{
    prepass_utils,
    pbr_types::STANDARD_MATERIAL_FLAGS_UNLIT_BIT,
    pbr_functions,
    pbr_deferred_functions::pbr_input_from_deferred_gbuffer,
    pbr_deferred_types::unpack_unorm3x4_plus_unorm_20_,
    lighting,
    mesh_view_bindings::deferred_prepass_texture,
}

#ifdef SCREEN_SPACE_AMBIENT_OCCLUSION
#import bevy_pbr::mesh_view_bindings::screen_space_ambient_occlusion_texture
#import bevy_pbr::gtao_utils::gtao_multibounce
#endif

struct FullscreenVertexOutput {
    @builtin(position)
    position: vec4<f32>,
    @location(0)
    uv: vec2<f32>,
};

struct PbrDeferredLightingDepthId {
    depth_id: u32, // limited to u8
#ifdef SIXTEEN_BYTE_ALIGNMENT
    // WebGL2 structs must be 16 byte aligned.
    _webgl2_padding_0: f32,
    _webgl2_padding_1: f32,
    _webgl2_padding_2: f32,
#endif
}
@group(1) @binding(0)
var<uniform> depth_id: PbrDeferredLightingDepthId;

@vertex
fn vertex(@builtin(vertex_index) vertex_index: u32) -> FullscreenVertexOutput {
    // See the full screen vertex shader for explanation above for how this works.
    let uv = vec2<f32>(f32(vertex_index >> 1u), f32(vertex_index & 1u)) * 2.0;
    // Depth is stored as unorm, so we are dividing the u8 depth_id by 255.0 here.
    let clip_position = vec4<f32>(uv * vec2<f32>(2.0, -2.0) + vec2<f32>(-1.0, 1.0), f32(depth_id.depth_id) / 255.0, 1.0);

    return FullscreenVertexOutput(clip_position, uv);
}

@fragment
fn fragment(in: FullscreenVertexOutput) -> @location(0) vec4<f32> {
    var frag_coord = vec4(in.position.xy, 0.0, 0.0);

    let deferred_data = textureLoad(deferred_prepass_texture, vec2<i32>(frag_coord.xy), 0);

#ifdef WEBGL2
    frag_coord.z = unpack_unorm3x4_plus_unorm_20_(deferred_data.b).w;
#else
#ifdef DEPTH_PREPASS
    frag_coord.z = prepass_utils::prepass_depth(in.position, 0u);
#endif
#endif

    var pbr_input = pbr_input_from_deferred_gbuffer(frag_coord, deferred_data);
    var output_color = vec4(0.0);

    // NOTE: Unlit bit not set means == 0 is true, so the true case is if lit
    if ((pbr_input.material.flags & STANDARD_MATERIAL_FLAGS_UNLIT_BIT) == 0u) {

#ifdef SCREEN_SPACE_AMBIENT_OCCLUSION
        let ssao = textureLoad(screen_space_ambient_occlusion_texture, vec2<i32>(in.position.xy), 0i).r;
        let ssao_multibounce = gtao_multibounce(ssao, pbr_input.material.base_color.rgb);
        pbr_input.diffuse_occlusion = min(pbr_input.diffuse_occlusion, ssao_multibounce);

        // Neubelt and Pettineo 2013, "Crafting a Next-gen Material Pipeline for The Order: 1886"
        let NdotV = max(dot(pbr_input.N, pbr_input.V), 0.0001); 
        var perceptual_roughness: f32 = pbr_input.material.perceptual_roughness;
        let roughness = lighting::perceptualRoughnessToRoughness(perceptual_roughness);
        // Use SSAO to estimate the specular occlusion.
        // Lagarde and Rousiers 2014, "Moving Frostbite to Physically Based Rendering"
        pbr_input.specular_occlusion =  saturate(pow(NdotV + ssao, exp2(-16.0 * roughness - 1.0)) - 1.0 + ssao);
#endif // SCREEN_SPACE_AMBIENT_OCCLUSION

        output_color = pbr_functions::apply_pbr_lighting(pbr_input);
    } else {
        output_color = pbr_input.material.base_color;
    }

    output_color = pbr_functions::main_pass_post_lighting_processing(pbr_input, output_color);

    return output_color;
}


```

### crates/bevy_pbr/src/deferred/pbr_deferred_functions

```rust
#define_import_path bevy_pbr::pbr_deferred_functions

#import bevy_pbr::{
    pbr_types::{PbrInput, pbr_input_new, STANDARD_MATERIAL_FLAGS_UNLIT_BIT},
    pbr_deferred_types as deferred_types,
    pbr_functions,
    rgb9e5,
    mesh_view_bindings::view,
    utils::{octahedral_encode, octahedral_decode},
    prepass_io::FragmentOutput,
    view_transformations::{position_ndc_to_world, frag_coord_to_ndc},
}

#ifdef MESHLET_MESH_MATERIAL_PASS
#import bevy_pbr::meshlet_visibility_buffer_resolve::VertexOutput
#else
#import bevy_pbr::prepass_io::VertexOutput
#endif

#ifdef MOTION_VECTOR_PREPASS
    #import bevy_pbr::pbr_prepass_functions::calculate_motion_vector
#endif

// Creates the deferred gbuffer from a PbrInput.
fn deferred_gbuffer_from_pbr_input(in: PbrInput) -> vec4<u32> {
     // Only monochrome occlusion supported. May not be worth including at all.
     // Some models have baked occlusion, GLTF only supports monochrome.
     // Real time occlusion is applied in the deferred lighting pass.
     // Deriving luminance via Rec. 709. coefficients
     // https://en.wikipedia.org/wiki/Rec._709
    let diffuse_occlusion = dot(in.diffuse_occlusion, vec3<f32>(0.2126, 0.7152, 0.0722));
#ifdef WEBGL2 // More crunched for webgl so we can also fit depth.
    var props = deferred_types::pack_unorm3x4_plus_unorm_20_(vec4(
        in.material.reflectance,
        in.material.metallic,
        diffuse_occlusion,
        in.frag_coord.z));
#else
    var props = deferred_types::pack_unorm4x8_(vec4(
        in.material.reflectance, // could be fewer bits
        in.material.metallic, // could be fewer bits
        diffuse_occlusion, // is this worth including?
        0.0)); // spare
#endif // WEBGL2
    let flags = deferred_types::deferred_flags_from_mesh_material_flags(in.flags, in.material.flags);
    let octahedral_normal = octahedral_encode(normalize(in.N));
    var base_color_srgb = vec3(0.0);
    var emissive = in.material.emissive.rgb;
    if ((in.material.flags & STANDARD_MATERIAL_FLAGS_UNLIT_BIT) != 0u) {
        // Material is unlit, use emissive component of gbuffer for color data.
        // Unlit materials are effectively emissive.
        emissive = in.material.base_color.rgb;
    } else {
        base_color_srgb = pow(in.material.base_color.rgb, vec3(1.0 / 2.2));
    }
    let deferred = vec4(
        deferred_types::pack_unorm4x8_(vec4(base_color_srgb, in.material.perceptual_roughness)),
        rgb9e5::vec3_to_rgb9e5_(emissive),
        props,
        deferred_types::pack_24bit_normal_and_flags(octahedral_normal, flags),
    );
    return deferred;
}

// Creates a PbrInput from the deferred gbuffer.
fn pbr_input_from_deferred_gbuffer(frag_coord: vec4<f32>, gbuffer: vec4<u32>) -> PbrInput {
    var pbr = pbr_input_new();

    let flags = deferred_types::unpack_flags(gbuffer.a);
    let deferred_flags = deferred_types::mesh_material_flags_from_deferred_flags(flags);
    pbr.flags = deferred_flags.x;
    pbr.material.flags = deferred_flags.y;

    let base_rough = deferred_types::unpack_unorm4x8_(gbuffer.r);
    pbr.material.perceptual_roughness = base_rough.a;
    let emissive = rgb9e5::rgb9e5_to_vec3_(gbuffer.g);
    if ((pbr.material.flags & STANDARD_MATERIAL_FLAGS_UNLIT_BIT) != 0u) {
        pbr.material.base_color = vec4(emissive, 1.0);
        pbr.material.emissive = vec4(vec3(0.0), 1.0);
    } else {
        pbr.material.base_color = vec4(pow(base_rough.rgb, vec3(2.2)), 1.0);
        pbr.material.emissive = vec4(emissive, 1.0);
    }
#ifdef WEBGL2 // More crunched for webgl so we can also fit depth.
    let props = deferred_types::unpack_unorm3x4_plus_unorm_20_(gbuffer.b);
    // Bias to 0.5 since that's the value for almost all materials.
    pbr.material.reflectance = saturate(props.r - 0.03333333333);
#else
    let props = deferred_types::unpack_unorm4x8_(gbuffer.b);
    pbr.material.reflectance = props.r;
#endif // WEBGL2
    pbr.material.metallic = props.g;
    pbr.diffuse_occlusion = vec3(props.b);
    let octahedral_normal = deferred_types::unpack_24bit_normal(gbuffer.a);
    let N = octahedral_decode(octahedral_normal);

    let world_position = vec4(position_ndc_to_world(frag_coord_to_ndc(frag_coord)), 1.0);
    let is_orthographic = view.projection[3].w == 1.0;
    let V = pbr_functions::calculate_view(world_position, is_orthographic);

    pbr.frag_coord = frag_coord;
    pbr.world_normal = N;
    pbr.world_position = world_position;
    pbr.N = N;
    pbr.V = V;
    pbr.is_orthographic = is_orthographic;

    return pbr;
}

#ifdef PREPASS_PIPELINE
fn deferred_output(in: VertexOutput, pbr_input: PbrInput) -> FragmentOutput {
    var out: FragmentOutput;

    // gbuffer
    out.deferred = deferred_gbuffer_from_pbr_input(pbr_input);
    // lighting pass id (used to determine which lighting shader to run for the fragment)
    out.deferred_lighting_pass_id = pbr_input.material.deferred_lighting_pass_id;
    // normal if required
#ifdef NORMAL_PREPASS
    out.normal = vec4(in.world_normal * 0.5 + vec3(0.5), 1.0);
#endif
    // motion vectors if required
#ifdef MOTION_VECTOR_PREPASS
#ifdef MESHLET_MESH_MATERIAL_PASS
    out.motion_vector = in.motion_vector;
#else
    out.motion_vector = calculate_motion_vector(in.world_position, in.previous_world_position);
#endif
#endif

    return out;
}
#endif

```

### crates/bevy_pbr/src/deferred/pbr_deferred_types

```rust
#define_import_path bevy_pbr::pbr_deferred_types

#import bevy_pbr::{
    mesh_types::MESH_FLAGS_SHADOW_RECEIVER_BIT,
    pbr_types::{STANDARD_MATERIAL_FLAGS_FOG_ENABLED_BIT, STANDARD_MATERIAL_FLAGS_UNLIT_BIT},
}

// Maximum of 8 bits available
const DEFERRED_FLAGS_UNLIT_BIT: u32                 = 1u;
const DEFERRED_FLAGS_FOG_ENABLED_BIT: u32           = 2u;
const DEFERRED_MESH_FLAGS_SHADOW_RECEIVER_BIT: u32  = 4u;

fn deferred_flags_from_mesh_material_flags(mesh_flags: u32, mat_flags: u32) -> u32 {
    var flags = 0u;
    flags |= u32((mesh_flags & MESH_FLAGS_SHADOW_RECEIVER_BIT) != 0u) * DEFERRED_MESH_FLAGS_SHADOW_RECEIVER_BIT;
    flags |= u32((mat_flags & STANDARD_MATERIAL_FLAGS_FOG_ENABLED_BIT) != 0u) * DEFERRED_FLAGS_FOG_ENABLED_BIT;
    flags |= u32((mat_flags & STANDARD_MATERIAL_FLAGS_UNLIT_BIT) != 0u) * DEFERRED_FLAGS_UNLIT_BIT;
    return flags;
}

fn mesh_material_flags_from_deferred_flags(deferred_flags: u32) -> vec2<u32> {
    var mat_flags = 0u;
    var mesh_flags = 0u;
    mesh_flags |= u32((deferred_flags & DEFERRED_MESH_FLAGS_SHADOW_RECEIVER_BIT) != 0u) * MESH_FLAGS_SHADOW_RECEIVER_BIT;
    mat_flags |= u32((deferred_flags & DEFERRED_FLAGS_FOG_ENABLED_BIT) != 0u) * STANDARD_MATERIAL_FLAGS_FOG_ENABLED_BIT;
    mat_flags |= u32((deferred_flags & DEFERRED_FLAGS_UNLIT_BIT) != 0u) * STANDARD_MATERIAL_FLAGS_UNLIT_BIT;
    return vec2(mesh_flags, mat_flags);
}

const U12MAXF = 4095.0;
const U16MAXF = 65535.0;
const U20MAXF = 1048575.0;

// Storing normals as oct24.
// Flags are stored in the remaining 8 bits.
// https://jcgt.org/published/0003/02/01/paper.pdf
// Could possibly go down to oct20 if the space is needed.

fn pack_24bit_normal_and_flags(octahedral_normal: vec2<f32>, flags: u32) -> u32 {
    let unorm1 = u32(saturate(octahedral_normal.x) * U12MAXF + 0.5);
    let unorm2 = u32(saturate(octahedral_normal.y) * U12MAXF + 0.5);
    return (unorm1 & 0xFFFu) | ((unorm2 & 0xFFFu) << 12u) | ((flags & 0xFFu) << 24u);
}

fn unpack_24bit_normal(packed: u32) -> vec2<f32> {
    let unorm1 = packed & 0xFFFu;
    let unorm2 = (packed >> 12u) & 0xFFFu;
    return vec2(f32(unorm1) / U12MAXF, f32(unorm2) / U12MAXF);
}

fn unpack_flags(packed: u32) -> u32 {
    return (packed >> 24u) & 0xFFu;
}

// The builtin one didn't work in webgl.
// "'unpackUnorm4x8' : no matching overloaded function found"
// https://github.com/gfx-rs/naga/issues/2006
fn unpack_unorm4x8_(v: u32) -> vec4<f32> {
    return vec4(
        f32(v & 0xFFu),
        f32((v >> 8u) & 0xFFu),
        f32((v >> 16u) & 0xFFu),
        f32((v >> 24u) & 0xFFu)
    ) / 255.0;
}

// 'packUnorm4x8' : no matching overloaded function found
// https://github.com/gfx-rs/naga/issues/2006
fn pack_unorm4x8_(values: vec4<f32>) -> u32 {
    let v = vec4<u32>(saturate(values) * 255.0 + 0.5);
    return (v.w << 24u) | (v.z << 16u) | (v.y << 8u) | v.x;
}

// Pack 3x 4bit unorm + 1x 20bit
fn pack_unorm3x4_plus_unorm_20_(v: vec4<f32>) -> u32 {
    let sm = vec3<u32>(saturate(v.xyz) * 15.0 + 0.5);
    let bg = u32(saturate(v.w) * U20MAXF + 0.5);
    return (bg << 12u) | (sm.z << 8u) | (sm.y << 4u) | sm.x;
}

// Unpack 3x 4bit unorm + 1x 20bit
fn unpack_unorm3x4_plus_unorm_20_(v: u32) -> vec4<f32> {
    return vec4(
        f32(v & 0xfu) / 15.0,
        f32((v >> 4u) & 0xFu) / 15.0,
        f32((v >> 8u) & 0xFu) / 15.0,
        f32((v >> 12u) & 0xFFFFFFu) / U20MAXF,
    );
}

```

### assets/shaders/line_material

```rust
#import bevy_pbr::forward_io::VertexOutput

struct LineMaterial {
    color: vec4<f32>,
};

@group(2) @binding(0) var<uniform> material: LineMaterial;

@fragment
fn fragment(
    mesh: VertexOutput,
) -> @location(0) vec4<f32> {
    return material.color;
}

```

### assets/shaders/instancing

```rust
#import bevy_pbr::mesh_functions::{get_model_matrix, mesh_position_local_to_clip}

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

```

### assets/shaders/gpu_readback

```rust
// This shader is used for the gpu_readback example
// The actual work it does is not important for the example

// This is the data that lives in the gpu only buffer
@group(0) @binding(0) var<storage, read_write> data: array<u32>;

@compute @workgroup_size(1)
fn main(@builtin(global_invocation_id) global_id: vec3<u32>) {
    // We use the global_id to index the array to make sure we don't
    // access data used in another workgroup
    data[global_id.x] += 1u;
}

```

### assets/shaders/shader_defs

```rust
#import bevy_pbr::forward_io::VertexOutput

struct CustomMaterial {
    color: vec4<f32>,
};

@group(2) @binding(0) var<uniform> material: CustomMaterial;

@fragment
fn fragment(
    mesh: VertexOutput,
) -> @location(0) vec4<f32> {
#ifdef IS_RED
    return vec4<f32>(1.0, 0.0, 0.0, 1.0);
#else
    return material.color;
#endif
}

```

### assets/shaders/custom_material_import

```rust
// this is made available to the importing module
const COLOR_MULTIPLIER: vec4<f32> = vec4<f32>(1.0, 1.0, 1.0, 0.5);

```

### assets/shaders/extended_material

```rust
#import bevy_pbr::{
    pbr_fragment::pbr_input_from_standard_material,
    pbr_functions::alpha_discard,
}

#ifdef PREPASS_PIPELINE
#import bevy_pbr::{
    prepass_io::{VertexOutput, FragmentOutput},
    pbr_deferred_functions::deferred_output,
}
#else
#import bevy_pbr::{
    forward_io::{VertexOutput, FragmentOutput},
    pbr_functions::{apply_pbr_lighting, main_pass_post_lighting_processing},
}
#endif

struct MyExtendedMaterial {
    quantize_steps: u32,
}

@group(2) @binding(100)
var<uniform> my_extended_material: MyExtendedMaterial;

@fragment
fn fragment(
    in: VertexOutput,
    @builtin(front_facing) is_front: bool,
) -> FragmentOutput {
    // generate a PbrInput struct from the StandardMaterial bindings
    var pbr_input = pbr_input_from_standard_material(in, is_front);

    // we can optionally modify the input before lighting and alpha_discard is applied
    pbr_input.material.base_color.b = pbr_input.material.base_color.r;

    // alpha discard
    pbr_input.material.base_color = alpha_discard(pbr_input.material, pbr_input.material.base_color);

#ifdef PREPASS_PIPELINE
    // in deferred mode we can't modify anything after that, as lighting is run in a separate fullscreen shader.
    let out = deferred_output(in, pbr_input);
#else
    var out: FragmentOutput;
    // apply lighting
    out.color = apply_pbr_lighting(pbr_input);

    // we can optionally modify the lit color before post-processing is applied
    out.color = vec4<f32>(vec4<u32>(out.color * f32(my_extended_material.quantize_steps))) / f32(my_extended_material.quantize_steps);

    // apply in-shader post processing (fog, alpha-premultiply, and also tonemapping, debanding if the camera is non-hdr)
    // note this does not include fullscreen postprocessing effects like bloom.
    out.color = main_pass_post_lighting_processing(pbr_input, out.color);

    // we can optionally modify the final result here
    out.color = out.color * 2.0;
#endif

    return out;
}

```

### assets/shaders/custom_gltf_2d

```rust
#import bevy_sprite::{
    mesh2d_view_bindings::globals,
    mesh2d_functions::{get_model_matrix, mesh2d_position_local_to_clip},
}

struct Vertex {
    @builtin(instance_index) instance_index: u32,
    @location(0) position: vec3<f32>,
    @location(1) color: vec4<f32>,
    @location(2) barycentric: vec3<f32>,
};

struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) color: vec4<f32>,
    @location(1) barycentric: vec3<f32>,
};

@vertex
fn vertex(vertex: Vertex) -> VertexOutput {
    var out: VertexOutput;
    let model = get_model_matrix(vertex.instance_index);
    out.clip_position = mesh2d_position_local_to_clip(model, vec4<f32>(vertex.position, 1.0));
    out.color = vertex.color;
    out.barycentric = vertex.barycentric;
    return out;
}

struct FragmentInput {
    @location(0) color: vec4<f32>,
    @location(1) barycentric: vec3<f32>,
};

@fragment
fn fragment(input: FragmentInput) -> @location(0) vec4<f32> {
    let d = min(input.barycentric.x, min(input.barycentric.y, input.barycentric.z));
    let t = 0.05 * (0.85 + sin(5.0 * globals.time));
    return mix(vec4(1.0,1.0,1.0,1.0), input.color, smoothstep(t, t+0.01, d));
}

```

### assets/shaders/custom_vertex_attribute

```rust
#import bevy_pbr::mesh_functions::{get_model_matrix, mesh_position_local_to_clip}

struct CustomMaterial {
    color: vec4<f32>,
};
@group(2) @binding(0) var<uniform> material: CustomMaterial;

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

```

### assets/shaders/texture_binding_array

```rust
#import bevy_pbr::forward_io::VertexOutput

@group(2) @binding(0) var textures: binding_array<texture_2d<f32>>;
@group(2) @binding(1) var nearest_sampler: sampler;
// We can also have array of samplers
// var samplers: binding_array<sampler>;

@fragment
fn fragment(
    mesh: VertexOutput,
) -> @location(0) vec4<f32> {
    // Select the texture to sample from using non-uniform uv coordinates
    let coords = clamp(vec2<u32>(mesh.uv * 4.0), vec2<u32>(0u), vec2<u32>(3u));
    let index = coords.y * 4u + coords.x;
    let inner_uv = fract(mesh.uv * 4.0);
    return textureSample(textures[index], nearest_sampler, inner_uv);
}

```

### assets/shaders/circle_shader

```rust
// This shader draws a circle with a given input color
#import bevy_ui::ui_vertex_output::UiVertexOutput

struct CustomUiMaterial {
    @location(0) color: vec4<f32>
}

@group(1) @binding(0)
var<uniform> input: CustomUiMaterial;

@fragment
fn fragment(in: UiVertexOutput) -> @location(0) vec4<f32> {
    // the UVs are now adjusted around the middle of the rect.
    let uv = in.uv * 2.0 - 1.0;

    // circle alpha, the higher the power the harsher the falloff.
    let alpha = 1.0 - pow(sqrt(dot(uv, uv)), 100.0);

    return vec4<f32>(input.color.rgb, alpha);
}

```

### assets/shaders/tonemapping_test_patterns

```rust
#import bevy_pbr::{
    mesh_view_bindings,
    forward_io::VertexOutput,
    utils::PI,
}

#ifdef TONEMAP_IN_SHADER
#import bevy_core_pipeline::tonemapping::tone_mapping
#endif

// Sweep across hues on y axis with value from 0.0 to +15EV across x axis 
// quantized into 24 steps for both axis.
fn color_sweep(uv_input: vec2<f32>) -> vec3<f32> {
    var uv = uv_input;
    let steps = 24.0;
    uv.y = uv.y * (1.0 + 1.0 / steps);
    let ratio = 2.0;
    
    let h = PI * 2.0 * floor(1.0 + steps * uv.y) / steps;
    let L = floor(uv.x * steps * ratio) / (steps * ratio) - 0.5;
    
    var color = vec3(0.0);
    if uv.y < 1.0 { 
        color = cos(h + vec3(0.0, 1.0, 2.0) * PI * 2.0 / 3.0);
        let maxRGB = max(color.r, max(color.g, color.b));
        let minRGB = min(color.r, min(color.g, color.b));
        color = exp(15.0 * L) * (color - minRGB) / (maxRGB - minRGB);
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
    in: VertexOutput,
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
    color = tone_mapping(color, mesh_view_bindings::view.color_grading);
#endif
    return color;
}

```

### assets/shaders/custom_material_screenspace_texture

```rust
#import bevy_pbr::{
    mesh_view_bindings::view,
    forward_io::VertexOutput,
    utils::coords_to_viewport_uv,
}

@group(2) @binding(0) var texture: texture_2d<f32>;
@group(2) @binding(1) var texture_sampler: sampler;

@fragment
fn fragment(
    mesh: VertexOutput,
) -> @location(0) vec4<f32> {
    let viewport_uv = coords_to_viewport_uv(mesh.position.xy, view.viewport);
    let color = textureSample(texture, texture_sampler, viewport_uv);
    return color;
}

```

### assets/shaders/custom_material_2d

```rust
#import bevy_sprite::mesh2d_vertex_output::VertexOutput
// we can import items from shader modules in the assets folder with a quoted path
#import "shaders/custom_material_import.wgsl"::COLOR_MULTIPLIER

@group(2) @binding(0) var<uniform> material_color: vec4<f32>;
@group(2) @binding(1) var base_color_texture: texture_2d<f32>;
@group(2) @binding(2) var base_color_sampler: sampler;

@fragment
fn fragment(mesh: VertexOutput) -> @location(0) vec4<f32> {
    return material_color * textureSample(base_color_texture, base_color_sampler, mesh.uv) * COLOR_MULTIPLIER;
}

```

### assets/shaders/cubemap_unlit

```rust
#import bevy_pbr::forward_io::VertexOutput

#ifdef CUBEMAP_ARRAY
@group(2) @binding(0) var base_color_texture: texture_cube_array<f32>;
#else
@group(2) @binding(0) var base_color_texture: texture_cube<f32>;
#endif

@group(2) @binding(1) var base_color_sampler: sampler;

@fragment
fn fragment(
    mesh: VertexOutput,
) -> @location(0) vec4<f32> {
    let fragment_position_view_lh = mesh.world_position.xyz * vec3<f32>(1.0, 1.0, -1.0);
    return textureSample(
        base_color_texture,
        base_color_sampler,
        fragment_position_view_lh
    );
}

```

### assets/shaders/fallback_image_test

```rust
#import bevy_pbr::forward_io::VertexOutput

@group(2) @binding(0) var test_texture_1d: texture_1d<f32>;
@group(2) @binding(1) var test_texture_1d_sampler: sampler;

@group(2) @binding(2) var test_texture_2d: texture_2d<f32>;
@group(2) @binding(3) var test_texture_2d_sampler: sampler;

@group(2) @binding(4) var test_texture_2d_array: texture_2d_array<f32>;
@group(2) @binding(5) var test_texture_2d_array_sampler: sampler;

@group(2) @binding(6) var test_texture_cube: texture_cube<f32>;
@group(2) @binding(7) var test_texture_cube_sampler: sampler;

@group(2) @binding(8) var test_texture_cube_array: texture_cube_array<f32>;
@group(2) @binding(9) var test_texture_cube_array_sampler: sampler;

@group(2) @binding(10) var test_texture_3d: texture_3d<f32>;
@group(2) @binding(11) var test_texture_3d_sampler: sampler;

@fragment
fn fragment(in: VertexOutput) {}

```

### assets/shaders/custom_material

```rust
#import bevy_pbr::forward_io::VertexOutput
// we can import items from shader modules in the assets folder with a quoted path
#import "shaders/custom_material_import.wgsl"::COLOR_MULTIPLIER

@group(2) @binding(0) var<uniform> material_color: vec4<f32>;
@group(2) @binding(1) var material_color_texture: texture_2d<f32>;
@group(2) @binding(2) var material_color_sampler: sampler;

@fragment
fn fragment(
    mesh: VertexOutput,
) -> @location(0) vec4<f32> {
    return material_color * textureSample(material_color_texture, material_color_sampler, mesh.uv) * COLOR_MULTIPLIER;
}

```

### assets/shaders/array_texture

```rust
#import bevy_pbr::{
    forward_io::VertexOutput,
    mesh_view_bindings::view,
    pbr_types::{STANDARD_MATERIAL_FLAGS_DOUBLE_SIDED_BIT, PbrInput, pbr_input_new},
    pbr_functions as fns,
}
#import bevy_core_pipeline::tonemapping::tone_mapping

@group(2) @binding(0) var my_array_texture: texture_2d_array<f32>;
@group(2) @binding(1) var my_array_texture_sampler: sampler;

@fragment
fn fragment(
    @builtin(front_facing) is_front: bool,
    mesh: VertexOutput,
) -> @location(0) vec4<f32> {
    let layer = i32(mesh.world_position.x) & 0x3;

    // Prepare a 'processed' StandardMaterial by sampling all textures to resolve
    // the material members
    var pbr_input: PbrInput = pbr_input_new();

    pbr_input.material.base_color = textureSample(my_array_texture, my_array_texture_sampler, mesh.uv, layer);
#ifdef VERTEX_COLORS
    pbr_input.material.base_color = pbr_input.material.base_color * mesh.color;
#endif

    let double_sided = (pbr_input.material.flags & STANDARD_MATERIAL_FLAGS_DOUBLE_SIDED_BIT) != 0u;

    pbr_input.frag_coord = mesh.position;
    pbr_input.world_position = mesh.world_position;
    pbr_input.world_normal = fns::prepare_world_normal(
        mesh.world_normal,
        double_sided,
        is_front,
    );

    pbr_input.is_orthographic = view.projection[3].w == 1.0;

    pbr_input.N = fns::apply_normal_mapping(
        pbr_input.material.flags,
        mesh.world_normal,
        double_sided,
        is_front,
#ifdef VERTEX_TANGENTS
#ifdef STANDARD_MATERIAL_NORMAL_MAP
        mesh.world_tangent,
#endif
#endif
        mesh.uv,
        view.mip_bias,
    );
    pbr_input.V = fns::calculate_view(mesh.world_position, pbr_input.is_orthographic);

    return tone_mapping(fns::apply_pbr_lighting(pbr_input), view.color_grading);
}

```

### assets/shaders/show_prepass

```rust
#import bevy_pbr::{
    mesh_view_bindings::globals,
    prepass_utils,
    forward_io::VertexOutput,
}

struct ShowPrepassSettings {
    show_depth: u32,
    show_normals: u32,
    show_motion_vectors: u32,
    padding_1: u32,
    padding_2: u32,
}
@group(2) @binding(0) var<uniform> settings: ShowPrepassSettings;

@fragment
fn fragment(
#ifdef MULTISAMPLED
    @builtin(sample_index) sample_index: u32,
#endif
    mesh: VertexOutput,
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

```

### assets/shaders/irradiance_volume_voxel_visualization

```rust
#import bevy_pbr::forward_io::VertexOutput
#import bevy_pbr::irradiance_volume
#import bevy_pbr::mesh_view_bindings

struct VoxelVisualizationIrradianceVolumeInfo {
    transform: mat4x4<f32>,
    inverse_transform: mat4x4<f32>,
    resolution: vec3<u32>,
    // A scale factor that's applied to the diffuse and specular light from the
    // light probe. This is in units of cd/m² (candela per square meter).
    intensity: f32,
}

@group(2) @binding(100)
var<uniform> irradiance_volume_info: VoxelVisualizationIrradianceVolumeInfo;

@fragment
fn fragment(mesh: VertexOutput) -> @location(0) vec4<f32> {
    // Snap the world position we provide to `irradiance_volume_light()` to the
    // middle of the nearest texel.
    var unit_pos = (irradiance_volume_info.inverse_transform *
        vec4(mesh.world_position.xyz, 1.0f)).xyz;
    let resolution = vec3<f32>(irradiance_volume_info.resolution);
    let stp = clamp((unit_pos + 0.5) * resolution, vec3(0.5f), resolution - vec3(0.5f));
    let stp_rounded = round(stp - 0.5f) + 0.5f;
    let rounded_world_pos = (irradiance_volume_info.transform * vec4(stp_rounded, 1.0f)).xyz;

    // `irradiance_volume_light()` multiplies by intensity, so cancel it out.
    // If we take intensity into account, the cubes will be way too bright.
    let rgb = irradiance_volume::irradiance_volume_light(
        mesh.world_position.xyz,
        mesh.world_normal) / irradiance_volume_info.intensity;

    return vec4<f32>(rgb, 1.0f);
}

```

### assets/shaders/game_of_life

```rust
// The shader reads the previous frame's state from the `input` texture, and writes the new state of
// each pixel to the `output` texture. The textures are flipped each step to progress the
// simulation.
// Two textures are needed for the game of life as each pixel of step N depends on the state of its
// neighbors at step N-1.

@group(0) @binding(0) var input: texture_storage_2d<r32float, read>;

@group(0) @binding(1) var output: texture_storage_2d<r32float, write>;

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

fn randomFloat(value: u32) -> f32 {
    return f32(hash(value)) / 4294967295.0;
}

@compute @workgroup_size(8, 8, 1)
fn init(@builtin(global_invocation_id) invocation_id: vec3<u32>, @builtin(num_workgroups) num_workgroups: vec3<u32>) {
    let location = vec2<i32>(i32(invocation_id.x), i32(invocation_id.y));

    let randomNumber = randomFloat(invocation_id.y << 16u | invocation_id.x);
    let alive = randomNumber > 0.9;
    let color = vec4<f32>(f32(alive));

    textureStore(output, location, color);
}

fn is_alive(location: vec2<i32>, offset_x: i32, offset_y: i32) -> i32 {
    let value: vec4<f32> = textureLoad(input, location + vec2<i32>(offset_x, offset_y));
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

    textureStore(output, location, color);
}

```

### assets/shaders/animate_shader

```rust
// The time since startup data is in the globals binding which is part of the mesh_view_bindings import
#import bevy_pbr::{
    mesh_view_bindings::globals,
    forward_io::VertexOutput,
}

fn oklab_to_linear_srgb(c: vec3<f32>) -> vec3<f32> {
    let L = c.x;
    let a = c.y;
    let b = c.z;

    let l_ = L + 0.3963377774 * a + 0.2158037573 * b;
    let m_ = L - 0.1055613458 * a - 0.0638541728 * b;
    let s_ = L - 0.0894841775 * a - 1.2914855480 * b;

    let l = l_ * l_ * l_;
    let m = m_ * m_ * m_;
    let s = s_ * s_ * s_;

    return vec3<f32>(
        4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
        -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
        -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s,
    );
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let speed = 2.0;
    // The globals binding contains various global values like time
    // which is the time since startup in seconds
    let t_1 = sin(globals.time * speed) * 0.5 + 0.5;
    let t_2 = cos(globals.time * speed);

    let distance_to_center = distance(in.uv, vec2<f32>(0.5)) * 1.4;

    // blending is done in a perceptual color space: https://bottosson.github.io/posts/oklab/
    let red = vec3<f32>(0.627955, 0.224863, 0.125846);
    let green = vec3<f32>(0.86644, -0.233887, 0.179498);
    let blue = vec3<f32>(0.701674, 0.274566, -0.169156);
    let white = vec3<f32>(1.0, 0.0, 0.0);
    let mixed = mix(mix(red, blue, t_1), mix(green, white, t_2), distance_to_center);

    return vec4<f32>(oklab_to_linear_srgb(mixed), 1.0);
}

```

### assets/shaders/post_processing

```rust
// This shader computes the chromatic aberration effect

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
#import bevy_core_pipeline::fullscreen_vertex_shader::FullscreenVertexOutput

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
        textureSample(screen_texture, texture_sampler, in.uv + vec2<f32>(offset_strength, -offset_strength)).r,
        textureSample(screen_texture, texture_sampler, in.uv + vec2<f32>(-offset_strength, 0.0)).g,
        textureSample(screen_texture, texture_sampler, in.uv + vec2<f32>(0.0, offset_strength)).b,
        1.0
    );
}


```
