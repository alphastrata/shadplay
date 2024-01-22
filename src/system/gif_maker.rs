#![allow(unused_imports)]
use bevy::prelude::*;
use bevy::render::camera::RenderTarget;
use bevy::render::render_resource::{
    Extent3d, TextureDescriptor, TextureDimension, TextureFormat, TextureUsages,
};
use bevy::render::view::screenshot::ScreenshotManager;

use bevy::render::view::RenderLayers;
use bevy::window::{PrimaryWindow, WindowResized};

/// Because RenderTarget ! PartialOrd, so you cannot slap it into our UserConfig ><
#[derive(Resource)]
struct RenderTargetHolster(Option<RenderTarget>);

/// Plugin:
/// Housing everything we need to make gifs on `return`
pub struct GifMakerPlugin;

impl Plugin for GifMakerPlugin {
    fn build(&self, app: &mut App) {
        app.insert_resource(RenderTargetHolster(None));

        app.add_systems(Startup, setup);

        app.add_systems(
            Update,
            size_gif_capture_surface.run_if(on_event::<WindowResized>()),
        );
    }
}
/// Inits the scratch surface for `gif_capture_surface` we're going to retarget a camera at.
pub fn setup(
    mut user_config: ResMut<super::config::UserConfig>,
    mut render_target_holster: ResMut<RenderTargetHolster>,
    mut images: ResMut<Assets<Image>>,
    q: Query<(Entity, &Camera)>,
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
    render_target_holster.0 = Some(
        q.get_single()
            .expect("It should be impossible not to have a RenderTarget on our Camera.")
            .1
            .target
            .clone(),
    );

    // let gif_capture_pass = RenderLayers::layer(1);
}

/// Ensures that our `gif_capture_surface` is always the right resolution.
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

fn retarget_2_gif_surface(
    target: Res<super::config::UserConfig>,
    mut q: Query<(Entity, &mut Camera)>,
) {
    q.iter_mut().for_each(|(_ent, mut cam)| {
        let Some(rt) = target.gif_capture_surface;
        cam.target = RenderTarget::Image(rt);
    });
}
fn retarget_2_window(mut q: Query<(Entity, &mut Camera)>) {}
