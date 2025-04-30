//
// This is a port of Discoteq2 https://www.shadertoy.com/view/DtXfDr by 'supah' https://www.shadertoy.com/user/supah
//

#import bevy_sprite::mesh2d_view_bindings::globals 
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

const HEIGHT:f32 = 4.0;
const INTENSITY:f32 = 5.0;
const NUM_LINES:f32 = 4.0;
const SPEED:f32 = 1.0;

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv = (in.uv * 2.0) - 1.0;
    var col = vec4f(0.0);


    for (var i = 0.0; i <= NUM_LINES; i += 1.0) {
        let t = i / INTENSITY;
        col += line(uv, SPEED + t, HEIGHT + t, vec3f(0.2 + t * 0.7, 0.2 + t * 0.4, 0.3));
    }

    return col;
}

fn line(uv_in: vec2f, speed: f32, height: f32, col: vec3f) -> vec4f {
    var uv_t = uv_in;
    uv_t.y += smoothstep(1.0, 0.0, abs(uv_t.x)) * sin(globals.time * speed + uv_t.x * height) * 0.2;
    return vec4(smoothstep(.06 * smoothstep(.2, .9, abs(uv_t.x)), 0., abs(uv_t.y) - .004) * col, 1.0) * smoothstep(1., .3, abs(uv_t.x));
}

