pub mod screenshot;
pub mod shader_utils;
pub mod ui;
pub mod utils;

pub mod drag_n_drop {
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

    /// Supported textures extensions
    static AVAILABLE_TEX_FORMATS: [&str; 3] = ["png", "jpeg", "jpg"];

    /// Listens for .png and .jpeg files dropped onto the window.
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

    /// Add the user's dropped file to our available textures
    pub fn add_dropped_file(
        // mut commands: Commands,
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
                debug!("ANY FAIL ON: {:?}", tex_path.display());
            };
            // Add texture to asset_server
            let texture: Handle<Image> = asset_server.load(tex_path.as_path());

            // get highest index
            let new_idx = handle_queue.keys().count();

            //TODO: log
            handle_queue.insert(new_idx, texture);
        });
    }
}
