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

#[cfg(feature = "ui")]
use shadplay::ui::HelpUIPlugin;
use shadplay::{
    drag_n_drop::{TexHandleQueue, UserAddedTexture},
    screenshot, shader_utils,
    utils::{self, AppState, MonitorsSpecs, Rotating, ShapeOptions, TransparencySet},
};

fn main() {
    let mut app = App::new();

    let shadplay = app
        .add_state::<AppState>()
        .add_plugins((
            DefaultPlugins
                .set(AssetPlugin {
                    watch_for_changes: ChangeWatcher::with_delay(Duration::from_millis(200)),
                    ..default()
                })
                .set(WindowPlugin {
                    primary_window: Some(Window {
                        title: "shadplay".into(),
                        resolution: (720.0, 480.0).into(),
                        transparent: true,
                        #[cfg(not(target_os = "macos"))]
                        decorations: false,
                        #[cfg(target_os = "macos")]
                        composite_alpha_mode: CompositeAlphaMode::PostMultiplied,
                        window_level: WindowLevel::Normal, // I'd like to start always on top, but it's not supported on all platforms.
                        ..default()
                    }),
                    ..default()
                }),
            //
        ))
        .add_plugins(shader_utils::common::ShadplayShaderLibrary) // Something of a library with common functions.
        .add_plugins(MaterialPlugin::<shader_utils::YourShader>::default())
        .add_plugins(Material2dPlugin::<shader_utils::YourShader2D>::default())
        // Resources
        .insert_resource(MonitorsSpecs::default())
        .insert_resource(TexHandleQueue::default())
        .insert_resource(utils::ShadplayWindowDims::default())
        .insert_resource(ShapeOptions::default())
        .insert_resource(TransparencySet(true))
        .insert_resource(Rotating(false))
        .add_plugins(PanOrbitCameraPlugin)
        //events:
        .add_event::<UserAddedTexture>()
        // 3D
        .add_systems(OnEnter(AppState::ThreeD), utils::setup_3d)
        .add_systems(OnExit(AppState::ThreeD), utils::cleanup_3d)
        // 2D
        .add_systems(OnEnter(AppState::TwoD), utils::setup_2d)
        .add_systems(OnExit(AppState::TwoD), utils::cleanup_2d)
        // All the time
        .insert_resource(ClearColor(Color::NONE))
        .add_systems(PreStartup, utils::init_shapes)
        // 3d Cam Systems
        .add_systems(
            Update,
            (
                utils::rotate.run_if(resource_equals::<Rotating>(shadplay::utils::Rotating(true))),
                utils::switch_shape,
                utils::toggle_rotate,
            )
                .run_if(in_state(AppState::ThreeD)),
        )
        // All the time systems
        .add_systems(
            Update,
            (
                file_drag_and_drop_listener,
                add_and_set_dropped_file.run_if(on_event::<UserAddedTexture>()),
                swap_tex_to_idx, //.run_if(resource_changed::<TexHandleQueue>()), //FIXME:
                screenshot::screenshot_and_version_shader_on_spacebar,
                utils::cam_switch_system,
                utils::quit,
                utils::switch_level,
                utils::toggle_transparency,
                utils::toggle_window_passthrough,
            ),
        )
        // 2d Only Sytsems
        .add_systems(
            Update,
            (
                // utils::max_mon_res, // We're currently not using the maximum resolution of the primary monitor.
                utils::update_mouse_pos,
                utils::size_quad
                    .run_if(in_state(AppState::TwoD))
                    .run_if(on_event::<WindowResized>()),
            ),
        );

    #[cfg(feature = "ui")]
    shadplay.add_plugins(HelpUIPlugin);

    shadplay.run();
}
