use bevy::{
    prelude::*,
    reflect::{TypePath, TypeUuid},
    render::render_resource::*,
};

#[derive(AsBindGroup, TypeUuid, TypePath, Debug, Clone)]
#[uuid = "a3d71c04-d054-4946-80f8-ba6cfbc90cad"]
pub struct YourShader {
    #[uniform(0)]
    pub color: Color, //RGBA
}

impl Material for YourShader {
    fn fragment_shader() -> ShaderRef {
        "shaders/myshader.wgsl".into()
    }
}
