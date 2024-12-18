use bevy::{
    input::keyboard::KeyboardInput, log::tracing_subscriber::util::SubscriberInitExt, prelude::*,
    sprite::Material2dPlugin, window::WindowResized,
};
use bevy_panorbit_camera::PanOrbitCameraPlugin;

use crate::prelude::*;

/// Plugin: The main ShadPlay plugin
pub struct ShadPlayPlugin;

impl Plugin for ShadPlayPlugin {
    fn build(&self, app: &mut bevy::prelude::App) {
        app.insert_state(AppState::TwoD)
            .add_plugins(ShadplayShaderLibrary) // Something of a library with common functions.
            .add_plugins(crate::system::ScreenshotPlugin) //NOTE: this is not Bevy's one!
            .add_plugins(ColourPickerPlugin)
            .add_plugins(MaterialPlugin::<YourShader>::default())
            .add_plugins(Material2dPlugin::<YourShader2D>::default())
            // Resources
            .insert_resource(MonitorsSpecs::default())
            .insert_resource(TexHandleQueue::default())
            .insert_resource(ShadplayWindowDims::default())
            .insert_resource(ShapeOptions::default())
            .insert_resource(TransparencySet(true))
            .insert_resource(Rotating(false))
            .add_plugins(PanOrbitCameraPlugin)
            //events:
            .add_event::<UserAddedTexture>()
            .add_event::<DragNDropShader>()
            // 3D
            .add_systems(OnEnter(AppState::ThreeD), setup_3d)
            .add_systems(OnExit(AppState::ThreeD), cleanup_3d)
            // 2D
            .add_systems(OnEnter(AppState::TwoD), setup_2d)
            .add_systems(OnExit(AppState::TwoD), cleanup_2d)
            // Setups.
            .add_systems(PreStartup, init_shapes)
            // 3d Cam Systems
            .add_systems(
                Update,
                (
                    rotate.run_if(resource_equals::<Rotating>(Rotating(true))),
                    switch_shape,
                    swap_3d_tex_from_idx.run_if(on_event::<KeyboardInput>),
                    toggle_rotate,
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
                    file_drag_and_drop_listener,
                    add_and_set_dropped_file.run_if(on_event::<UserAddedTexture>),
                    override_current_shader.run_if(on_event::<DragNDropShader>),
                    cam_switch_system,
                    quit,
                    switch_level,
                    toggle_transparency,
                    toggle_window_passthrough,
                ),
            )
            // 2d Only Sytsems
            .add_systems(
                Update,
                (
                    // utils::max_mon_res, // We're currently not using the maximum resolution of the primary monitor.
                    update_mouse_pos,
                    size_quad
                        .run_if(in_state(AppState::TwoD))
                        .run_if(on_event::<WindowResized>),
                    swap_2d_tex_from_idx.run_if(on_event::<KeyboardInput>),
                ),
            );

        #[cfg(feature = "ui")]
        app.add_plugins(crate::ui::help_ui::HelpUIPlugin);
    }
}
