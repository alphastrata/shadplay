///
/// ShadPlay
///
use bevy::{
    asset::ChangeWatcher,
    input::keyboard::KeyboardInput,
    prelude::*,
    utils::Duration,
    window::{WindowPlugin, WindowResized},
};

use shadplay::{plugin::ShadPlayPlugin, system::config::UserConfig, utils::AppState};

fn main() -> anyhow::Result<()> {
    let path = UserConfig::get_config_path();
    // Get UserConfig for the Shadplay window dimensions, decorations toggle etc.
    let user_config = match UserConfig::load_from_toml(&path) {
        Ok(config) => config,
        Err(_) => {
            let default_config = UserConfig::default();
            let _ = default_config.save_to_toml(path);
            default_config
        }
    };
    let user_cfg_window = user_config.create_window_settings();

    let mut app = App::new();

    let shadplay = app
        .add_state::<AppState>()
        .insert_resource(user_config)
        .insert_resource(ClearColor(Color::NONE))
        .add_plugins((
            DefaultPlugins
                .set(AssetPlugin {
                    watch_for_changes: ChangeWatcher::with_delay(Duration::from_millis(200)),
                    ..default()
                })
                .set(WindowPlugin {
                    primary_window: Some(user_cfg_window), // From UserConfig
                    ..default()
                }),
            ShadPlayPlugin,
        ))
        .add_systems(
            Update,
            (
                UserConfig::runtime_updater.run_if(on_event::<KeyboardInput>()),
                UserConfig::runtime_updater.run_if(on_event::<WindowResized>()),
            ),
            //
        );

    shadplay.run();
}
