#import bevy_pbr::mesh_view_bindings globals view
#import bevy_pbr::forward_io::VertexOutput
#import bevy_pbr::utils PI HALF_PI
#import bevy_pbr::mesh_functions 

const GRID_RATIO:f32 = 40.;


@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let t = globals.time;

    var uv = in.uv - 0.5;
    uv *=  GRID_RATIO / 5.;
    var col = vec3(0.0);

    let grid = grid(uv);

    let pal = palette(t / 20.);
    col = mix(col, pal, grid);
   
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

// inspired by https://www.shadertoy.com/view/Wt33Wf & https://www.shadertoy.com/view/XtBfzz
fn grid(uv: vec2<f32>)-> f32 {
    let i = step(fract(uv), vec2(1.0/GRID_RATIO));
    return (1.0-i.x) * (1.0-i.y);
    
}


// License: WTFPL, author: sam hocevar, found: https://stackoverflow.com/a/17897228/418488
fn hsv2rgb(c: vec3<f32>) -> vec3<f32> {
    let K: vec4<f32> = vec4<f32>(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    var p: vec3<f32> = abs(fract(vec3<f32>(c.x) + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, vec3<f32>(0.0), vec3<f32>(1.0)), c.y);
}
