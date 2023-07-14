#import bevy_pbr::mesh_view_bindings globals view
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_pbr::utils PI HALF_PI
#import bevy_pbr::mesh_functions 


@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    let t = globals.time;
    var uv = in.uv - 0.5; 
    var col = vec3(0.0);
    uv *= 8.0;

    // Apply rotation to UV coordinates
    let angle = -t * 0.80; 
    let rotation = mat2x2(cos(angle), -sin(angle), sin(angle), cos(angle));
    uv = rotation * uv;

    var d = sdStar(uv, 2.0, 8, 5.0);
    let st = smoothstep(0.0, 0.05, abs(d)); 
    col = vec3<f32>(st);

    if (d > 0.0) {
      col *= palette(0.037);  
    } else {
      col *= palette(0.497);
    }

    d = 0.1 / d;
    col *= d * cos(t);

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

// courtesy of : https://gist.github.com/munrocket/30e645d584b5300ee69295e54674b3e4
fn sdStar(p: vec2<f32>, r: f32, n: i32, m: f32) -> f32 {
  let an = 3.141593 / f32(n);
  let en = 3.141593 / m;

  let acs = vec2<f32>(cos(an), sin(an));
  let ecs = vec2<f32>(cos(en), sin(en));

  let bn = (atan2(abs(p.x), p.y) % (2. * an)) - an;
  var q: vec2<f32> = length(p) * vec2<f32>(cos(bn), abs(sin(bn)));

  q = q - r * acs;
  q = q + ecs * clamp(-dot(q, ecs), 0., r * acs.y / ecs.y);

  return length(q) * sign(q.x);
}

// License: WTFPL, author: sam hocevar, found: https://stackoverflow.com/a/17897228/418488
fn hsv2rgb(c: vec3<f32>) -> vec3<f32> {
    let K: vec4<f32> = vec4<f32>(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    var p: vec3<f32> = abs(fract(vec3<f32>(c.x) + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, vec3<f32>(0.0), vec3<f32>(1.0)), c.y);
}
