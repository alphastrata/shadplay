#import bevy_pbr::mesh_vertex_output MeshVertexOutput
#import bevy_render::view  View

@group(0) @binding(0) var<uniform> view: View;

const SAMPLES: i32 = 4096; // Lower values will give you more of a gradient and less sharp a transition between the coloured/non-colured areas.

@fragment
fn fragment(in: MeshVertexOutput) -> @location(0) vec4<f32> {
    var uv = (in.uv * 2.0) - 1.0;
    let resolution = view.viewport.zw;
    // let t = globals.time * SPEED;
    uv.x *= resolution.x / resolution.y;
    var col = vec3f(0.0);

    uv.x -= 0.25; // Bring it into the middle a little more.
    col = vec3f(fract(mandelbrot(uv.x, uv.y, SAMPLES) / f32(SAMPLES)));
    // col = vec3f(mandelbrot(uv.x, uv.y, SAMPLES) / f32(SAMPLES)); // Lose the fract to change from outline to colouring the internal sections.

    return vec4f(col, 1.0);
}    
    

/// Simple mandlebrot: 
/// Inspiration/Ideas:
///   -   https://ispc.github.io/example.html
///   -   https://www.shadertoy.com/view/4df3Rn
fn mandelbrot(c_re: f32, c_im: f32, count: i32) -> f32 {
    var z_re: f32 = c_re;
    var z_im: f32 = c_im;
    var i: i32 = 0;

    loop {
        if z_re * z_re + z_im * z_im > 4.0 {
            break;
        }

        if i == count {
            break;
        }

        var new_re: f32 = z_re * z_re - z_im * z_im;
        var new_im: f32 = 2.0 * z_re * z_im;
        z_re = c_re + new_re;
        z_im = c_im + new_im;

        i = i + 1;
    }

    return f32(i);
}
