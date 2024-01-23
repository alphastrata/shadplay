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

impl Plugin for GifMakerPlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(
            Update,
            (gif_capture_toggle.run_if(on_event::<KeyboardInput>()),),
        );

        // Limit timestep we can snap for our gif to 10 FPS
        app.insert_resource(Time::<Fixed>::from_seconds(0.01));
        // Swap the render targets on Enter/Exit of GifCapture mode
        app.add_systems(OnExit(AppState::GifCapture), flush_captures);
        app.add_systems(
            FixedUpdate,
            continous_capture.run_if(in_state(AppState::GifCapture)),
        );
    }
}

fn gif_capture_toggle(
    input: Res<Input<KeyCode>>,
    mut next_state: ResMut<NextState<AppState>>,
    current_state: Res<State<AppState>>,
    mut prev_state: Local<AppState>,
) {
    if input.just_pressed(KeyCode::Return) {
        log::debug!("AppState change request.");
        let target = match current_state.get() {
            AppState::GifCapture => *prev_state,
            _ => {
                *prev_state = current_state.get().clone();
                AppState::GifCapture
            }
        };
        next_state.set(target);
    }
}

fn continous_capture(
    n: Local<usize>,
    screenshot_mngr: Res<ScreenshotManager>,
    mut captures: Local<Vec<Image>>,
) {
    todo!()
}

fn flush_captures(captures: Local<Vec<Image>>) {
    todo!()
}
