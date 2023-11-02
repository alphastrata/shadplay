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
            error!("No handle, it could still be loading your texture into the ECS!");
            return;
        };
        shader_mat.img = new_tex.clone(); // Cloning handles is fine.
    }
}

pub fn swap_3d_tex_from_idx(
    mut key_evr: EventReader<KeyboardInput>,
    shader_hndl: Query<&Handle<YourShader>>,
    mut shader_mat3d: ResMut<Assets<YourShader>>,
    user_textures: Res<TexHandleQueue>,
) {
    let Ok(handle) = shader_hndl.get_single() else {
        error!("No handle, it could still be loading your texture into the ECS!");
        return;
    };

    if let Some(shad_mat) = shader_mat3d.get_mut(handle) {
        key_evr.iter().for_each(|ev| {
            if let ButtonState::Pressed = ev.state {
                if let Some(v) = ev.key_code {
                    match v {
                        KeyCode::Key0 => YourShader::set_current_tex(shad_mat, 0, &user_textures),
                        KeyCode::Key1 => YourShader::set_current_tex(shad_mat, 1, &user_textures),
                        KeyCode::Key2 => YourShader::set_current_tex(shad_mat, 1, &user_textures),
                        KeyCode::Key3 => YourShader::set_current_tex(shad_mat, 3, &user_textures),
                        KeyCode::Key4 => YourShader::set_current_tex(shad_mat, 4, &user_textures),
                        KeyCode::Key5 => YourShader::set_current_tex(shad_mat, 5, &user_textures),
                        KeyCode::Key6 => YourShader::set_current_tex(shad_mat, 6, &user_textures),
                        KeyCode::Key7 => YourShader::set_current_tex(shad_mat, 7, &user_textures),
                        KeyCode::Key8 => YourShader::set_current_tex(shad_mat, 8, &user_textures),
                        KeyCode::Key9 => YourShader::set_current_tex(shad_mat, 9, &user_textures),
                        _ => (),
                    }
                }
            }
        });
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
            return;
        };
        shader_mat.img = new_tex.clone(); // Cloning handles is fine.

        #[cfg(debug_assertions)]
        debug!("Should be set to {}", idx);
    }
}

pub fn swap_2d_tex_from_idx(
    mut key_evr: EventReader<KeyboardInput>,
    shader_hndl: Query<&Handle<YourShader2D>>,
    mut shader_mat2d: ResMut<Assets<YourShader2D>>,
    user_textures: Res<TexHandleQueue>,
) {
    let Ok(handle) = shader_hndl.get_single() else {
        error!("No handle, it could still be loading your texture into the ECS!");
        return;
    };

    if let Some(shad_mat) = shader_mat2d.get_mut(handle) {
        key_evr.iter().for_each(|ev| {
            if let ButtonState::Pressed = ev.state {
                if let Some(v) = ev.key_code {
                    match v {
                        KeyCode::Key1 => YourShader2D::set_current_tex(shad_mat, 1, &user_textures),
                        KeyCode::Key2 => YourShader2D::set_current_tex(shad_mat, 2, &user_textures),
                        KeyCode::Key3 => YourShader2D::set_current_tex(shad_mat, 3, &user_textures),
                        KeyCode::Key4 => YourShader2D::set_current_tex(shad_mat, 4, &user_textures),
                        KeyCode::Key5 => YourShader2D::set_current_tex(shad_mat, 5, &user_textures),
                        KeyCode::Key6 => YourShader2D::set_current_tex(shad_mat, 6, &user_textures),
                        KeyCode::Key7 => YourShader2D::set_current_tex(shad_mat, 7, &user_textures),
                        KeyCode::Key8 => YourShader2D::set_current_tex(shad_mat, 8, &user_textures),
                        KeyCode::Key9 => YourShader2D::set_current_tex(shad_mat, 9, &user_textures),
                        KeyCode::Key0 => YourShader2D::set_current_tex(shad_mat, 0, &user_textures),
                        _ => (),
                    }
                }
            }
        });
    }
}
