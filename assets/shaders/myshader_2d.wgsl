/// ***************************** ///
/// THIS IS THE DEFAULT 2D SHADER ///
/// You can always get back to this with `python3 scripts/reset-2d.py` ///
/// ***************************** ///

#import bevy_sprite::mesh2d_view_bindings::globals 
#import shadplay::shader_utils::common::{NEG_HALF_PI, shader_toy_default, rotate2D, TWO_PI}
#import bevy_render::view::View
#import bevy_pbr::forward_io::VertexOutput;

@group(0) @binding(0) var<uniform> view: View;

const SPEED:f32 = 100;

@fragment
fn fragment(in: VertexOutput) -> @location(0) vec4<f32> {
    let uv_coords = in.uv * 0.25;
    let screen_resolution = view.viewport.zw;
    let time_scaled = globals.time * SPEED;

    var resolution_vec: vec3<f32> = vec3<f32>(screen_resolution, 1.0);
    var position: vec3<f32>;
    var ray_distance: f32 = 0.0;
    var scene_distance: f32;
    var iteration_count: f32 = 0.0;
    var loop_index: f32;
    let epsilon: f32 = 5e-3;

    var output_color: vec4<f32> = vec4<f32>(0.0, 0.0, 0.0, 0.0);
    loop {
        if (iteration_count >= 44.0) {
            break;
        }

        position = ray_distance * (vec3<f32>(uv_coords, resolution_vec.y) - resolution_vec * 0.5) / resolution_vec.y;
        position.z -= 2.0;

        scene_distance = length(abs(abs(position) - 0.3) - 0.3) - 0.3;

        loop_index = 1.0;
        loop {
            if (loop_index >= 8.0) {
                break;
            }

            position *= loop_index * 2.0;
            scene_distance += 0.018 * abs(dot(sin(position), resolution_vec / resolution_vec)) / loop_index;

            loop_index += loop_index;
        }

        scene_distance = abs(scene_distance);

        if (scene_distance < epsilon / 3.0) {
            output_color += (1.0 - scene_distance / epsilon) / ray_distance * iteration_count / 250.0;
        } else {
            output_color += vec4<f32>(0.0, 0.0, 0.001, 0.0);
        }

        ray_distance += max(scene_distance, epsilon / 5.0);
        iteration_count += 1.0;
    }

    return output_color;
}
