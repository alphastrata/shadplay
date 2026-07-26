use bevy::{log, prelude::*};
use std::collections::HashMap;
use std::path::PathBuf;

use crate::prelude::*;
use crate::shader_utils::texture_tooling::SetNewTexture;

#[derive(Default, Resource, Deref, DerefMut, Clone, Debug)]
pub struct TexHandleQueue(pub HashMap<usize, Handle<Image>>);

#[derive(Event, Message, Deref, DerefMut, Clone, Debug)]
pub struct UserAddedTexture(PathBuf);

static AVAILABLE_TEX_FORMATS: [&str; 3] = ["png", "jpeg", "jpg"];
static WGSL_FORMATS: [&str; 1] = ["wgsl"];

pub fn file_drag_and_drop_listener(
    mut events: MessageReader<FileDragAndDrop>,
    mut texture_tx: MessageWriter<UserAddedTexture>,
    mut shader_tx: MessageWriter<DragNDropShader>,
) {
    events.read().for_each(|event| {
        if let FileDragAndDrop::DroppedFile { path_buf, .. } = event {
            info!("{}", path_buf.display());
            if AVAILABLE_TEX_FORMATS.iter().any(|fmt| {
                path_buf.extension().is_some_and(|x| x.to_string_lossy().contains(fmt))
            }) {
                texture_tx.write(UserAddedTexture(path_buf.clone()));
            } else if WGSL_FORMATS.iter().any(|fmt| {
                path_buf.extension().is_some_and(|x| x.to_string_lossy().contains(fmt))
            }) {
                shader_tx.write(DragNDropShader { path: path_buf.clone() });
            }
        }
    });
}

pub fn override_current_shader(
    mut dropped_shader: MessageReader<DragNDropShader>,
    app_state: Res<State<AppState>>,
) {
    dropped_shader.read().for_each(|pb| {
        info!("A wgsl shader was dropped on with path: {}", pb.display());
        let Ok(shader_as_string) = std::fs::read_to_string(pb.as_path()) else { return; };
        match app_state.get() {
            AppState::TwoD => {
                if let Err(e) = std::fs::write("assets/shaders/myshader_2d.wgsl", &shader_as_string) {
                    error!("Error overriding the 2d shader:\n\t{}", e);
                }
            }
            AppState::ThreeD => {
                if let Err(e) = std::fs::write("assets/shaders/myshader.wgsl", &shader_as_string) {
                    error!("Error overriding the 3d shader:\n\t{}", e);
                }
            }
            _ => log::debug!("No shader override happens when we enter/exit GifMode."),
        }
    });
}

pub fn add_and_set_dropped_file(
    asset_server: Res<AssetServer>,
    mut shader_mat_3d: ResMut<Assets<YourShader>>,
    mut shader_mat_2d: ResMut<Assets<YourShader2D>>,
    mut tex_handles: ResMut<TexHandleQueue>,
    mut user_textures: MessageReader<UserAddedTexture>,
) {
    let new_idx = tex_handles.keys().count();
    for tex_path in user_textures.read() {
        let texture: Handle<Image> = asset_server.load(tex_path.as_path().to_string_lossy().to_string());
        tex_handles.insert(new_idx, texture);
        if let Some((_, shad_mat)) = shader_mat_2d.iter_mut().next() {
            YourShader2D::set_current_tex(shad_mat, new_idx, &tex_handles);
            return;
        }
        if let Some((_, shad_mat)) = shader_mat_3d.iter_mut().next() {
            YourShader::set_current_tex(shad_mat, new_idx, &tex_handles);
            return;
        }
        error!("Unable to set the texture for either 2D or 3D shaders.");
    }
}

#[cfg(debug_assertions)]
pub fn debug_tex_keys(tex_handles: Res<TexHandleQueue>) {
    debug!("Num Textures: {}", tex_handles.len());
}
