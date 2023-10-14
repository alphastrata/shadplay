pub mod screenshot;
pub mod shader_utils;
pub mod ui;
pub mod utils;

pub mod drag_n_drop {
    use crate::shader_utils::set_current_tex;
    #[allow(unused_imports)] //FIXME: after implementing texture on 3d...
    use crate::shader_utils::{YourShader, YourShader2D};
    use bevy::input::keyboard::KeyboardInput;
    use bevy::input::ButtonState;
    use bevy::prelude::*;

    use std::collections::HashMap;
    use std::path::PathBuf;

    /// Resource: Representing the index (the default texture will be at 0), and a Texture handle that we can pass to a shader
    #[derive(Default, Resource, Deref, DerefMut, Clone, Debug)]
    pub struct TexHandleQueue(pub HashMap<usize, Handle<Image>>);

    /// Event: used to store user defined textures that we allow them to drop onto the window.
    /// TX:
    /// RX:
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
        events.into_iter().for_each(|event| match event {
            FileDragAndDrop::DroppedFile { path_buf, .. } => {
                texture_tx.send(UserAddedTexture(path_buf.clone()));
                debug!("TX: {:?}", event);
            }
            _ => {}
        });
    }

    /// System: Add the user's dropped file to our available textures
    pub fn add_dropped_file(
        asset_server: Res<AssetServer>,
        mut user_textures: EventReader<UserAddedTexture>,
        mut handle_queue: ResMut<TexHandleQueue>,
    ) {
        user_textures.into_iter().for_each(|tex_path| {
            if AVAILABLE_TEX_FORMATS.iter().any(|fmt| {
                tex_path
                    .extension()
                    .is_some_and(|x| x.to_string_lossy().contains(fmt))
            }) {
                debug!("RX: {:?}", tex_path.display());
            } else {
                //FIXME: remove this branch entirely, we won't need it.
                debug!("ANY FAIL ON: {:?}", tex_path.display());
            };
            let texture: Handle<Image> = asset_server.load(tex_path.as_path());

            let new_idx = handle_queue.keys().count(); // TODO: make the default texture at 0
            handle_queue.insert(new_idx, texture);

            debug!("New Tex @{}", new_idx);
        });
    }

    /// System: using the keys 0-9, swap the current texture to that idx.
    pub fn swap_tex_to_idx_2d(
        mut key_evr: EventReader<KeyboardInput>,
        shader_hndl: Query<&Handle<YourShader2D>>,
        mut shader_mat: ResMut<Assets<YourShader2D>>,
        user_textures: Res<TexHandleQueue>,
        // mut shader_mat_3d: ResMut<Assets<YourShader>>, // FIXME: Support this.
    ) {
        let Ok(handle) = shader_hndl.get_single() else {
            return;
        };
        if let Some(shad_mat) = shader_mat.get_mut(handle) {
            for ev in key_evr.iter() {
                match ev.state {
                    ButtonState::Pressed => {
                        debug!("{:?} pressed, moving to that Tex idx.", ev.key_code);
                        match ev.key_code {
                            Some(v) => match v {
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
                                _ => return,
                            },
                            _ => return,
                        };
                    }
                    _ => return,
                }
            }
        }
    }
}
