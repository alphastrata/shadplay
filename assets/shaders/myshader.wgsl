#import bevy_pbr::mesh_view_bindings globals view
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_pbr::utils PI HALF_PI
#import bevy_pbr::mesh_functions 


@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {

    let t = globals.time;
    var uv = in.uv - 0.5; // this is how you make the center of each 'face' on our cube (for example) 
    var col = vec3(0.);
    uv *= 10.0;
    

    // Create an sdf shape:
    let d = sdOctogon(uv, 3.5);

    // docs pls chatgpt
    let gradient = smoothstep(0.0, 0.05, abs(d)); // Adjust the thresholds as needed

    
    // docs pls chatgpt
    col = vec3<f32>(gradient);
   

    // finally we return the Colour we want to shade each xy cooard with;
    return vec4<f32>(col, 1.0);


    
}


fn sdOctogon(p: vec2<f32>, r: f32) -> f32 {
  let k = vec3<f32>(-0.9238795325, 0.3826834323, 0.4142135623);
  var q: vec2<f32> = abs(p);
  q = q - 2. * min(dot(vec2<f32>(k.x, k.y), q), 0.) * vec2<f32>(k.x, k.y);
  q = q - 2. * min(dot(vec2<f32>(-k.x, k.y), q), 0.) * vec2<f32>(-k.x, k.y);
  q = q - vec2<f32>(clamp(q.x, -k.z * r, k.z * r), r);
  return length(q) * sign(q.y);
}