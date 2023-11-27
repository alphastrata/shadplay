/// ***************************** ///
/// This is a port fo the FBM quick example in the little book of shaders: Author @patriciogv - 2015 http://patriciogonzalezvivo.com
/// Ours looks a lot like theirs at sufficently small resolutions, but to dream a little larger there's a custom gussianBlur added.
/// ***************************** ///

#import bevy_sprite::mesh2d_view_bindings::globals 
#import shadplay::shader_utils::common::{NEG_HALF_PI, shader_toy_default, rotate2D, TWO_PI}
#import bevy_render::view::View
#import bevy_pbr::forward_io::VertexOutput;

@group(0) @binding(0) var<uniform> view: View;

const SPEED:f32 = 1.0;
const NUM_OCTAVES: i32 = 8;

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    var uv = in.uv;
    let resolution = view.viewport.zw;
    let time = globals.time * SPEED;
    uv *= rotate2D(NEG_HALF_PI);


	// Slapping in a gaussian blur:
    // let blurRadius: f32 = 1.0; // Adjust the radius to control the blur amount, maybe don't go too HIGH! 
    // var blurredColor: vec4<f32> = vec4(0.0, 0.0, 0.0, 0.0);
    // var totalWeight: f32 = 0.0;
    // let intRadius: i32 = i32(blurRadius);

    // for (var x: i32 = -intRadius; x <= intRadius; x++) {
    //     for (var y: i32 = -intRadius; y <= intRadius; y++) {
    //         var sampleUv: vec2<f32> = uv + vec2<f32>(f32(x), f32(y)) / resolution;
    //         var sampleColor: vec4<f32> = fmb_cloud(sampleUv, time, resolution);
    //         var weight: f32 = exp(-f32(x * x + y * y) / (2.0 * blurRadius * blurRadius));
    //         blurredColor += sampleColor * weight;
    //         totalWeight += weight;
    //     }
    // }

    // blurredColor /= totalWeight;
    // return blurredColor;

	// or, the vanilla port:
    return fmb_cloud(uv, time, resolution);
}    


fn fmb_cloud(uv: vec2f, time: f32, resolution: vec2f)->vec4f{
	var color: vec3<f32> = vec3<f32>(0.);

	var q: vec2<f32> = vec2<f32>(0.);
	q.x = fbm(uv + 0. * time);
	q.y = fbm(uv + vec2<f32>(1.));

	var r: vec2<f32> = vec2<f32>(0.);
	r.x = fbm(uv + 1. * q + vec2<f32>(1.7, 9.2) + 0.15 * time);
	r.y = fbm(uv + 1. * q + vec2<f32>(8.3, 2.8) + 0.126 * time);

	let f: f32 = fbm(uv + r);

	color = mix(vec3<f32>(0.101961, 0.619608, 0.666667), vec3<f32>(0.666667, 0.666667, 0.498039), clamp(f * f * 4., 0., 1.));
	color = mix(color, vec3<f32>(0., 0., 0.164706), clamp(length(q), 0., 1.));
	color = mix(color, vec3<f32>(0.666667, 1., 1.), clamp(length(r.x), 0., 1.));

    return vec4<f32>((f * f * f + 0.6 * f * f + 0.5 * f) * color, 1.0);
}
    
fn random(uv: vec2<f32>) -> f32 {
	return fract(sin(dot(uv.xy, vec2<f32>(12.9898, 78.233))) * 43758.547);
} 

fn noise(uv: vec2<f32>) -> f32 {
	var i: vec2<f32> = floor(uv);
	var f: vec2<f32> = fract(uv);
	var a: f32 = random(i);
	let b: f32 = random(i + vec2<f32>(1., 0.));
	let c: f32 = random(i + vec2<f32>(0., 1.));
	let d: f32 = random(i + vec2<f32>(1., 1.));
	let u: vec2<f32> = f * f * (3. - 2. * f);
	return mix(a, b, u.x) + (c - a) * u.y * (1. - u.x) + (d - b) * u.x * u.y;
} 

fn fbm(_uv: vec2<f32>) -> f32 {
	var uv = _uv;
	var v: f32 = 0.;
	var a: f32 = 0.5;
	let shift: vec2<f32> = vec2<f32>(100.);
	let rot: mat2x2<f32> = mat2x2<f32>(cos(0.5), sin(0.5), -sin(0.5), cos(0.5));

	for (var i: i32 = 0; i < NUM_OCTAVES;  i++) {
		v = v + (a * noise(uv));
		uv = rot * uv * 2. + shift;
		a = a * (0.5);
	}

	return v;
} 

