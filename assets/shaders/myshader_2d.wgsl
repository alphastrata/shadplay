#import bevy_core_pipeline::tonemapping   tone_mapping
#import bevy_pbr::mesh_vertex_output      MeshVertexOutput
#import bevy_pbr::pbr_functions as        fns
#import bevy_pbr::pbr_types               STANDARD_MATERIAL_FLAGS_DOUBLE_SIDED_BIT
#import bevy_pbr::utils                   PI
#import bevy_sprite::mesh2d_view_bindings globals 
#import shadplay::shader_utils::common    rotate2D

#import bevy_render::view  View
@group(0) @binding(0) var<uniform> view: View;


@group(1) @binding(0) var my_array_texture: texture_2d<f32>;
@group(1) @binding(1) var my_array_texture_sampler: sampler;

const SPEED:f32 = 0.25;
const CAM_DISTANCE: f32 = -2.;


// Porting https://www.shadertoy.com/view/tsBXW3 by set111:https://www.shadertoy.com/user/set111
@fragment
fn fragment(
    @builtin(front_facing) is_front: bool,
    in: MeshVertexOutput
) -> @location(0) vec4<f32> {
    let t = globals.time * SPEED;
    let resolution = view.viewport.zw;

    var texture_uvs = in.uv;
    texture_uvs *= rotate2D(1.0+t);

    let tex:vec4f = textureSample(my_array_texture, my_array_texture_sampler, texture_uvs); // Shadertoy's ones don't seem to be affected by uvs modified in the scope of the functions that folk are writing so we take the uvs early do get around that.
    
    var uv = (in.uv * 2.0) - 1.0;
    uv.x *= resolution.x / resolution.y;
    uv *= rotate2D(PI / -2.0);
    var col = vec3f(0.0);
    // col.b = value_noise(uv, t); // Test the noise!

    let ro = vec3f(0.0);
    let bg = background(ro, tex);

    let fragColor = vec4<f32>(col, 1.0);




    return bg;
    
}


fn background(ray: vec3f, texture: vec4f) -> vec4f {
    var uv = ray.xy;
    if abs(ray.x) > 0.5 {
        uv.x = ray.z;
    } else if abs(ray.y) > 0.5 {
        uv.y = ray.z;
    }


    //
    var brightness = value_noise(uv * 3.0, 100.); // (dodgy stars), according to the comments in shadertoy
    var colour = value_noise(uv * 2.0, 20.); // why 20.?
    brightness = pow(brightness, 256.0); // why 256? const?
    brightness = brightness * 100.0; // *= 100.0 ??
    brightness = clamp(brightness, 0.0, 1.0);  // does what?


    var stars: vec3f = brightness * mix(vec3f(1.0, 0.6, 0.2), vec3f(0.2, 0.6, 1.0), colour); // what happens when you mess with these vec3's values?

    // var nebulae = textuxe(iChannel10, (uv*1.5)); // We have no textures so... have a think on that one.. (the shadertoy kid is using a galazy img.)
    var nebulae = texture.xyz;
    let nebulae_alpha = texture.a; // Keep this as we cannot swizzle with it
    nebulae += (nebulae.xxx + nebulae.yyy + nebulae.zzz);
    nebulae *= 0.25;

    nebulae *= nebulae;
    nebulae *= nebulae;
    nebulae *= nebulae;
    nebulae *= nebulae; // Yep.. they do it 4 times.


    nebulae += stars;


    return vec4f(nebulae, 1.0);
}

// Creates a pretty even noise (I have no idea how...)
fn value_noise(p: vec2f, f: f32) -> f32 {
    let b1: f32 = hash21(floor(p * f + vec2(0.0, 0.)));
    let br: f32 = hash21(floor(p * f + vec2(1.0, 0.)));
    let t1: f32 = hash21(floor(p * f + vec2(0.0, 1.)));
    let tr: f32 = hash21(floor(p * f + vec2(1.0, 1.)));

    var fr = fract(p * f);
    fr = (3.0 - 2.0 * fr) * fr * fr;
    let b = mix(b1, br, fr.x);
    let t = mix(t1, tr, fr.x);

    return mix(b, t, fr.y);
}

// Hash 2 into 1
fn hash21(x: vec2f) -> f32 {
    return (hash(x.x + hash(x.y)));
}
// Hash 1 into 1
fn hash(x: f32) -> f32 {
    return fract(sin(x) * 152754.742);
}
