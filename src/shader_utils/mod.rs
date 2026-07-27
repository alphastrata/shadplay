use bevy::{prelude::*, reflect::TypePath, render::render_resource::*, sprite_render::Material2d, shader::ShaderRef};
use std::path::PathBuf;

pub mod common;
pub mod texture_tooling;

#[derive(Event, Message, Debug, Deref, DerefMut)]
pub struct DragNDropShader {
    pub path: PathBuf,
}

#[derive(Asset, AsBindGroup, TypePath, Debug, Clone)]
pub struct YourShader {
    #[uniform(100)]
    pub color: LinearRgba,
    #[texture(101, dimension = "2d")]
    #[sampler(102)]
    pub img: Handle<Image>,
}

impl Material for YourShader {
    fn fragment_shader() -> ShaderRef {
        "shaders/myshader.wgsl".into()
    }
}

#[derive(Asset, AsBindGroup, TypePath, Debug, Clone)]
pub struct YourShader2D {
    #[uniform(0)]
    pub(crate) mouse_pos: MousePos,
    #[texture(1, dimension = "2d")]
    #[sampler(2)]
    pub img: Handle<Image>,
}

#[derive(ShaderType, Debug, Clone)]
pub struct MousePos {
    pub x: f32,
    pub y: f32,
}

impl Material2d for YourShader2D {
    fn fragment_shader() -> ShaderRef {
        "shaders/myshader_2d.wgsl".into()
    }
}

#[derive(Asset, AsBindGroup, TypePath, Debug, Clone)]
#[expect(dead_code)]
struct DottedLineShader {
    #[uniform(100)]
    uniforms: Holder,
}

#[derive(ShaderType, Default, Clone, Debug)]
struct Holder {
    tint: LinearRgba,
    line_width: f32,
    segments: f32,
    phase: f32,
    line_spacing: f32,
}

impl Material for DottedLineShader {
    fn fragment_shader() -> ShaderRef {
        "shaders/dotted_line.wgsl".into()
    }
}
