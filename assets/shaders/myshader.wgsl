#import bevy_pbr::mesh_view_bindings globals view
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_pbr::utils PI HALF_PI
#import bevy_pbr::mesh_functions 


@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    let t = globals.time;

    // let uv0 = ((in.uv.xy) * 2.0) - 1.0;
    // var uv = in.uv *2.0 - 1.0; 
    var uv = in.uv - 0.5;
    var col = vec3(0.0);

    uv *= 3.;

    let battery = 1.0;
    let grid = grid(uv, battery);

    uv.y *= abs(uv.x + 0.2)  + 0.05;
    col = mix(col, vec3(1.0, 0.5, 1.0), grid);
   
    return vec4<f32>(col, 1.0);
}

// I disklike boring colours, this paticular function comes from Kishimisu (see the wgsl file of same name to explore more of her/his/their ideas.)
fn palette(t: f32) -> vec3<f32> {
    let a = vec3<f32>(0.5, 0.5, 0.5);
    let b = vec3<f32>(0.5, 0.5, 0.5);
    let c = vec3<f32>(1.0, 1.0, 1.0);
    let d = vec3<f32>(0.263, 0.416, 0.557);

    return a + b * cos(6.28318 * (c * t + d));
}

// inspired by https://www.shadertoy.com/view/Wt33Wf
fn grid(uv: vec2<f32>, battery: f32)-> f32{

    let t = globals.time;
    var uv = uv;

    let size = vec2(uv.y, uv.y * uv.y * 0.2)*0.01;

    uv += vec2(0.0, t *4.0 * (battery + 0.05));
    uv = abs(fract(uv) - 0.5);

    var lines:vec2<f32> = smoothstep(size *5.0, vec2(0.0), uv);
    lines += smoothstep(size *5.0, vec2(0.), uv) * 0.4 * battery;

    return clamp(lines.x + lines.y, 0.0, 3.0);
   
}


// License: WTFPL, author: sam hocevar, found: https://stackoverflow.com/a/17897228/418488
fn hsv2rgb(c: vec3<f32>) -> vec3<f32> {
    let K: vec4<f32> = vec4<f32>(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    var p: vec3<f32> = abs(fract(vec3<f32>(c.x) + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, vec3<f32>(0.0), vec3<f32>(1.0)), c.y);
}
