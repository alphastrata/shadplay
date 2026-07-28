/*%ù£%%^*¨µù*£ùù£ù%%*ù¨¨%µ^$µ%ù^¨%$$^ù^ùµ*£*ù£%*^¨*£$*¨^£%^%*£%*
ù  ____    _    _   _ ____  _____ _____   _  ___  ____  ____   ù
ù / ___|  / \  | \ | |  _ \| ____|  ___| | |/ _ \|  _ \|  _ \  ù
ù \___ \ / _ \ |  \| | | | |  _| | |_ _  | | | | | |_) | | | | ù
ù  ___) / ___ \| |\  | |_| | |___|  _| |_| | |_| |  _ <| |_| | ù
ù |____/_/   \_\_| \_|____/|_____|_|  \___/ \___/|_| \_\____/  ù
ù                       PATRICK JAILLET                        ù
ù - https://patrickjaillet.github.io/sandefjord-software       ù
ù - https://x.com/JailletPatrick                               ù
$^%ù£%%^*¨µù*£ùù£ù%%*ù¨¨%µ^$µ%ù^¨%$$^ù^ùµ*£*ù£%*^¨*£$*¨^£%^%*£*/
// Ported from GLSL to WGSL for shadplay

#import bevy_sprite::mesh2d_view_bindings::globals 
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

fn mat2_cos(t: f32) -> mat2x2f {
    let v = cos(t + vec4f(0.0, 33.0, 11.0, 0.0));
    return mat2x2f(vec2f(v.x, v.y), vec2f(v.z, v.w));
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let resolution = view.viewport.zw;
    let u = vec2f(in.uv.x, 1.0 - in.uv.y) * resolution;
    let iTime = globals.time;

    let p_xy = (u * 2.0 - 1.4 * resolution) / resolution.y;
    var k = normalize(vec3f(p_xy, 1.0));
    var l = vec3f(0.5, 0.0, 0.1);
    let a = vec3f(0.447, 0.894, 0.179);

    let l_rot = mat2_cos(iTime * 0.1) * l.yz;
    l = vec3f(l.x, l_rot.x, l_rot.y);

    let s = sin(iTime * 0.15);
    let g = cos(iTime * 0.15);
    let b = 1.0 - g;

    let rot_mat = mat3x3f(
        vec3f(b * a.x * a.x + g,       b * a.x * a.y + a.z * s, b * a.z * a.x - a.y * s),
        vec3f(b * a.x * a.y - a.z * s, b * a.y * a.y + g,       b * a.y * a.z + a.x * s),
        vec3f(b * a.z * a.x + a.y * s, b * a.y * a.z - a.x * s, b * a.z * a.z + g)
    );
    k = rot_mat * k;

    var O = vec4f(0.0);
    var m: f32 = 0.0;
    let I = mat2_cos(-3.5814156);

    for (var A: i32 = 0; A < 91; A++) {
        if (m > 47.6) {
            break;
        }

        var c = l + k * m;
        let h = max(length(c), 1e-4);
        let i_vec = fract(vec3f(log(h) - iTime * 0.25, c.y / h, atan2(c.z, c.x)) * 0.7957747) - vec3f(0.5);

        var j: f32 = 0.4;
        c = i_vec;
        for (var B: i32 = 0; B < 12; B++) {
            c = abs(c) - vec3f(0.42, 0.49, 0.66);
            let c_xz = I * c.xz;
            c = vec3f(c_xz.x, c.y, c_xz.y);

            let C_val = 1.5 / max(dot(c, c), 1e-8);
            c = c * C_val - vec3f(0.1, 0.5, 0.4);
            j *= C_val;
        }

        let e = max((length(c.xz) - 0.2) / max(j, 1e-4), 1e-4);
        m += e;

        let color_term = sin(vec3f(0.0, 1.0, 1.8) - vec3f(i_vec.z * 8.7) + vec3f(iTime)) * 0.5 + vec3f(0.58);
        O += vec4f(color_term, 1.0) * 0.016 / (e * 80.0 + 0.74);
    }

    // Balanced contrast curve
    var rgb = clamp(O.rgb, vec3f(0.0), vec3f(1.0));
    rgb = pow(rgb, vec3f(1.3)) * 1.1;
    rgb = clamp(rgb, vec3f(0.0), vec3f(1.0));

    return vec4f(rgb, 1.0);
}
