#![allow(unused_imports)]
use bevy::render::camera::RenderTarget;
use bevy::render::render_resource::{
    Extent3d, TextureDescriptor, TextureDimension, TextureFormat, TextureUsages,
};
use bevy::render::view::screenshot::ScreenshotManager;
use bevy::{log, prelude::*};

use bevy::render::view::RenderLayers;
use bevy::window::{PrimaryWindow, WindowResized};

/// Because RenderTarget ! PartialOrd, so you cannot slap it into our UserConfig ><
#[derive(Resource, Default, Deref, DerefMut)]
struct RenderTargetHolster {
    inner: Option<RenderTarget>,
}

/// Plugin:
/// Housing everything we need to make gifs on `return`
pub struct GifMakerPlugin;

impl Plugin for GifMakerPlugin {
    fn build(&self, app: &mut App) {
        app.insert_resource(RenderTargetHolster::default());

        // Limit timestep we can snap for our gif to 10 FPS
        app.insert_resource(Time::<Fixed>::from_seconds(0.01));

        app.add_systems(PostStartup, setup);

        app.add_systems(
            Update,
            size_gif_capture_surface.run_if(on_event::<WindowResized>()),
        );
    }
}

/// Inits the scratch surface for `gif_capture_surface` we're going to retarget a camera at.
fn setup(mut user_config: ResMut<super::config::UserSession>, mut images: ResMut<Assets<Image>>) {
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

    user_config.gif_buffer = Some(image_handle);
    // let gif_capture_pass = RenderLayers::layer(1);
}

/// Ensures that our `gif_capture_surface` is always the right resolution.
pub fn size_gif_capture_surface(
    user_config: Res<super::config::UserSession>,
    // mut screenshot_manager: ResMut<ScreenshotManager>,
    mut images: ResMut<Assets<Image>>,
) {
    let (width, height) = user_config.window_dims;

    let Some(ref handle) = user_config.gif_buffer else {
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

/// Moves our RenderTarget into gif mode.
fn retarget_2_gif_surface(
    gif_target: Res<super::config::UserSession>,
    mut render_target_holster: ResMut<RenderTargetHolster>,
    mut q: Query<(Entity, &mut Camera)>,
) {
    q.iter_mut().for_each(|(_ent, mut cam)| {
        let Some(ref rt) = gif_target.gif_buffer else {
            log::error!("Unable to get a Handle<Image> that we can swap RenderTarget too.");
            return;
        };
        (*render_target_holster) = RenderTargetHolster {
            inner: Some(cam.target.clone()),
        };
        cam.target = RenderTarget::Image(rt.clone());
    });
}

/// Restores our RenderTarget from gif mode back to regular.
fn retarget_2_window(rth: Res<RenderTargetHolster>, mut q: Query<(Entity, &mut Camera)>) {
    q.iter_mut().for_each(|(_ent, mut cam)| {
        cam.target = rth.clone().unwrap();
    });
}
