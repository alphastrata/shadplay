///
/// ShadPlay
///
use bevy::{input::keyboard::KeyboardInput, prelude::*, window::WindowResized};

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
            Update,
            (
                UserSession::runtime_updater.run_if(on_event::<KeyboardInput>),
                UserSession::runtime_updater.run_if(on_event::<WindowResized>),
            ),
            //
        );

    shadplay.run();
}
