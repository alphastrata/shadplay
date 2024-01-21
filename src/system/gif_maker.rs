#![allow(unused_imports)]
use bevy::prelude::*;
use bevy::render::render_resource::{
    Extent3d, TextureDescriptor, TextureDimension, TextureFormat, TextureUsages,
};
use bevy::render::view::screenshot::ScreenshotManager;

use bevy::render::view::RenderLayers;
use bevy::window::WindowResized;

pub struct GifMakerPlugin;

impl Plugin for GifMakerPlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(Startup, setup);

        app.add_systems(
            Update,
            size_gif_capture_surface.run_if(on_event::<WindowResized>()),
        );
    }
}
/// Saves a screenshot continiously for ten seconds should you hit `return`.
/// Giving you something like this:
///```shell
/// screenshots
///└──  tmp
///    ├──  0001.png
///    ├──  0002.png
///    ├──  0003.png
///    ... etc
///```
pub fn setup(
    // input: Res<Input<KeyCode>>,
    mut user_config: ResMut<super::config::UserConfig>,
    // mut screenshot_manager: ResMut<ScreenshotManager>,
    mut images: ResMut<Assets<Image>>,
) {
    let (width, height) = user_config.window_dims;
    let size = Extent3d {
        width: width as u32,
        height: height as u32,
        ..default()
    };

    let mut image = Image {
        texture_descriptor: TextureDescriptor {
            label: None,
            size,
            dimension: TextureDimension::D2,
            format: TextureFormat::Bgra8UnormSrgb,
            mip_level_count: 1,
            sample_count: 1,
            usage: TextureUsages::TEXTURE_BINDING
                | TextureUsages::COPY_DST
                | TextureUsages::RENDER_ATTACHMENT,
            view_formats: &[],
        },
        ..default()
    };

    image.resize(size);
    let image_handle = images.add(image);

    user_config.gif_capture_surface = Some(image_handle);

    // let gif_capture_pass = RenderLayers::layer(1);
}

pub fn size_gif_capture_surface(
    user_config: Res<super::config::UserConfig>,
    // mut screenshot_manager: ResMut<ScreenshotManager>,
    mut images: ResMut<Assets<Image>>,
) {
    let (width, height) = user_config.window_dims;

    let Some(ref handle) = user_config.gif_capture_surface else {
        return;
    };

    let Some(im) = images.get_mut(handle) else {
        return;
    };

    let size = Extent3d {
        width: width as u32,
        height: height as u32,
        ..default()
    };

    im.resize(size);
}
