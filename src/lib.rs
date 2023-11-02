pub mod drag_n_drop;
pub mod plugin;
pub mod screenshot;
pub mod shader_utils;
pub mod system;
pub mod system_clipboard;
pub mod texture_tooling;
pub mod ui;
pub mod utils;

pub mod prelude {
    //! The Shadplay Prelude, you'll probably find yourself wanting things from/adding things to this, if you're working on Shadplay.
    pub use crate::{
        drag_n_drop::{
            add_and_set_dropped_file, file_drag_and_drop_listener, override_current_shader,
            TexHandleQueue, UserAddedTexture,
        },
        screenshot::screenshot_and_version_shader_on_spacebar,
        shader_utils::{
            common::ShadplayShaderLibrary, DragNDropShader, MousePos, YourShader, YourShader2D,
        },
        texture_tooling::{self, swap_2d_tex_from_idx, swap_3d_tex_from_idx, SetNewTexture},
        ui::colour_picker_plugin::ColourPickerPlugin,
        utils::{
            self, cam_switch_system, cleanup_2d, cleanup_3d, init_shapes, quit, rotate, setup_2d,
            setup_3d, size_quad, switch_level, switch_shape, toggle_rotate, toggle_transparency,
            toggle_window_passthrough, update_mouse_pos, AppState, MonitorsSpecs, Rotating,
            ShadplayWindowDims, ShapeOptions, TransparencySet,
        },
    };
}
