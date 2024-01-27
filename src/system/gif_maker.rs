#![allow(unused_imports)]
use bevy::input::keyboard::KeyboardInput;
use bevy::render::camera::RenderTarget;
use bevy::render::render_resource::{
    Extent3d, TextureDescriptor, TextureDimension, TextureFormat, TextureUsages,
};
use bevy::render::view::screenshot::ScreenshotManager;
use bevy::{log, prelude::*};

use bevy::render::view::RenderLayers;
use bevy::window::{PrimaryWindow, WindowResized};

use crate::prelude::AppState;

//NOTE: new strategy, take_screenshot exists on the screenshot manager so let's just use that pushing images into an ordered stack of images.
// On enter/exit we move into gif mode.
// the gifmode will just push into a vecdeq with capacity 100 (10 fps for 10 seconds).
// on exit we write flush that stack do disk && log the num_images and their location.

/// Plugin:
/// Housing everything we need to make gifs on `return`
pub struct GifMakerPlugin;

#[derive(Resource, PartialEq, Eq)]
pub struct Shooting(bool);

impl Plugin for GifMakerPlugin {
    fn build(&self, app: &mut App) {
        app.insert_resource(Shooting(false));
        app.add_systems(
            Update,
            (gif_capture_toggle.run_if(on_event::<KeyboardInput>()),),
        );

        // Limit timestep we can snap for our gif to 20 FPS
        app.insert_resource(Time::<Fixed>::from_seconds(0.05));
        app.add_systems(
            FixedUpdate,
            continous_capture.run_if(resource_exists_and_equals(Shooting(true))),
        );
    }
}

fn gif_capture_toggle(input: Res<Input<KeyCode>>, mut shooting: ResMut<Shooting>) {
    if input.just_pressed(KeyCode::Return) {
        *shooting = Shooting(!shooting.0);
    }
}

fn continous_capture(
    mut screenshot_mngr: ResMut<ScreenshotManager>,
    // mut captures: Local<Vec<Image>>,
    window_q: Query<Entity, With<PrimaryWindow>>,
    mut n: Local<usize>,
) {
    if let Err(e) = screenshot_mngr
        .save_screenshot_to_disk(window_q.single(), format!(".gif_scratch/{:06}.png", *n))
    {
        log::error!("{}", e);
    } else {
        *n += 1;
    }
}
