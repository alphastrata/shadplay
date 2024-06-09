//! Bundles in our shader functions/consts etc declared in `shader_utils/common.wgsl` to make them importable.
use bevy::{
    asset::load_internal_asset,
    prelude::{App, Handle, Plugin, Shader},
};

pub struct ShadplayShaderLibrary;

pub const SHADPLAY_SHADER_LIBRARY_HANDLE: Handle<Shader> =
    Handle::weak_from_u128(16813517719070609599);

impl Plugin for ShadplayShaderLibrary {
    fn build(&self, app: &mut App) {
        load_internal_asset!(
            app,
            SHADPLAY_SHADER_LIBRARY_HANDLE,
            "common.wgsl", // Must be a more complete path. (The bevy codebase puts them alongside...)
            Shader::from_wgsl
        );
    }
}
