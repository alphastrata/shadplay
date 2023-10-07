#define_import_path bevy_pbr::shadbang

// This is a port of the default shader you get from in www.shadertoy.com/new
fn shadertoy_default(uv: vec2<f32>)->vec4<f32>{
    var uv = uv;
    let t = globals.time;
    uv *= 3.1459;
    
    let temp: vec3<f32> = uv.xyx + vec3<f32>(0.0, 2.0, 4.0);
    let cos_val: vec3<f32> = cos(globals.time + temp);
    let col: vec3<f32> = vec3<f32>(0.5) + vec3<f32>(0.5) * cos_val;

    return vec4<f32>(col, 1.0);
}   
