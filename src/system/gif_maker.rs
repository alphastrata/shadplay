#![allow(unused_imports)]
use bevy::input::keyboard::KeyboardInput;

use bevy::render::render_resource::{
    Extent3d, TextureDescriptor, TextureDimension, TextureFormat, TextureUsages,
};
use bevy::{
    log,
    prelude::*,
    render::view::screenshot::{Capturing, Screenshot, save_to_disk},
    window::{SystemCursorIcon, CursorIcon},
};

use bevy::window::{PrimaryWindow, WindowResized};

use crate::{prelude::AppState, system::config::UserSession};

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

        let user_config = app.world().get_resource::<UserSession>();
        let framerate = user_config.map_or(0.05, |c| c.gif_framerate);
        app.insert_resource(Time::<Fixed>::from_seconds(framerate));
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
