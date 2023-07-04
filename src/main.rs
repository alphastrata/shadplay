#![allow(unused_imports)]
use bevy::{
    asset::ChangeWatcher,
    prelude::*,
    utils::Duration,
    window::{CompositeAlphaMode, WindowLevel},
    window::{Window, WindowPlugin},
};

use shadplay::{shader_utils, utils};

fn main() {
    App::new()
        .insert_resource(utils::ShapeOptions::default())
        .add_plugins(
            //..
            (
                // We make a few customisations...
                DefaultPlugins
                    .set(AssetPlugin {
                        // We want to watch for when our myshader.wgsl is changed on disk to re-render.
                        watch_for_changes: ChangeWatcher::with_delay(Duration::from_millis(200)),
                        ..default()
                    })
                    .set(WindowPlugin {
                        primary_window: Some(Window {
                            title: "shadplay".into(),
                            resolution: (320., 180.).into(),
                            // Setting `transparent` allows the `ClearColor`'s alpha value to take effect
                            transparent: true,
                            // Disabling window decorations to make it feel more like a widget than a window
                            decorations: true,
                            #[cfg(target_os = "macos")]
                            composite_alpha_mode: CompositeAlphaMode::PostMultiplied,
                            // We want our shader to be ontop of everything, always :)
                            window_level: WindowLevel::AlwaysOnTop,
                            ..default()
                        }),
                        ..default()
                    }),
                // YOUR SHADER STUFF!!
                MaterialPlugin::<shader_utils::YourShader>::default(),
            ),
            //..
        )
        .insert_resource(ClearColor(Color::NONE)) // Transparent Window
        .insert_resource(utils::TransparencySet(true))
        .add_systems(PreStartup, utils::init_shapes)
        .add_systems(Startup, utils::setup)
        .add_systems(
            Update,
            (
                utils::rotate,
                utils::toggle_decorations,
                utils::switch_level, //..
                utils::switch_shape,
                utils::quit,
                utils::toggle_mouse_passthrough,
                utils::toggle_transparency,
            ),
        )
        .run();
}
