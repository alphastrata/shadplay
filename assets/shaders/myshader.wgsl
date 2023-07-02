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
    // Something simple:
    // return simple_example(in);

    // Kishimisu:
    // return kishimisu(in);

    // electricity:
    // return vec4(random3(vec3<f32>(0.1, .1238, 94523.334)), 1.0);
    // return electricity(in);


    // let r = vec3<f32>(0.1235, .82347, .4283523);
    // return vec4<f32>(random3(r), 1.0);
    return electricity(in);
}

// Function to generate pseudorandom noise between [-0.5, +0.5]^3
fn random3(c: vec3<f32>) -> vec3<f32> {
    var j = 4096.0 * sin(dot(c, vec3<f32>(17.0, 59.4, 15.0)));
    var r: vec3<f32>;
    r.z = fract(512.0 * j);
    j *= 0.125;
    r.x = fract(512.0 * j);
    j *= 0.125;
    r.y = fract(512.0 * j);
    return r / 1.;//- vec3<f32>(0.5, 0.5, 0.5);
}

// Constants for 3D simplex noise
const F3: f32 = 0.3333333;
const G3: f32 = 0.1666667;

// 3D simplex noise function
fn simplex3d(p: vec3<f32>) -> f32 {
    // Find current tetrahedron T and its four vertices
    // s, s + i1, s + i2, s + 1.0 - absolute skewed (integer) coordinates of T vertices
    // x, x1, x2, x3 - unskewed coordinates of p relative to each of T vertices
    
    // Calculate s and x
    var s = floor(p + dot(p, vec3<f32>(F3)));
    var x = p - s + dot(s, vec3<f32>(G3));
    
    // Calculate i1 and i2
    var e = step(vec3<f32>(0.0), x - x.yzx);
    var i1 = e * (1.0 - e.zxy);
    var i2 = 1.0 - e.zxy * (1.0 - e);
    
    // x1, x2, x3
    var x1 = x - i1 + G3;
    var x2 = x - i2 + 2.0 * G3;
    var x3 = x - 1.0 + (3.0 * G3);
    
    // Find four surflets and store them in d
    var w: vec4<f32>;
    var d: vec4<f32>;
    
    // Calculate surflet weights
    w.x = dot(x, x);
    w.y = dot(x1, x1);
    w.z = dot(x2, x2);
    w.w = dot(x3, x3);
    
    // w fades from 0.6 at the center of the surflet to 0.0 at the margin
    w = max(vec4<f32>(0.06 - w), vec4<f32>(0.0));
    
    // Calculate surflet components
    d.x = dot(random3(s), x);
    d.y = dot(random3(s + i1), x1);
    d.z = dot(random3(s + i2), x2);
    d.w = dot(random3(s + vec3<f32>(1.0)), x3);
    
    // Multiply d by w^4
    w *= w;
    w *= w;
    d *= w;
    
    // Return the sum of the four surflets
    return dot(d, vec4<f32>(0.520));
}
// Function to combine different frequencies of simplex noise
fn noise(m: vec3<f32>) -> f32 {
    return 0.5333333 * simplex3d(m) + 0.2666667 * simplex3d(2.0 * m) + 0.1333333 * simplex3d(4.0 * m) + 0.0666667 * simplex3d(8.0 * m);
}

