use bevy::input::keyboard::KeyboardInput;
use bevy::input::ButtonState;
use bevy::prelude::*;

use crate::prelude::*;

/// Implement this on your own shaders you create, should you want them to take advantage of the texture updater system(s).
/// It's exteremly easy to do, just see the examples in `src/texture_tooling.rs`
pub trait SetNewTexture {
    type ShaderTarget;
    /// Helper to set/override the current texture on the currently active shader
    fn set_current_tex(
        shader_mat: &mut Self::ShaderTarget,
        idx: usize,
        user_added_textures: &TexHandleQueue,
    );
}

//-----------3D----------//
impl SetNewTexture for YourShader {
    type ShaderTarget = YourShader;

    fn set_current_tex(
        shader_mat: &mut Self::ShaderTarget,
        idx: usize,
        user_added_textures: &TexHandleQueue,
    ) {
        let Some(new_tex) = user_added_textures.0.get(&idx) else {
            let num_texs = user_added_textures.0.len();
            error!("No handle, it could still be loading your texture into the ECS!\nThere are currently {}, textures available on keys 0..{}",
                num_texs, num_texs.min(9));

            return;
        };
        shader_mat.img = new_tex.clone(); // Cloning handles is fine.
    }
}

pub fn swap_3d_tex_from_idx(
    mut key_evr: EventReader<KeyboardInput>,
    mut shader_mat3d: ResMut<Assets<YourShader>>,
    user_textures: Res<TexHandleQueue>,
) {
    // Iterate over all `YourShader` assets
    if let Some((_, shad_mat)) = shader_mat3d.iter_mut().next() {
        key_evr.read().for_each(|ev| {
            if let ButtonState::Pressed = ev.state {
                match ev.key_code {
                    KeyCode::Digit0 => YourShader::set_current_tex(shad_mat, 0, &user_textures),
                    KeyCode::Digit1 => YourShader::set_current_tex(shad_mat, 1, &user_textures),
                    KeyCode::Digit2 => YourShader::set_current_tex(shad_mat, 2, &user_textures),
                    KeyCode::Digit3 => YourShader::set_current_tex(shad_mat, 3, &user_textures),
                    KeyCode::Digit4 => YourShader::set_current_tex(shad_mat, 4, &user_textures),
                    KeyCode::Digit5 => YourShader::set_current_tex(shad_mat, 5, &user_textures),
                    KeyCode::Digit6 => YourShader::set_current_tex(shad_mat, 6, &user_textures),
                    KeyCode::Digit7 => YourShader::set_current_tex(shad_mat, 7, &user_textures),
                    KeyCode::Digit8 => YourShader::set_current_tex(shad_mat, 8, &user_textures),
                    KeyCode::Digit9 => YourShader::set_current_tex(shad_mat, 9, &user_textures),
                    _ => (),
                }
            }
        });
        return;
    }
}

//-----------2D----------//
impl SetNewTexture for YourShader2D {
    type ShaderTarget = YourShader2D;

    fn set_current_tex(
        shader_mat: &mut Self::ShaderTarget,
        idx: usize,
        user_added_textures: &TexHandleQueue,
    ) {
        let Some(new_tex) = user_added_textures.0.get(&idx) else {
            error!("Expected a texture at idx: {}, but none was found.", idx);
            let num_texs = user_added_textures.0.len();
            error!("No handle, it could still be loading your texture into the ECS!\nThere are currently {}, textures available on keys 0..{}",
                num_texs, num_texs.min(9));

            return;
        };
        shader_mat.img = new_tex.clone(); // Cloning handles is fine.

        #[cfg(debug_assertions)]
        debug!("Should be set to {}", idx);
    }
}

pub fn swap_2d_tex_from_idx(
    mut key_evr: EventReader<KeyboardInput>,
    mut shader_mat2d: ResMut<Assets<YourShader2D>>,
    user_textures: Res<TexHandleQueue>,
) {
    if let Some((_, shad_mat)) = shader_mat2d.iter_mut().next() {
        key_evr.read().for_each(|ev| {
            if let ButtonState::Pressed = ev.state {
                match ev.key_code {
                    KeyCode::Digit1 => YourShader2D::set_current_tex(shad_mat, 1, &user_textures),
                    KeyCode::Digit2 => YourShader2D::set_current_tex(shad_mat, 2, &user_textures),
                    KeyCode::Digit3 => YourShader2D::set_current_tex(shad_mat, 3, &user_textures),
                    KeyCode::Digit4 => YourShader2D::set_current_tex(shad_mat, 4, &user_textures),
                    KeyCode::Digit5 => YourShader2D::set_current_tex(shad_mat, 5, &user_textures),
                    KeyCode::Digit6 => YourShader2D::set_current_tex(shad_mat, 6, &user_textures),
                    KeyCode::Digit7 => YourShader2D::set_current_tex(shad_mat, 7, &user_textures),
                    KeyCode::Digit8 => YourShader2D::set_current_tex(shad_mat, 8, &user_textures),
                    KeyCode::Digit9 => YourShader2D::set_current_tex(shad_mat, 9, &user_textures),
                    KeyCode::Digit0 => YourShader2D::set_current_tex(shad_mat, 0, &user_textures),
                    _ => (),
                }
            }
        });
        return;
    }
}
