#import bevy_pbr::mesh_view_bindings globals view
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_pbr::utils PI HALF_PI
#import bevy_pbr::mesh_functions 


@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {

    let t = globals.time;
    var uv = in.uv - 0.5; // Shift UV coordinates to make the center of each 'face', if we don't do this, x=0, y=0 is in the bottom-left of the faces of our cube.

    var col = vec3(0.);

    uv *= 2.5659 - sin(t); // Scale UV coordinates for the desired shape size

    // Create an SDF shape:
    let d = sd_octogon(uv, 18.5); // What this really is is a distance from the 'in.uv - 0.5' we slap into 'uv' above.

    // Calculate a step based on the signed distance value
    let st = smoothstep(0.0, 0.05, abs(d)); // try removing the abs (absolute makes negative numbers positive, and positive numbers going in will be as they were.)
    col = vec3<f32>(st);

    // Check if the signed distance value is positive (outside) or negative (inside),
    // note whilst we use an absolute value inside the smoothstep, we utilise the fact the distance may be negative here.
    if (d > 0.0) {
      col *= palette(0.007 );  
    } else {
      // Shading for points inside the shape
      col *= palette(0.4987 * d * t/133.456); 
    }

    // Return the final color to shade each xy coordinate
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

// This number is from munrocket
fn sd_octogon(p: vec2<f32>, r: f32) -> f32 {
  let k = vec3<f32>(-0.9238795325, 0.3826834323, 0.4142135623);
  var q: vec2<f32> = abs(p);
  q = q - 2. * min(dot(vec2<f32>(k.x, k.y), q), 0.) * vec2<f32>(k.x, k.y);
  q = q - 2. * min(dot(vec2<f32>(-k.x, k.y), q), 0.) * vec2<f32>(-k.x, k.y);
  q = q - vec2<f32>(clamp(q.x, -k.z * r, k.z * r), r);
  return length(q) * sign(q.y);
}