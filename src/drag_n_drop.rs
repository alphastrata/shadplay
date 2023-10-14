use crate::shader_utils::YourShader;
use crate::shader_utils::YourShader2D;
use bevy::input::keyboard::KeyboardInput;
use bevy::input::ButtonState;
use bevy::prelude::*;

use std::collections::HashMap;
use std::path::PathBuf;

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

/// System: Listens for .png and .jpeg files dropped onto the window.
pub fn file_drag_and_drop_listener(
    mut events: EventReader<FileDragAndDrop>,
    mut texture_tx: EventWriter<UserAddedTexture>,
) {
    events.into_iter().for_each(|event| {
        if let FileDragAndDrop::DroppedFile { path_buf, .. } = event {
            texture_tx.send(UserAddedTexture(path_buf.clone()));
        }
    });
}

/// System: Add the user's dropped file to our available textures, set that texture to the current one (because that's what I'd expect!)
pub fn add_and_set_dropped_file(
    asset_server: Res<AssetServer>,
    mut tex_handles: ResMut<TexHandleQueue>,
    mut shader_mat: ResMut<Assets<YourShader2D>>,
    mut user_textures: EventReader<UserAddedTexture>,
    shader_hndl: Query<&Handle<YourShader2D>>,
) {
    user_textures.into_iter().for_each(|tex_path| {
        if AVAILABLE_TEX_FORMATS.iter().any(|fmt| {
            tex_path
                .extension()
                .is_some_and(|x| x.to_string_lossy().contains(fmt))
        }) {
            let texture: Handle<Image> = asset_server.load(tex_path.as_path());

            let new_idx = tex_handles.keys().count() + 1; // Because comp sci counting.
            tex_handles.insert(new_idx, texture);

            if let Ok(handle) = shader_hndl.get_single() {
                if let Some(shad_mat) = shader_mat.get_mut(handle) {
                    set_current_tex(shad_mat, new_idx, &tex_handles);

                    #[cfg(debug_assertions)]
                    debug!("New Tex @ IDX:{}", new_idx);
                }
            } else {
                error!("Unable to get handle to the currently active shader!");
            };
        };
    });
}

/// System: using the keys 0-9, swap the current texture to that idx.
pub fn swap_tex_to_idx(
    mut key_evr: EventReader<KeyboardInput>,
    shader_hndl: Query<&Handle<YourShader2D>>,
    mut shader_mat2d: ResMut<Assets<YourShader2D>>,
    user_textures: Res<TexHandleQueue>,
    mut shader_mat_3d: ResMut<Assets<YourShader>>, // FIXME: Support this do a 3d one? or just use this... idkrn
) {
    let Ok(handle) = shader_hndl.get_single() else {
        error!("TODO!");
    };

    if let Some(shad_mat) = shader_mat2d.get_mut(handle) {
        key_evr.iter().for_each(|ev| {
            if let ButtonState::Pressed = ev.state {
                debug!("{:?} pressed, moving to that Tex idx.", ev.key_code);
                if let Some(v) = ev.key_code {
                    match v {
                        KeyCode::Key1 => set_current_tex(shad_mat, 1, &user_textures),
                        KeyCode::Key2 => set_current_tex(shad_mat, 2, &user_textures),
                        KeyCode::Key3 => set_current_tex(shad_mat, 3, &user_textures),
                        KeyCode::Key4 => set_current_tex(shad_mat, 4, &user_textures),
                        KeyCode::Key5 => set_current_tex(shad_mat, 5, &user_textures),
                        KeyCode::Key6 => set_current_tex(shad_mat, 6, &user_textures),
                        KeyCode::Key7 => set_current_tex(shad_mat, 7, &user_textures),
                        KeyCode::Key8 => set_current_tex(shad_mat, 8, &user_textures),
                        KeyCode::Key9 => set_current_tex(shad_mat, 9, &user_textures),
                        KeyCode::Key0 => set_current_tex(shad_mat, 0, &user_textures),
                        _ => (),
                    }
                }
            }
        });
    }
}
