//! Makes `shader_utils/common.wesl` importable as `shadplay::shader_utils::common`.
use bevy::{prelude::{App, Plugin}, shader::load_shader_library};

pub struct ShadplayShaderLibrary;

impl Plugin for ShadplayShaderLibrary {
    fn build(&self, app: &mut App) {
        load_shader_library!(app, "common.wesl");
    }
}
