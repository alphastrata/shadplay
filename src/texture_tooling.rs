use bevy::prelude::*;

use crate::drag_n_drop::TexHandleQueue;
use crate::shader_utils::YourShader;
use crate::shader_utils::YourShader2D;

/// Implement this on your own shaders you create, should you want them to take advantage of the texture updater system(s).
/// It's exteremly easy to do.
///```rust
///impl SetNewTexture for YourShader {
///    type ShaderTarget = YourShader;
///}
///```
pub trait SetNewTexture {
    type ShaderTarget;

    /// Helper to set/override the current texture on the currently active shader
    fn set_current_tex(
        shader_mat: &mut YourShader2D,
        idx: usize,
        user_added_textures: &TexHandleQueue,
    ) {
        let Some(new_tex) = user_added_textures.0.get(&idx) else {
            error!("Expected a texture at idx: {}, but none was found.", idx);
            return;
        };
        shader_mat.img = new_tex.clone(); // Cloning handles is fine.
    }
}

impl SetNewTexture for YourShader {
    type ShaderTarget = YourShader;
}

impl SetNewTexture for YourShader2D {
    type ShaderTarget = YourShader2D;
}
