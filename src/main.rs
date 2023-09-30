#[cfg(target_os = "macos")]
use bevy::window::CompositeAlphaMode;
use bevy::{
    asset::ChangeWatcher,
    prelude::*,
    utils::Duration,
    window::WindowLevel,
    window::{Window, WindowPlugin},
};
use bevy_panorbit_camera::PanOrbitCameraPlugin;

use shadplay::{
    shader_utils,
    utils::{self, Rotating, ShapeOptions, TransparencySet},
};

fn main() {
    App::new()
        .add_plugins((DefaultPlugins
            .set(AssetPlugin {
                watch_for_changes: ChangeWatcher::with_delay(Duration::from_millis(200)),
                ..default()
            })
            .set(WindowPlugin {
                primary_window: Some(Window {
                    title: "shadplay".into(),
                    resolution: (720.0, 480.0).into(),
                    transparent: true,
                    decorations: true,
                    #[cfg(target_os = "macos")]
                    composite_alpha_mode: CompositeAlphaMode::PostMultiplied,
                    window_level: WindowLevel::AlwaysOnTop,
                    ..default()
                }),
                ..default()
            }),))
        .add_plugins(MaterialPlugin::<shader_utils::YourShader>::default())
        .insert_resource(ShapeOptions::default())
        .insert_resource(TransparencySet(true))
        .insert_resource(Rotating(true))
        .add_plugins(PanOrbitCameraPlugin)
        .add_systems(Startup, utils::setup)
        .insert_resource(ClearColor(Color::NONE))
        .add_systems(PreStartup, utils::init_shapes)
        .add_systems(
            Update,
            (
                utils::toggle_rotate,
                utils::rotate.run_if(resource_equals::<Rotating>(shadplay::utils::Rotating(true))),
                utils::toggle_decorations,
                utils::switch_level,
                utils::switch_shape,
                utils::quit,
                utils::toggle_window_passthrough,
                utils::toggle_transparency,
                screenshot::screenshot_on_spacebar,
            ),
        )
        .run();
}

pub mod screenshot {

    use bevy::prelude::*;
    use bevy::render::view::screenshot::ScreenshotManager;
    use bevy::window::PrimaryWindow;

    pub fn screenshot_on_spacebar(
        input: Res<Input<KeyCode>>,
        main_window: Query<Entity, With<PrimaryWindow>>,
        mut screenshot_manager: ResMut<ScreenshotManager>,
    ) {
        if input.just_pressed(KeyCode::Space) {
            let path = format!("screenshots/{}.png", timestamper());
            match screenshot_manager.save_screenshot_to_disk(main_window.single(), path) {
                Ok(_) => {}
                Err(e) => eprintln!("{}", e),
            }
        }
    }

    use chrono::{Datelike, Local, Timelike};

    /// Provides a String of hh-mm-ss_dd-mm-yy timestamp.
    fn timestamper() -> String {
        let local = Local::now();

        let hour = local.hour();
        let minute = local.minute();
        let second = local.second();
        let day = local.day();
        let month = local.month();
        let year = local.year() % 100;

        format!(
            "{:02}-{:02}-{:02}_{:02}-{:02}-{:02}",
            hour, minute, second, day, month, year
        )
    }
}
