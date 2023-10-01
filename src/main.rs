#[cfg(target_os = "macos")]
use bevy::window::CompositeAlphaMode;
use bevy::{
    asset::ChangeWatcher,
    prelude::*,
    sprite::Material2dPlugin,
    utils::Duration,
    window::WindowLevel,
    window::{Window, WindowPlugin, WindowResized},
};
use bevy_panorbit_camera::PanOrbitCameraPlugin;

use shadplay::{
    screenshot, shader_utils,
    utils::{self, AppState, Rotating, ShapeOptions, TransparencySet, Rotating, ShapeOptions, TransparencySet},
};

fn main() {
    App::new()
        .add_state::<AppState>()
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
        .add_plugins(Material2dPlugin::<shader_utils::YourShader2D>::default())
        .insert_resource(ShapeOptions::default())
        .insert_resource(TransparencySet(true))
        .insert_resource(Rotating(false))
        .add_plugins(PanOrbitCameraPlugin)
        //
        .add_systems(OnEnter(AppState::ThreeD), utils::setup_3d)
        .add_systems(OnExit(AppState::ThreeD), utils::cleanup_3d)
        //
        .add_systems(OnEnter(AppState::TwoD), utils::setup_2d)
        .add_systems(OnExit(AppState::TwoD), utils::cleanup_2d)
        // All the time
        .insert_resource(ClearColor(Color::NONE))
        .add_systems(PreStartup, utils::init_shapes)
        // 3d Cam Systems
        .add_systems(
            Update,
            (
                utils::toggle_rotate,
                utils::rotate.run_if(resource_equals::<Rotating>(shadplay::utils::Rotating(true))),
                utils::switch_level,
                utils::switch_shape,
            )
                .run_if(in_state(AppState::ThreeD)),
        )
        // All the time systems
        .add_systems(
            Update,
            (
                screenshot::screenshot_and_version_shader_on_spacebar,
                utils::toggle_decorations,
                utils::quit,
                utils::toggle_window_passthrough,
                utils::toggle_transparency,
                utils::cam_switch_system,

                screenshot::screenshot_and_version_shader_on_spacebar,
            ),
        )
        // 2d Only Sytsems
        .add_systems(
            Update,
            utils::size_quad
                .run_if(in_state(AppState::TwoD))
                .run_if(on_event::<WindowResized>()),
        )
        .run();
}
