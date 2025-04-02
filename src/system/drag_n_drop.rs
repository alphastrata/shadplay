use bevy::{log, prelude::*};
use std::collections::HashMap;
use std::path::PathBuf;

use crate::prelude::*;
use crate::shader_utils::texture_tooling::SetNewTexture;

/// Resource: Representing the index (the default texture will be at 0), and a Texture handle that we can pass to a shader
#[derive(Default, Resource, Deref, DerefMut, Clone, Debug)]
pub struct TexHandleQueue(pub HashMap<usize, Handle<Image>>);

/// Event: used to store user defined textures that we allow them to drop onto the window.
/// TX: [`file_drag_and_drop_listener`] system.
/// RX: [swap_tex_to_idx] system.
#[derive(Event, Deref, DerefMut, Clone, Debug)]
pub struct UserAddedTexture(PathBuf);

/// Supported textures extensions for the drag-n-drop your texture functionality
/// Update this in future if we're going to support more extensions.
static AVAILABLE_TEX_FORMATS: [&str; 3] = ["png", "jpeg", "jpg"];
static WGSL_FORMATS: [&str; 1] = ["wgsl"];

/// System: Listens for .png and .jpeg files dropped onto the window.
pub fn file_drag_and_drop_listener(
    mut events: EventReader<FileDragAndDrop>,
    mut texture_tx: EventWriter<UserAddedTexture>,
    mut shader_tx: EventWriter<DragNDropShader>,
) {
    events.read().for_each(|event| {
        if let FileDragAndDrop::DroppedFile { path_buf, .. } = event {
            info!("{}", path_buf.display());
            if AVAILABLE_TEX_FORMATS.iter().any(|fmt| {
                path_buf
                    .extension()
                    .is_some_and(|x| x.to_string_lossy().contains(fmt))
            }) {
                texture_tx.write(UserAddedTexture(path_buf.clone()));
            } else if WGSL_FORMATS.iter().any(|fmt| {
                path_buf
                    .extension()
                    .is_some_and(|x| x.to_string_lossy().contains(fmt))
            }) {
                shader_tx.write(DragNDropShader {
                    path: path_buf.clone(),
                });
            }
        }
    });
}

/// System: should a user drop a shader onto the app -- we want to read it, and replace our current shader with it,
/// easy for us as they're locked into two options.
pub fn override_current_shader(
    mut dropped_shader: EventReader<DragNDropShader>,
    app_state: Res<State<AppState>>,
) {
    dropped_shader.read().for_each(|pb| {
        info!("A wgsl shader was dropped on with path: {}", pb.display());
        let Ok(shader_as_string) = std::fs::read_to_string(pb.as_path()) else {
            return;
        };

        match app_state.get() {
            AppState::TwoD => {
                info!("replacing 2d");
                match std::fs::write("assets/shaders/myshader_2d.wgsl", &shader_as_string) {
                    Ok(_) => {}
                    Err(e) => error!("Error overriding the 2d shader:\n\t{}", e),
                }
            }
            AppState::ThreeD => {
                info!("replacing 3d");
                match std::fs::write("assets/shaders/myshader.wgsl", &shader_as_string) {
                    Ok(_) => {}
                    Err(e) => error!("Error overriding the 3d shader:\n\t{}", e),
                }
            }
            _ => {
                log::debug!("No shader override happens when we enter/exit GifMode.")
            }
        }
    });
}

/// System: Add the user's dropped file to our available textures, set that texture to the current one.
pub fn add_and_set_dropped_file(
    asset_server: Res<AssetServer>,
    mut shader_mat_3d: ResMut<Assets<YourShader>>,
    mut shader_mat_2d: ResMut<Assets<YourShader2D>>,
    mut tex_handles: ResMut<TexHandleQueue>,
    mut user_textures: EventReader<UserAddedTexture>,
) {
    let new_idx = tex_handles.keys().count(); // Because comp sci counting.

    for tex_path in user_textures.read() {
        let texture: Handle<Image> =
            asset_server.load(tex_path.as_path().to_string_lossy().to_string());
        tex_handles.insert(new_idx, texture);

        // Try to set the texture for the first found `YourShader2D`
        if let Some((_, shad_mat)) = shader_mat_2d.iter_mut().next() {
            YourShader2D::set_current_tex(shad_mat, new_idx, &tex_handles);

            #[cfg(debug_assertions)]
            debug!("New Tex @ IDX:{}", new_idx);
            return; // Exit after setting the texture for the first `YourShader2D`
        }

        // If no `YourShader2D` was found, try setting it for the first `YourShader`
        if let Some((_, shad_mat)) = shader_mat_3d.iter_mut().next() {
            YourShader::set_current_tex(shad_mat, new_idx, &tex_handles);

            #[cfg(debug_assertions)]
            debug!("New Tex @ IDX:{}", new_idx);
            return; // Exit after setting the texture for the first `YourShader`
        }

        // Log an error if neither shader was available
        error!("Unable to set the texture for either 2D or 3D shaders.");
    }
}

#[cfg(debug_assertions)]
pub fn debug_tex_keys(tex_handles: Res<TexHandleQueue>) {
    debug!("Num Textures: {}", tex_handles.len());
}
