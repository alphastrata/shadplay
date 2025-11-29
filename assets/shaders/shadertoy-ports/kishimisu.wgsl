#import bevy_sprite::mesh2d_vertex_output::VertexOutput
#import bevy_sprite::mesh2d_view_bindings::globals 

#import bevy_render::view  View
@group(0) @binding(0) var<uniform> view: View;


@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    return kishimisu(in);
}

// This is a port/cover of Kimishisu's awesome YT tutotial: https://www.youtube.com/watch?v=f4s1h2YETNY
fn kishimisu(in: VertexOutput) -> vec4<f32> {
    let resolution = view.viewport.zw;
    var finalColor = vec3<f32>(0.0);

    var uv = (in.uv.xy * 2.0) - 1.0;
    uv.x *= resolution.x / resolution.y;
    let uv0 = uv;

    for (var i = 0.0; i < 4.0; i += 1.0){
        var col = palette(length(uv0) + i * 0.4 + globals.time * 0.4);

        uv = fract(uv * 1.5) - 0.5;

        var d = length(uv) * exp(-length(uv0));
        d = sin(d * 8. + globals.time) / 8.;
        d = abs(d);
        d = pow(0.02 / d, 4.0);

        finalColor += col * d;
    }

    return vec4<f32>(finalColor, 1.0);
}

fn palette(t: f32) -> vec3<f32> {
    let a = vec3<f32>(0.5, 0.5, 0.5);
    let b = vec3<f32>(0.5, 0.5, 0.5);
    let c = vec3<f32>(1.0, 1.0, 1.0);
    let d = vec3<f32>(0.263, 0.416, 0.557);

    return a + b * cos(6.28318 * (c * t + d));
}
