///
/// ShadPlay
///
use bevy::{prelude::*, window::WindowResized};
use std::env;
use std::fs;
use std::path::Path;

use bevy::asset::AssetPlugin;
use shadplay::{plugin::ShadPlayPlugin, system::config::UserSession};

fn main() {
    let args: Vec<String> = env::args().collect();

    // Check if a shader file path is provided as an argument
    if args.len() > 1 {
        let shader_path = &args[1];
        if let Err(e) = load_and_apply_shader(shader_path) {
            eprintln!("Error loading shader from {}: {}", shader_path, e);
            std::process::exit(1);
        }
    }

    // Get UserConfig for the Shadplay window dimensions, decorations toggle etc.
    let path = UserSession::get_config_path();
    let user_config = UserSession::load_from_toml(path).unwrap_or_default();
    let user_cfg_window = user_config.create_window_settings();

    let mut app = App::new();
    let shadplay = app
        .insert_resource(user_config)
        .insert_resource(ClearColor(Color::NONE))
        .add_plugins((
            DefaultPlugins
                .set(WindowPlugin {
                    primary_window: Some(user_cfg_window),
                    ..default()
                })
                .set(AssetPlugin {
                    unapproved_path_mode: bevy::asset::UnapprovedPathMode::Allow, // ← this one line unlocks external PNGs
                    ..default()
                }),
            ShadPlayPlugin,
        ))
        .add_systems(
            PostUpdate,
            (
                UserSession::runtime_updater
                    .run_if(on_message::<WindowResized>)
                    .run_if(time_passed(1.0)), // Rate limit the speed at which we write to the config file...
            ),
        );

    shadplay.run();
}

/// Loads a shader file and determines if it's 2D or 3D, then applies it appropriately
fn load_and_apply_shader(shader_path: &str) -> Result<(), Box<dyn std::error::Error>> {
    let path = Path::new(shader_path);

    // Check if file exists
    if !path.exists() {
        return Err(format!("Shader file does not exist: {}", shader_path).into());
    }

    // Read the shader file
    let shader_content = fs::read_to_string(path)?;

    // Determine if it's 2D or 3D based on contents
    let is_2d = detect_shader_type(&shader_content);

    // Copy the shader to the appropriate location based on its type
    let target_path = if is_2d {
        "assets/shaders/myshader_2d.wgsl"
    } else {
        "assets/shaders/myshader.wgsl"
    };

    fs::write(target_path, &shader_content)?;

    println!(
        "Loaded {} shader from {} to {}",
        if is_2d { "2D" } else { "3D" },
        shader_path,
        target_path
    );

    Ok(())
}

/// Detects if a shader is 2D or 3D based on common patterns
fn detect_shader_type(shader_content: &str) -> bool {
    let mut is_2d_score = 0;
    let mut is_3d_score = 0;

    // Strong 2D indicators
    if shader_content.contains("bevy_sprite::mesh2d_view_bindings") {
        is_2d_score += 1000; // Extremely strong 2D indicator
    }

    if shader_content.contains("bevy_sprite::mesh2d_vertex_output") {
        is_2d_score += 1000; // Extremely strong 2D indicator
    }

    if shader_content.contains("mesh2d_") {
        is_2d_score += 500; // Strong 2D indicator
    }

    // Strong 3D indicators
    if shader_content.contains("bevy_pbr::") {
        is_3d_score += 1000; // Extremely strong 3D indicator
    }

    if shader_content.contains("forward_io") {
        is_3d_score += 500; // Strong 3D indicator
    }

    if shader_content.contains("mesh_view_bindings") {
        is_3d_score += 300; // 3D indicator
    }

    // General patterns
    if shader_content.contains("bevy_sprite::") {
        is_2d_score += 100; // Sprite indicates 2D
    }

    if shader_content.contains("VertexOutput") && shader_content.contains("bevy_sprite::") {
        is_2d_score += 200; // 2D vertex output
    }

    is_2d_score > is_3d_score
}

// https://github.com/bevyengine/bevy/blob/b9123e74b6838b58c33badff73d176441f8a33cc/examples/ecs/run_conditions.rs
fn time_passed(t: f32) -> impl FnMut(Local<f32>, Res<Time>) -> bool {
    move |mut timer: Local<f32>, time: Res<Time>| {
        *timer += time.delta_secs();
        *timer >= t
    }
}
