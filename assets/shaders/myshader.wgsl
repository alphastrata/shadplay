// The time since startup data is in the globals binding which is part of the mesh_view_bindings import
#import bevy_pbr::mesh_view_bindings globals
#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_pbr::utils PI
#import bevy_pbr::utils
// #import shadplay::myshadertools rgb2hsb
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
    // var uv = ((in.uv.xy) * 2.0) - 1.0; // Make the center of our shape 0.5,0.5
    // let center = length(uv);
    // return vec4<f32>(palette(center), 1.0);

    return kishimisu(in);
}


// This is a port/cover of Kimishisu's awesome YT tutotial: https://www.youtube.com/watch?v=f4s1h2YETNY
fn kishimisu(in: MeshVertexOutput) -> vec4<f32> {
    let uv0 = ((in.uv.xy) * 2.0) - 1.0;

    // var uv = ((in.uv.xy) * 2.0) - 1.0; // Make the center of our shape 0.5,0.5
    var uv = (in.uv.xy) ; // Make the center of our shape 0.5,0.5

    var output = vec3(0.0);

    for (var i = 0.0; i < 2.0; i += 1.0) {
        uv = fract((uv * 8.2)) - 0.5;

        var d = length(uv) * exp(-length(uv0));

        var col = palette(length(uv0) + (i * 4.3) + (globals.time * .4));

        d = sin(d * 8. + globals.time) / 8.;
        d = abs(d);

        d = pow(0.01 / d, 1.2);

        output += col * d;
    }

    return vec4<f32>(output, 1.0);
}


fn palette(t: f32) -> vec3<f32> {
    var a: vec3<f32>= vec3<f32>(0.5, 0.5, 0.5);
    var b: vec3<f32>= vec3<f32>(0.5, 0.5, 0.5);
    var c: vec3<f32>= vec3<f32>(1.0, 1.0, 1.0);
    var d: vec3<f32>= vec3<f32>(0.263, 0.416, 0.557);

    return a + b * cos(6.28318 * (c * t + d));
}


// struct MeshVertexOutput {
//     // this is `clip position` when the struct is used as a vertex stage output 
//     // and `frag coord` when used as a fragment stage input
//     @builtin(position) position: vec4<f32>,
//     @location(0) world_position: vec4<f32>,
//     @location(1) world_normal: vec3<f32>,
//     #ifdef VERTEX_UVS
//     @location(2) uv: vec2<f32>,
//     #endif
//     #ifdef VERTEX_TANGENTS
//     @location(3) world_tangent: vec4<f32>,
//     #endif
//     #ifdef VERTEX_COLORS
//     @location(4) color: vec4<f32>,
//     #endif
// }



// fn kishimisu(in: MeshVertexOutput) -> vec4<f32> {
//     // fn fragment_main(fragCoord,: vec2<i32>, iResolution: vec3<f32>, iTime: f32) -> [[location(0)]] vec4<f32>{
//     var uv: vec2<f32> = (f32(fragCoord) * 2.0 - vec2<f32>(iResolution.xy)) / iResolution.y;
//     var uv0: vec2<f32> = uv;
//     var finalColor: vec3<f32> = vec3<f32>(0.0);

//     for (var i: f32 = 0.0; i < 4.0; i = i + 1.0) {
//         uv = fract(uv * 1.5) - vec2<f32>(0.5);

//         var d: f32 = length(uv) * exp(-length(uv0));

//         var col: vec3<f32> = palette(length(uv0) + i * 0.4 + iTime * 0.4);

//         d = sin(d * 8.0 + iTime) / 8.0;
//         d = abs(d);

//         d = pow(0.01 / d, 1.2);

//         finalColor = finalColor + col * d;
//     }

//     return vec4<f32>(finalColor, 1.0);
// }


// Some nice colours:
    // var pastelRed: vec4<f32> = vec4<f32>(0.937, 0.502, 0.502, 1.0);
    // var pastelGreen: vec4<f32> = vec4<f32>(0.502, 0.937, 0.502, 1.0);
    // var pastelBlue: vec4<f32> = vec4<f32>(0.502, 0.694, 0.937, 1.0);
    // var pastelYellow: vec4<f32> = vec4<f32>(0.937, 0.937, 0.502, 1.0);
    // var pastelOrange: vec4<f32> = vec4<f32>(0.937, 0.718, 0.502, 1.0);
    // var pastelPurple: vec4<f32> = vec4<f32>(0.753, 0.502, 0.937, 1.0);
    // var pastelPink: vec4<f32> = vec4<f32>(0.937, 0.753, 0.843, 1.0);
    // var pastelBrown: vec4<f32> = vec4<f32>(0.718, 0.580, 0.580, 1.0);
    // var pastelBlack: vec4<f32> = vec4<f32>(0.502, 0.502, 0.502, 1.0);
    // var pastelWhite: vec4<f32> = vec4<f32>(0.937, 0.937, 0.937, 1.0);
    // var pastelGray: vec4<f32> = vec4<f32>(0.753, 0.753, 0.753, 1.0);
    // var pastelCyan: vec4<f32> = vec4<f32>(0.502, 0.937, 0.937, 1.0);
    // var pastelTeal: vec4<f32> = vec4<f32>(0.502, 0.937, 0.753, 1.0);
//     let screen_width = view.viewport.z;
//     let screen_height = view.viewport.w;
//     let resolution = view.viewport.zw;

// // World positions, these are absolute.
//     let wx = in.world_position.x ;
//     let wy = in.world_position.y ;
//     let wz = in.world_position.z ;

// // World normals these are absolute.
//     let wnx = in.world_normal.x;
//     let wny = in.world_normal.y;
//     let wnz = in.world_normal.z;

// // Clip positions, basically useless for our purposes atm...
//     let px = in.position.x;
//     let py = in.position.y;
//     let pz = in.position.z;

// // Mesh which is:     @location(2) uv: vec2<f32>, this location is local to the mesh's x,y
//     var uv = (in.uv * 2.0) - 1.0;
//     // uv.x = screen_width / screen_height; // Normalise the UVs so that we can think of our mesh as 0..1 between extremes (note ours is missing the resolution tho...)
//     // let uv = in.uv / (resolution / 1000.);
//     let mx = uv.x;
//     let my = uv.y;


// Drawing a circle:
    // var d: f32 = length(uv);
    // d -= 0.5; // Make 'd' signed distance
    // d = abs(d); // hollow out the circle, by converting negative values into poisitve ones
    // d = step(0.01, d); // sharpen the cutoff 
    // d = smoothstep(0.0, 0.1, d); // or, blend it


