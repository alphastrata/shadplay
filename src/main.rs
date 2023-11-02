#[cfg(target_os = "macos")]
use bevy::window::CompositeAlphaMode;

use bevy::{
    asset::ChangeWatcher,
    input::keyboard::KeyboardInput,
    prelude::*,
    sprite::Material2dPlugin,
    utils::Duration,
    window::{WindowLevel, WindowPlugin, WindowResized},
};
use bevy_panorbit_camera::PanOrbitCameraPlugin;

#[cfg(feature = "ui")]
use shadplay::ui::help_ui::HelpUIPlugin;

use shadplay::{
    drag_n_drop::{self, TexHandleQueue, UserAddedTexture},
    screenshot,
    shader_utils::{self, DragNDropShader},
    system::UserConfig,
    texture_tooling,
    ui::colour_picker_plugin,
    utils::{self, AppState, MonitorsSpecs, Rotating, ShapeOptions, TransparencySet},
};

fn main() -> anyhow::Result<()> {
    // Get UserConfig for the Shadplay window dimensions, decorations toggle etc.
    let user_config = UserConfig::load_from_toml(UserConfig::get_config_path())?;
    let user_cfg_window = user_config.create_window_settings();

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
                    primary_window: Some(user_cfg_window), // From UserConfig
                    ..default()
                }),
            //
        ))
        .add_plugins(shader_utils::common::ShadplayShaderLibrary) // Something of a library with common functions.
        .add_plugins(colour_picker_plugin::ColourPickerPlugin)
        .add_plugins(MaterialPlugin::<shader_utils::YourShader>::default())
        .add_plugins(Material2dPlugin::<shader_utils::YourShader2D>::default())
        // Resources
        .insert_resource(MonitorsSpecs::default())
        .insert_resource(user_config) //UserConfig
        .insert_resource(TexHandleQueue::default())
        .insert_resource(utils::ShadplayWindowDims::default())
        .insert_resource(ShapeOptions::default())
        .insert_resource(TransparencySet(true))
        .insert_resource(Rotating(false))
        .insert_resource(ClearColor(Color::NONE))
        .add_plugins(PanOrbitCameraPlugin)
        //events:
        .add_event::<UserAddedTexture>()
        .add_event::<DragNDropShader>()
        // 3D
        .add_systems(OnEnter(AppState::ThreeD), utils::setup_3d)
        .add_systems(OnExit(AppState::ThreeD), utils::cleanup_3d)
        // 2D
        .add_systems(OnEnter(AppState::TwoD), utils::setup_2d)
        .add_systems(OnExit(AppState::TwoD), utils::cleanup_2d)
        // Setups.
        .add_systems(PreStartup, utils::init_shapes)
        // 3d Cam Systems
        .add_systems(
            Update,
            (
                utils::rotate.run_if(resource_equals::<Rotating>(shadplay::utils::Rotating(true))),
                utils::switch_shape,
                texture_tooling::swap_3d_tex_from_idx,
                utils::toggle_rotate,
            )
                .run_if(in_state(AppState::ThreeD)),
        )
        // All the time systems
        .add_systems(
            Update,
            (
                // DEBUG:
                // #[cfg(debug_assertions)]
                // drag_n_drop::debug_tex_keys,
                //
                drag_n_drop::file_drag_and_drop_listener,
                drag_n_drop::add_and_set_dropped_file.run_if(on_event::<UserAddedTexture>()),
                drag_n_drop::override_current_shader.run_if(on_event::<DragNDropShader>()),
                screenshot::screenshot_and_version_shader_on_spacebar,
                utils::cam_switch_system,
                utils::quit,
                utils::switch_level,
                utils::toggle_transparency,
                utils::toggle_window_passthrough,
                UserConfig::runtime_updater.run_if(on_event::<KeyboardInput>()),
                UserConfig::runtime_updater.run_if(on_event::<WindowResized>()),
            ),
        )
        // 2d Only Sytsems
        .add_systems(
            Update,
            (
                // utils::max_mon_res, // We're currently not using the maximum resolution of the primary monitor.
                utils::update_mouse_pos,
                texture_tooling::swap_2d_tex_from_idx,
                utils::size_quad
                    .run_if(in_state(AppState::TwoD))
                    .run_if(on_event::<WindowResized>()),
            ),
        );

    #[cfg(feature = "ui")]
    shadplay.add_plugins(HelpUIPlugin);

    shadplay.run();

    Ok(())
}