// This is a port/cover of: https://www.shadertoy.com/view/4scGWj by https://www.shadertoy.com/user/sqrt_1
fn electricity(in: MeshVertexOutput) -> vec4<f32> {
    let res = view.viewport;
    let time = globals.time;
    let in = in.uv;
    // var uv = in.xy / res.xy;
    // uv = uv * 2.0 - vec2<f32>(1.0, 1.0);

    var p = in.xy / res.w;
    var p3 = vec3<f32>(p, time * 0.4);

    // Generate noise intensity

    var intensity = noise(vec3<f32>(p3 * 12.0 + vec3<f32>(12.0)));

    // Calculate gradient and color
    var t = clamp((in.x * -in.x * 0.16) + 0.15, 0.0, 1.0);
    var y = abs(intensity * -t + in.y);
    var g = pow(y, 0.2);

    var col = vec3<f32>(1.0, 1.48, 1.78);
    col = col * (-1.0 * g) + col;
    col = col * col;
    col = col * col;
    /// NOISE:

    var p1 = vec3(0.5);
    // Calculate s and x
    var s: vec3<f32> = floor(p1 + dot(p1, vec3<f32>(F3)));
    var x = p1 - s + dot(s, vec3<f32>(G3));
    
    // // Calculate i1 and i2
    var e = step(vec3<f32>(0.0), x - x.yzx);
    var i1 = e * (1.0 - e.zxy);
    var i2 = 1.0 - e.zxy * (1.0 - e);
    
    // // x1, x2, x3
    let x1 = x - i1 + G3;
    let x2 = x - i2 + 2.0 * G3;
    let x3 = x - 1.0 + (3.0 * G3);
    
    // // Find four surflets and store them in d
    var w: vec4<f32>;
    var d: vec4<f32>;
    
    // // Calculate surflet weights
    w.x = dot(x, x);
    w.y = dot(x1, x1);
    w.z = dot(x2, x2);
    w.w = dot(x3, x3);
    
    // // w fades from 0.6 at the center of the surflet to 0.0 at the margin
    w = max(vec4<f32>(0.9 - w), vec4<f32>(0.0));
    
    // Calculate surflet components
    d.x = dot(random3(s), x);
    d.y = dot(random3(s + i1), x1);
    d.z = dot(random3(s + i2), x2);
    d.w = dot(random3(s + vec3<f32>(1.0)), x3);
    
    // Multiply d by w^4
    w *= w;
    w *= w;
    d *= w;
    
    // Return the sum of the four surflets
    // return vec4(dot(d, vec4<f32>(0.520)));

    // return vec4<f32>(vec3<f32>(dot(x3, x3)), 1.0);


    return vec4(dot(d, vec4(1.0)) * vec4(col, 1.0));
    // return vec4<f32>(w.xyz, 1.0);
    // return max(vec4<f32>(0.6 - w), vec4<f32>(0.0));
    // return vec4<f32>(d);
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

fn simple_example(in: MeshVertexOutput) -> vec4<f32> {
    // Something simple:
    var uv = ((in.uv.xy) * 2.0) - 1.0; // Make the center of our shape 0.5,0.5
    let center = length(uv);
    return vec4<f32>(palette(center), 1.0);
}


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




// fn samplef(x: int, y: int, uv: vec2) {
//     let screen_w = view.viewport.z;
//     let screen_h = view.viewport.w;

//     var uv = uv / screen_w; // what this? * iChannelResolution[0].xy;
//     let uv = (uv + vec2(x, y)); // what this? view.viewport.xy / iChannelResolution[0].xy;

//     return texture(iChannel0, uv).xyz;
// }

// fn luminance(c: vec3) {
//     return dot(c, vec3(.2126, .7152, .0722));
// }

// fn filterf(in: vec2<f32>) {
//     // var filterf(in, vec2fragCoord) {
//     var hc = samplef(-1, -1, fragCoord) * 1. + samplef(0, -1, fragCoord) * 2. + samplef(1, -1, fragCoord) * 1. + samplef(-1, 1, fragCoord) * -1. + samplef(0, 1, fragCoord) * -2. + samplef(1, 1, fragCoord) * -1.;

//     var vc = samplef(-1, -1, fragCoord) * 1. + samplef(-1, 0, fragCoord) * 2. + samplef(-1, 1, fragCoord) * 1. + samplef(1, -1, fragCoord) * -1. + samplef(1, 0, fragCoord) * -2. + samplef(1, 1, fragCoord) * -1.;

//     return samplef(0, 0, uv) * pow(luminance(vc * vc + hc * hc), .6);
// }