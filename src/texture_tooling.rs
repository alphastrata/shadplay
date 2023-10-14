use bevy::input::keyboard::KeyboardInput;
use bevy::input::ButtonState;
use bevy::prelude::*;

use crate::drag_n_drop::TexHandleQueue;
use crate::shader_utils::YourShader;
use crate::shader_utils::YourShader2D;

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

impl SetNewTexture for YourShader {
    type ShaderTarget = YourShader;

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
    }
}

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
    }
}

// /// System: using the keys 0-9, swap the current texture to that idx.
// pub fn swap_2D_tex_from_idx(
//     mut key_evr: EventReader<KeyboardInput>,
//     shader_hndl: Query<&Handle<YourShader2D>>,
//     mut shader_mat2d: ResMut<Assets<YourShader2D>>,
//     user_textures: Res<TexHandleQueue>,
// ) {
//     let Ok(handle) = shader_hndl.get_single() else {
//         error!("TODO!");
//         return;
//     };

//     if let Some(shad_mat) = shader_mat2d.get_mut(handle) {
//         key_evr.iter().for_each(|ev| {
//             if let ButtonState::Pressed = ev.state {
//                 if let Some(v) = ev.key_code {
//                     match v {
//                         KeyCode::Key1 => YourShader2D::set_current_tex(shad_mat, 1, &user_textures),
//                         KeyCode::Key2 => YourShader2D::set_current_tex(shad_mat, 2, &user_textures),
//                         KeyCode::Key3 => YourShader2D::set_current_tex(shad_mat, 3, &user_textures),
//                         KeyCode::Key4 => YourShader2D::set_current_tex(shad_mat, 4, &user_textures),
//                         KeyCode::Key5 => YourShader2D::set_current_tex(shad_mat, 5, &user_textures),
//                         KeyCode::Key6 => YourShader2D::set_current_tex(shad_mat, 6, &user_textures),
//                         KeyCode::Key7 => YourShader2D::set_current_tex(shad_mat, 7, &user_textures),
//                         KeyCode::Key8 => YourShader2D::set_current_tex(shad_mat, 8, &user_textures),
//                         KeyCode::Key9 => YourShader2D::set_current_tex(shad_mat, 9, &user_textures),
//                         KeyCode::Key0 => YourShader2D::set_current_tex(shad_mat, 0, &user_textures),
//                         _ => (),
//                     }
//                 }
//             }
//         });
//     }
// }

// pub fn swap_2D_tex_from_idx(
//     mut key_evr: EventReader<KeyboardInput>,
//     shader_hndl: Query<&Handle<YourShader2D>>,
//     mut shader_mat2d: ResMut<Assets<YourShader2D>>,
//     user_textures: Res<TexHandleQueue>,
// ) {
//     let Ok(handle) = shader_hndl.get_single() else {
//         error!("TODO!");
//         return;
//     };

//     if let Some(shad_mat) = shader_mat2d.get_mut(handle) {
//         key_evr.iter().for_each(|ev| {
//             if let ButtonState::Pressed = ev.state {
//                 if let Some(v) = ev.key_code {
//                     match v {
//                         KeyCode::Key1 => YourShader2D::set_current_tex(shad_mat, 1, &user_textures),
//                         KeyCode::Key2 => YourShader2D::set_current_tex(shad_mat, 2, &user_textures),
//                         KeyCode::Key3 => YourShader2D::set_current_tex(shad_mat, 3, &user_textures),
//                         KeyCode::Key4 => YourShader2D::set_current_tex(shad_mat, 4, &user_textures),
//                         KeyCode::Key5 => YourShader2D::set_current_tex(shad_mat, 5, &user_textures),
//                         KeyCode::Key6 => YourShader2D::set_current_tex(shad_mat, 6, &user_textures),
//                         KeyCode::Key7 => YourShader2D::set_current_tex(shad_mat, 7, &user_textures),
//                         KeyCode::Key8 => YourShader2D::set_current_tex(shad_mat, 8, &user_textures),
//                         KeyCode::Key9 => YourShader2D::set_current_tex(shad_mat, 9, &user_textures),
//                         KeyCode::Key0 => YourShader2D::set_current_tex(shad_mat, 0, &user_textures),
//                         _ => (),
//                     }
//                 }
//             }
//         });
//     }
// }

#[macro_export]
macro_rules! impl_swap_from_idx {
    ($function_name:ident, $shader:ident) => {
        pub fn $function_name(
            mut key_evr: EventReader<KeyboardInput>,
            shader_hndl: Query<&Handle<$shader>>,
            mut shader_mat: ResMut<Assets<$shader>>,
            user_textures: Res<TexHandleQueue>,
        ) {
            let Ok(handle) = shader_hndl.get_single() else {
                error!("Unable to get Handle to the current shader.");
                return;
            };

            if let Some(shad_mat) = shader_mat.get_mut(handle) {
                key_evr.iter().for_each(|ev| {
                    if let ButtonState::Pressed = ev.state {
                        if let Some(v) = ev.key_code {
                            match v {
                                KeyCode::Key1 => {
                                    $shader::set_current_tex(shad_mat, 1, &user_textures)
                                }
                                KeyCode::Key2 => {
                                    $shader::set_current_tex(shad_mat, 2, &user_textures)
                                }
                                KeyCode::Key3 => {
                                    $shader::set_current_tex(shad_mat, 3, &user_textures)
                                }
                                KeyCode::Key4 => {
                                    $shader::set_current_tex(shad_mat, 4, &user_textures)
                                }
                                KeyCode::Key5 => {
                                    $shader::set_current_tex(shad_mat, 5, &user_textures)
                                }
                                KeyCode::Key6 => {
                                    $shader::set_current_tex(shad_mat, 6, &user_textures)
                                }
                                KeyCode::Key7 => {
                                    $shader::set_current_tex(shad_mat, 7, &user_textures)
                                }
                                KeyCode::Key8 => {
                                    $shader::set_current_tex(shad_mat, 8, &user_textures)
                                }
                                KeyCode::Key9 => {
                                    $shader::set_current_tex(shad_mat, 9, &user_textures)
                                }
                                KeyCode::Key0 => {
                                    $shader::set_current_tex(shad_mat, 0, &user_textures)
                                }
                                _ => (),
                            }
                        }
                    }
                });
            }
        }
    };
}

impl_swap_from_idx!(swap_2d_tex_from_idx, YourShader2D);
impl_swap_from_idx!(swap_3d_tex_from_idx, YourShader);
