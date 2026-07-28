// Corne Keyboard Test Shader by @byt3_m3chanic (11/26/2024)
// License: Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License
// Ported from GLSL to WGSL for shadplay

#import bevy_sprite::mesh2d_view_bindings::globals 
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

fn rot(a: f32) -> mat2x2f {
    let c = cos(a);
    let s = sin(a);
    return mat2x2f(vec2f(c, s), vec2f(-s, c));
}

fn hue(t: f32, f: f32) -> vec3f {
    let c = vec3f(1.0, 0.75, 0.75) + vec3f(0.96, 0.57, 0.12);
    return vec3f(f) + vec3f(f) * cos(6.28318530718 * t * c);
}

fn hash21(a: vec2f) -> f32 {
    return fract(sin(dot(a, vec2f(27.69, 32.58))) * 43758.53);
}

fn box_sd(p: vec2f, b: vec2f) -> f32 {
    let d = abs(p) - b;
    return length(max(d, vec2f(0.0))) + min(max(d.x, d.y), 0.0);
}

fn pattern(p_in: vec2f, sc: f32, r90: mat2x2f) -> vec2f {
    var p = p_in;
    let id = floor(p * sc);
    p = fract(p * sc) - vec2f(0.5);

    var rnd = hash21(id);

    if (rnd > 0.5) {
        p = r90 * p;
    }
    rnd = fract(rnd * 32.54);
    if (rnd > 0.4) {
        p = r90 * p;
    }
    if (rnd > 0.8) {
        p = r90 * p;
    }

    rnd = fract(rnd * 47.13);

    let tk: f32 = 0.075;

    var d = box_sd(p - vec2f(0.6, 0.7), vec2f(0.25, 0.75)) - 0.15;
    var l = box_sd(p - vec2f(0.7, 0.5), vec2f(0.75, 0.15)) - 0.15;
    var b = box_sd(p + vec2f(0.0, 0.7), vec2f(0.05, 0.25)) - 0.15;
    var r = box_sd(p + vec2f(0.6, 0.0), vec2f(0.15, 0.05)) - 0.15;
    d = abs(d) - tk;

    if (rnd > 0.92) {
        d = box_sd(p - vec2f(-0.6, 0.5), vec2f(0.25, 0.15)) - 0.15;
        l = box_sd(p - vec2f(0.6, 0.6), vec2f(0.25)) - 0.15;
        b = box_sd(p + vec2f(0.6, 0.6), vec2f(0.25)) - 0.15;
        r = box_sd(p - vec2f(0.6, -0.6), vec2f(0.25)) - 0.15;
        d = abs(d) - tk;
    } else if (rnd > 0.6) {
        d = abs(p.x - 0.2) - tk;
        l = box_sd(p - vec2f(-0.6, 0.5), vec2f(0.25, 0.15)) - 0.15;
        b = box_sd(p + vec2f(0.6, 0.6), vec2f(0.25)) - 0.15;
        r = box_sd(p - vec2f(0.3, 0.0), vec2f(0.25, 0.05)) - 0.15;
    }

    l = abs(l) - tk;
    b = abs(b) - tk;
    r = abs(r) - tk;

    let e = min(d, min(l, min(b, r)));

    if (rnd > 0.6) {
        r = max(r, -box_sd(p - vec2f(0.2, 0.2), vec2f(tk * 1.3)));
        d = max(d, -box_sd(p + vec2f(-0.2, 0.2), vec2f(tk * 1.3)));
    } else {
        l = max(l, -box_sd(p - vec2f(0.2, 0.2), vec2f(tk * 1.3)));
    }

    d = min(d, min(l, min(b, r)));
    return vec2f(d, e);
}

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let resolution = view.viewport.zw;
    let F = vec2f(in.uv.x, 1.0 - in.uv.y) * resolution;
    let iTime = globals.time;

    var C = vec3f(0.0);
    var uv = (2.0 * F - resolution) / max(resolution.x, resolution.y);
    let r90 = rot(1.5707);

    uv = rot(iTime * 0.095) * uv;

    // Shane's logarithmic spiral coordinate mapping
    uv = vec2f(log(length(uv)), atan2(uv.y, uv.x) * 6.0 / 6.28318530718);

    var scale: f32 = 8.0;
    for (var i: f32 = 0.0; i < 4.0; i += 1.0) {
        let ff = (i * 0.05) + 0.2;
        uv.x += iTime * ff;

        let px = fwidth(uv.x * scale);
        let d = pattern(uv, scale, r90);
        let clr = hue(sin(uv.x + (i * 8.0)) * 0.2 + 0.4, (0.5 + i) * 0.15);

        C = mix(C, vec3f(0.001), smoothstep(px, -px, d.y - 0.04));
        C = mix(C, clr, smoothstep(px, -px, d.x));
        scale *= 0.5;
    }

    // Gamma correction & high contrast tuning
    var rgb = pow(C, vec3f(0.4545));
    rgb = pow(clamp(rgb, vec3f(0.0), vec3f(1.0)), vec3f(1.3)) * 1.2;
    rgb = clamp(rgb, vec3f(0.0), vec3f(1.0));

    return vec4f(rgb, 1.0);
}
