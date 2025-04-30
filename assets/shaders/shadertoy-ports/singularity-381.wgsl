/// 
/// A Port of https://www.shadertoy.com/view/3csSWB by XOR
/// 
#import bevy_sprite::mesh2d_view_bindings::globals
#import bevy_render::view::View
#import bevy_sprite::mesh2d_vertex_output::VertexOutput

@group(0) @binding(0) var<uniform> view: View;

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    // 1. Centered coordinates setup
    let resolution = vec2f(view.viewport.z, view.viewport.w);
    let aspect = resolution.x / resolution.y;
    let uv = (2.0 * in.uv - 1.0) * vec2f(aspect, 1.0) / 0.7;
    
    // 2. Black hole position and initial warp
    let d = vec2f(-1.0, 1.0);
    let q = 5.0 * uv - d;
    let q_dot = dot(q, q);
    let matrix_part = d / (0.1 + 5.0 / q_dot);
    let c = uv * mat2x2f(1.0, 1.0, matrix_part.x, matrix_part.y);
    
    // 3. Spiral transformation
    let j = dot(c, c);
    let angle = 0.5 * log(j) + globals.time * 0.2;
    let cos0 = cos(angle);
    let cos33 = cos(angle + 33.0);
    let cos11 = cos(angle + 11.0);
    let rotation_matrix = mat2x2f(cos0, cos33, cos11, cos0);
    var v = (rotation_matrix * c) * 5.0;
    
    // 4. Wave pattern accumulation
    var s = vec2f(0.0);
    for(var i_sample: f32 = 0.0; i_sample < 9.0; i_sample += 1.0) {
        let i = i_sample + 1.0;
        s += 1.0 + sin(v);
        v += 0.7 * sin(v.yx * i + globals.time) / i + 0.5;
    }
    
    // 5. Accretion disk calculation
    let disk_contribution = sin(v / 0.3) * 0.4 + c * (3.0 + d);
    let disk = length(disk_contribution);
    
    // 6. Denominator components
    let disk_denominator = 2.0 + (disk * disk) / 4.0 - disk;
    let core_glow = 0.5 + 3.5 * exp(0.3 * c.y - j);
    let rim_highlight = 0.03 + abs(length(uv) - 0.7);
    
    // 7. Final color composition
    let color_base = c.x * vec4f(0.6, -0.4, -1.0, 0.0);
    let numerator = exp(color_base);
    let denominator = s.xyyx * disk_denominator * core_glow * rim_highlight;
    
    return 1.0 - exp(-numerator / denominator);
}