/// ***************************** ///
/// This is a port of 'Perlin Waves' by zilian: https://www.shadertoy.com/view/DlVcRW ///
/// ***************************** ///

#import bevy_sprite::mesh2d_view_bindings::globals 
#import shadplay::shader_utils::common::{NEG_HALF_PI, shader_toy_default, rotate2D, TWO_PI}
#import bevy_render::view::View
#import bevy_pbr::forward_io::VertexOutput;

@group(0) @binding(0) var<uniform> view: View;


const TEMPERATURE: f32 = 5.;
const NOISESCALE: f32 = 0.2;
const EFFECTWIDTH: f32 = 1.;
const LINETHICKNESS: f32 = 0.008;
const SPEED: f32 = 0.2;


/// This is a port of 'Perlin Waves' by zilian: https://www.shadertoy.com/view/DlVcRW ///
@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let resolution = view.viewport.zw;
    var uv = in.uv;
    uv.y *= 0.5; // Bumping the Y down a bit.

    let y_inverted_location = vec2<i32>(i32(uv.x), i32(resolution.y) - i32(uv.y));
    let location = vec2<i32>(i32(uv.x), i32(uv.y));
    
	var fragColor: vec4<f32>;
	var fragCoord = vec2<f32>(f32(location.x), f32(location.y) );

	var sampleY: f32 = 0.;
	sampleY = sampleY + (globals.time * SPEED);
	var finalColor: vec3<f32> = vec3<f32>(0.);
	let deltaY: f32 = 0.003;

	for (var i: f32 = -10.; i <= 10.; i = i + (1.)) {
		let p: vec2<f32> = uv + vec2<f32>(0.06 * i, 0.05 * i);
		sampleY = sampleY + (i * deltaY);
		if (p.x < -EFFECTWIDTH || p.x > EFFECTWIDTH) {
			continue;
		}
		let line: f32 = perline(p, sampleY, LINETHICKNESS, NOISESCALE);
		let opacity: f32 = exp(-abs(i * 0.2));
		let col: vec3<f32> = palette(i * 0.04 + 0.3) * 2. * line * opacity;
		finalColor = max(finalColor, col);
	}

    return vec4f(finalColor, 1.0);
}    


fn fade(t: vec2<f32>) -> vec2<f32> {
	return t * t * t * (t * (t * 6. - 15.) + 10.);
} 

fn permute(x: vec4<f32>) -> vec4<f32> {
	return (((x * 34. + 1.) * x) % (289.));
} 

fn cnoise(P: vec2<f32>) -> f32 {
	var Pi: vec4<f32> = floor(P.xyxy) + vec4<f32>(0., 0., 1., 1.);
	let Pf: vec4<f32> = fract(P.xyxy) - vec4<f32>(0., 0., 1., 1.);
	Pi = ((Pi) % (289.));
	let ix: vec4<f32> = Pi.xzxz;
	let iy: vec4<f32> = Pi.yyww;
	let fx: vec4<f32> = Pf.xzxz;
	let fy: vec4<f32> = Pf.yyww;
	var i: vec4<f32> = permute(permute(ix) + iy);
	var gx: vec4<f32> = 2. * fract(i * 0.024390243) - 1.;
	let gy: vec4<f32> = abs(gx) - 0.5;
	let tx: vec4<f32> = floor(gx + 0.5);
	gx = gx - tx;
	var g00: vec2<f32> = vec2<f32>(gx.x, gy.x);
	var g10: vec2<f32> = vec2<f32>(gx.y, gy.y);
	var g01: vec2<f32> = vec2<f32>(gx.z, gy.z);
	var g11: vec2<f32> = vec2<f32>(gx.w, gy.w);
	let norm: vec4<f32> = 1.7928429 - 0.85373473 * vec4<f32>(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11));
	g00 = g00 * (norm.x);
	g01 = g01 * (norm.y);
	g10 = g10 * (norm.z);
	g11 = g11 * (norm.w);
	let n00: f32 = dot(g00, vec2<f32>(fx.x, fy.x));
	let n10: f32 = dot(g10, vec2<f32>(fx.y, fy.y));
	let n01: f32 = dot(g01, vec2<f32>(fx.z, fy.z));
	let n11: f32 = dot(g11, vec2<f32>(fx.w, fy.w));
	let fade_xy: vec2<f32> = fade(Pf.xy);
	let n_x: vec2<f32> = mix(vec2<f32>(n00, n01), vec2<f32>(n10, n11), fade_xy.x);
	let n_xy: f32 = mix(n_x.x, n_x.y, fade_xy.y);
	return 2.3 * n_xy;
} 

fn perline(p: vec2<f32>, noiseY: f32, lineThickness: f32, noiseScale: f32) -> f32 {
	let x: f32 = p.x / 2.;
	let s: f32 = cnoise(vec2<f32>(x, noiseY) * TEMPERATURE) * noiseScale;
	let distanceToLine: f32 = abs(p.y - s);
	return 0.009 / distanceToLine;
} 

/// Regular shadplayers will recognise this one...
fn palette(t: f32) -> vec3<f32> {
	let a: vec3<f32> = vec3<f32>(0.5, 0.5, 0.5);
	let b: vec3<f32> = vec3<f32>(0.5, 0.5, 0.5);
	let c: vec3<f32> = vec3<f32>(1., 1., 1.);
	let d: vec3<f32> = vec3<f32>(0.263, 0.416, 0.557);
	return a + b * cos(6.28318 * (c * t + d));
} 

