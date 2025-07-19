#![allow(unused_imports, dead_code)]

pub mod camera;
pub mod plugin;
pub mod shader_utils;
pub mod system;
pub mod ui;
pub mod utils;

pub mod prelude {
    //! The Shadplay Prelude, you'll probably find yourself wanting things from/adding things to this, if you're working on Shadplay.
    #[cfg(target_os = "windows")]
    pub use crate::utils::toggle_window_passthrough;
    pub use crate::{
        shader_utils::{
            DragNDropShader, MousePos, YourShader, YourShader2D,
            common::ShadplayShaderLibrary,
            texture_tooling::{self, SetNewTexture, swap_2d_tex_from_idx, swap_3d_tex_from_idx},
        },
        system::drag_n_drop::{
            TexHandleQueue, UserAddedTexture, add_and_set_dropped_file,
            file_drag_and_drop_listener, override_current_shader,
        },
        system::screenshot::screenshot_and_version_shader_on_spacebar,
        ui::colour_picker_plugin::ColourPickerPlugin,
        utils::{
            self, AppState, MonitorsSpecs, Rotating, ShadplayWindowDims, ShapeOptions,
            TransparencySet, cam_switch_system, cleanup_2d, cleanup_3d, init_shapes, quit, rotate,
            setup_2d, setup_3d, size_quad, switch_level, switch_shape, toggle_rotate,
            toggle_transparency, update_mouse_pos,
        },
    };
}
