//! This is a shadertoy port of 'polar-coordinates-experiments' by toridango https://www.shadertoy.com/view/ttsGz8
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_pbr::utils PI
#import bevy_sprite::mesh2d_view_bindings globals 


@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    var uv = (in.uv * 2.0) - 1.0;

    // Polar coordinates 
    let pol: vec2<f32> = vec2<f32>(atan2(uv.y, uv.x), length(uv));
    let col: vec3<f32> = vec3<f32>(globals.time + sin(pol.y), cos(pol.y), sin(2.0 * globals.time + pol.x * globals.time * -0.015) / 1.9);
    
    let adjusted_pol: vec2<f32> = vec2<f32>(pol.x / 5.24 - 0.1 * globals.time + pol.y, pol.y);
    let m: f32 = min(fract(adjusted_pol.x * 5.0), fract(1.0 - adjusted_pol.x * 5.0));
    
    let f: f32 = smoothstep(0.0, 0.1, m * 0.3 + 0.2 - adjusted_pol.y);
    
    return vec4<f32>(f * col, f);    
}
        
