use bevy::input::ButtonState;
use bevy::input::keyboard::KeyboardInput;
use bevy::prelude::*;
use crate::prelude::*;

pub trait SetNewTexture {
    type ShaderTarget;
    fn set_current_tex(shader_mat: &mut Self::ShaderTarget, idx: usize, user_added_textures: &TexHandleQueue);
}

impl SetNewTexture for YourShader {
    type ShaderTarget = YourShader;
    fn set_current_tex(shader_mat: &mut Self::ShaderTarget, idx: usize, user_added_textures: &TexHandleQueue) {
        let Some(new_tex) = user_added_textures.0.get(&idx) else {
            error!("No handle at idx: {}. {} textures available on keys 0..{}", idx, user_added_textures.0.len(), user_added_textures.0.len().min(9));
            return;
        };
        shader_mat.img = new_tex.clone();
    }
}

pub fn swap_3d_tex_from_idx(
    mut key_evr: MessageReader<KeyboardInput>,
    mut shader_mat3d: ResMut<Assets<YourShader>>,
    user_textures: Res<TexHandleQueue>,
) {
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
    }
}

impl SetNewTexture for YourShader2D {
    type ShaderTarget = YourShader2D;
    fn set_current_tex(shader_mat: &mut Self::ShaderTarget, idx: usize, user_added_textures: &TexHandleQueue) {
        let Some(new_tex) = user_added_textures.0.get(&idx) else {
            error!("No handle at idx: {}. {} textures available on keys 0..{}", idx, user_added_textures.0.len(), user_added_textures.0.len().min(9));
            return;
        };
        shader_mat.img = new_tex.clone();
    }
}

pub fn swap_2d_tex_from_idx(
    mut key_evr: MessageReader<KeyboardInput>,
    mut shader_mat2d: ResMut<Assets<YourShader2D>>,
    user_textures: Res<TexHandleQueue>,
) {
    if let Some((_, shad_mat)) = shader_mat2d.iter_mut().next() {
        key_evr.read().for_each(|ev| {
            if let ButtonState::Pressed = ev.state {
                match ev.key_code {
                    KeyCode::Digit0 => YourShader2D::set_current_tex(shad_mat, 0, &user_textures),
                    KeyCode::Digit1 => YourShader2D::set_current_tex(shad_mat, 1, &user_textures),
                    KeyCode::Digit2 => YourShader2D::set_current_tex(shad_mat, 2, &user_textures),
                    KeyCode::Digit3 => YourShader2D::set_current_tex(shad_mat, 3, &user_textures),
                    KeyCode::Digit4 => YourShader2D::set_current_tex(shad_mat, 4, &user_textures),
                    KeyCode::Digit5 => YourShader2D::set_current_tex(shad_mat, 5, &user_textures),
                    KeyCode::Digit6 => YourShader2D::set_current_tex(shad_mat, 6, &user_textures),
                    KeyCode::Digit7 => YourShader2D::set_current_tex(shad_mat, 7, &user_textures),
                    KeyCode::Digit8 => YourShader2D::set_current_tex(shad_mat, 8, &user_textures),
                    KeyCode::Digit9 => YourShader2D::set_current_tex(shad_mat, 9, &user_textures),
                    _ => (),
                }
            }
        });
    }
}
