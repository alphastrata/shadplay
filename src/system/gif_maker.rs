#![allow(unused_imports)]
use bevy::input::keyboard::KeyboardInput;
use bevy::render::camera::RenderTarget;
use bevy::render::render_resource::{
    Extent3d, TextureDescriptor, TextureDimension, TextureFormat, TextureUsages,
};
use bevy::{
    log,
    prelude::*,
    render::view::screenshot::{Capturing, Screenshot, save_to_disk},
    window::SystemCursorIcon,
    winit::cursor::CursorIcon,
};

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
        let scratch_dir = std::path::PathBuf::from(".gif_scratch");
        if !scratch_dir.exists()
            && let Err(e) = std::fs::create_dir_all(&scratch_dir) {
                log::debug!("{} does not exist, creating...", scratch_dir.display());
                log::error!("{e}");
            }

        app.insert_resource(Shooting(false));
        app.add_systems(Update, gif_capture_toggle.run_if(on_event::<KeyboardInput>));

        // Limit timestep we can snap for our gif to 20 FPS
        app.insert_resource(Time::<Fixed>::from_seconds(0.05));
        app.add_systems(
            FixedUpdate,
            (continous_capture.run_if(resource_exists_and_equals(Shooting(true))),),
        );
    }
}

fn gif_capture_toggle(input: Res<ButtonInput<KeyCode>>, mut shooting: ResMut<Shooting>) {
    if input.just_pressed(KeyCode::Enter) {
        *shooting = Shooting(!shooting.0);
    }
}

fn continous_capture(
    screenshot_mngr: Query<Entity, With<Capturing>>,
    // mut captures: Local<Vec<Image>>,
    mut n: Local<usize>,
    mut commands: Commands,
    window: Single<Entity, With<Window>>,
) {
    match screenshot_mngr.iter().count() {
        0 => {
            commands.entity(*window).remove::<CursorIcon>();
        }
        x if x > 0 => {
            commands
                .entity(*window)
                .insert(CursorIcon::from(SystemCursorIcon::Progress));
        }
        _ => {}
    }

    *n += 1;
    let path = format!(".gif_scratch/im_{:04}.png", *n + 1);

    commands
        .spawn(Screenshot::primary_window())
        .observe(save_to_disk(path));
}
