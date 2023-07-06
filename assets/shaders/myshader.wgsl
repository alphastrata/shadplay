// The time since startup data is in the globals binding which is part of the mesh_view_bindings import
// #import shadplay::myshadertools rgb2hsb
#import bevy_pbr::mesh_view_bindings globals
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_pbr::utils PI
#import bevy_pbr::utils
#import bevy_core_pipeline::fullscreen_vertex_shader FullscreenVertexOutput
#import bevy_render::view View

// Notice how this EXACTLY matches the YourShader declared in main? This is how you Get data INTO a shader.
struct MyShaderColor {
    color: vec4<f32>,
};

@group(0) @binding(0)
var<uniform> view: View;

@group(1) @binding(0)
var<uniform> material: MyShaderColor;

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    // Kishimisu:
    return kishimisu(in);
}

// This is a port/cover of Kimishisu's awesome YT tutotial: https://www.youtube.com/watch?v=f4s1h2YETNY
fn kishimisu(in: MeshVertexOutput) -> vec4<f32> {
    let uv0 = ((in.uv.xy) * 2.0) - 1.0;
    var uv = (in.uv.xy) ;

    var output = vec3(0.0);

    for (var i = 0.0; i < 1.0; i += 1.0) {
        uv = fract((uv * .0982)) - 1.225;

        var d = length(uv) * exp(-length(uv0));

        var col = palette(length(uv0) + (i * 4.3) + (globals.time * .4));

        d = sin(d * 8. + globals.time) / 4.;
        d = abs(d);

        d = pow(0.01 / d, 1.8);

        output += col * d;
    }

    return vec4<f32>(output, 1.0);
}
fn palette(t: f32) -> vec3<f32> {
    let a = vec3<f32>(0.5, 0.5, 0.5);
    let b = vec3<f32>(0.5, 0.5, 0.5);
    let c = vec3<f32>(1.0, 1.0, 1.0);
    let d = vec3<f32>(0.263, 0.416, 0.557);

    return a + b * cos(6.28318 * (c * t + d));
}
