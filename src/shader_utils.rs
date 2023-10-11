//!
//! Most of the boilerplate to make a custom shader work lives here.
//!
use bevy::{
    prelude::*,
    reflect::{TypePath, TypeUuid},
    render::render_resource::*,
    sprite::Material2d,
    window::PrimaryWindow,
};

use crate::utils::MaxScreenDims;

pub mod common;

// ************************************ //
//                3D                    //
// ************************************ //
/// The 3D shader.
#[derive(AsBindGroup, TypeUuid, TypePath, Debug, Clone)]
#[uuid = "a3d71c04-d054-4946-80f8-ba6cfbc90cad"]
pub struct YourShader {
    #[uniform(0)]
    pub color: Color, //RGBA
}
// 3d impl
impl Material for YourShader {
    fn fragment_shader() -> ShaderRef {
        "shaders/myshader.wgsl".into()
    }
}

// ************************************ //
//                2D                    //
// ************************************ //
/// The 2D shadertoy like shader
#[derive(AsBindGroup, TypeUuid, TypePath, Debug, Clone)]
#[uuid = "f528511f-dcf2-4b0b-9522-a9df3a1a795b"]
pub struct YourShader2D {
    /// Mouse X and Mouse Y
    #[uniform(0)]
    pub(crate) mouse_pos: MousePos,
    // /// to replicate iChannel
    #[texture(1, dimension = "2d")]
    #[sampler(2)]
    pub img: Handle<Image>,
}

#[derive(ShaderType, Debug, Clone)]
pub struct MousePos {
    #[align(16)]
    pub x: f32,
    #[align(16)]
    pub y: f32,
}

impl Material2d for YourShader2D {
    fn fragment_shader() -> ShaderRef {
        "shaders/myshader_2d.wgsl".into()
    }
}

/// Update mouse_pos for the 2D shader
pub fn update_mouse_pos(
    // mut meshes: ResMut<Assets<Mesh>>,
    // mut query: Query<(&mut Handle<YourShader2D>, Entity, With<BillBoardQuad>)>,
    shader_hndl: Query<&Handle<YourShader2D>>,
    // meshes: Query<Entity, With<BillBoardQuad>>,
    mouse_pos: Query<&Window, With<PrimaryWindow>>,
    mut shader_mat: ResMut<Assets<YourShader2D>>,
    msd: Res<MaxScreenDims>,
) {
    if let Some(mouse_xy) = mouse_pos.single().physical_cursor_position() {
        let Ok(handle) = shader_hndl.get_single() else {
            return;
        };
        // TODO: fix the normalisation of the mouse coords to match the screen ones.
        /* From the bevy cheatbook
        The origin is at the top left corner of the screen
        The Y axis points downwards
        X goes from 0.0 (left screen edge) to the number of screen pixels (right screen edge)
        Y goes from 0.0 (top screen edge) to the number of screen pixels (bottom screen edge)

        */
        if let Some(shad_mat) = shader_mat.get_mut(handle) {
            let n_w = (msd.0.x / 3880.0) - 0.5;
            let n_h = (msd.0.y / 1600.0) - 0.5;

            let x = (((msd.0.x - (msd.0.x * 0.5)) / mouse_xy.x) - 0.5).clamp(-0.5, 0.5);
            let y = (((msd.0.y * 0.5) / mouse_xy.y) - 0.5).clamp(-0.5, 0.5);

            //DEBUG
            //FIXME: remove these after above todo is taken care of.
            // println!("MSD\t     x:{}, y:{}", msd.0.x, msd.0.y);
            // println!("nhw\t     x:{}, y:{}", n_w, n_h);
            // println!(
            //     "Shader mouse x:{}, y:{}\nmade to   x:{:?} y:{:?}",
            //     &mouse_xy.x, &mouse_xy.y, x, y
            // );
            shad_mat.mouse_pos = MousePos { x, y };
        } else {
            return;
        }
    } else {
        return;
    }
}

// ---- ---- ---- ---- ---- ---- ---- ---- ----
// For an example of how you can pass larger ammounts of data from bevy -> yourshadercode
// You need to use this sort of structure, for example with the dotted_line.wgsl shader.
// ---- ---- ---- ---- ---- ---- ---- ---- ----
// dotted-line
#[derive(AsBindGroup, TypeUuid, TypePath, Debug, Clone)]
#[uuid = "c74e039a-3df7-4f71-bd1d-7fe4b25a2230"]
struct DottedLineShader {
    #[uniform(0)]
    uniforms: Holder, //RGBA
}

/// Simplified holding struct to make passing across uniform(n) simpler.
#[derive(ShaderType, Default, Clone, Debug)]
struct Holder {
    tint: Color,
    /// How wide do you want the line as a % of its availablu uv space: 0.5 would be 50% of the surface of the geometry
    line_width: f32,
    /// How many segments (transparent 'cuts') do you want?
    segments: f32,
    /// How fast do you want the animation to be? set 0.0 to disable.
    phase: f32,
    /// How far spaced apart do you want these lines?
    line_spacing: f32,
}

impl Material for DottedLineShader {
    fn fragment_shader() -> ShaderRef {
        "shaders/dotted_line.wgsl".into()
    }
}
