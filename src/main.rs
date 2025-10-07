///
/// ShadPlay
///
use bevy::{prelude::*, window::WindowResized};

use shadplay::{plugin::ShadPlayPlugin, system::config::UserSession};

fn main() {
    // Get UserConfig for the Shadplay window dimensions, decorations toggle etc.
    let path = UserSession::get_config_path();
    let user_config = UserSession::load_from_toml(path).unwrap_or_default();
    let user_cfg_window = user_config.create_window_settings();

    let mut app = App::new();
    let shadplay = app
        .insert_resource(user_config)
        .insert_resource(ClearColor(Color::NONE))
        .add_plugins((
            DefaultPlugins.set(WindowPlugin {
                primary_window: Some(user_cfg_window), // From UserConfig
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

// https://github.com/bevyengine/bevy/blob/b9123e74b6838b58c33badff73d176441f8a33cc/examples/ecs/run_conditions.rs
fn time_passed(t: f32) -> impl FnMut(Local<f32>, Res<Time>) -> bool {
    move |mut timer: Local<f32>, time: Res<Time>| {
        *timer += time.delta_secs();
        *timer >= t
    }
}
