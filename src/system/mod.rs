use bevy::{
    prelude::*, render::view::screenshot::Capturing, window::SystemCursorIcon,
    winit::cursor::CursorIcon,
};
use chrono::{Datelike, Local, Timelike};
use std::{fs, path::Path};

pub mod clipboard;
pub mod config;
pub mod drag_n_drop;
pub mod gif_maker;
pub mod screenshot;

pub struct ScreenshotPlugin;

impl Plugin for ScreenshotPlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(
            Update,
            (
                screenshot_saving,
                screenshot::screenshot_and_version_shader_on_spacebar,
            ),
        );

        app.add_plugins(gif_maker::GifMakerPlugin);
    }
}

fn screenshot_saving(
    mut commands: Commands,
    screenshot_saving: Query<Entity, With<Capturing>>,
    window: Single<Entity, With<Window>>,
) {
    match screenshot_saving.iter().count() {
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
}

// ---------------------------------------------
// FILESYSTEM HELPERS:
// ---------------------------------------------

/// Make every file/dir etc required from a given `p`:
pub fn make_all<P>(p: P) -> Result<(), std::io::Error>
where
    P: AsRef<Path>,
{
    let path = p.as_ref();
    if path.is_dir() {
        return Ok(());
    }

    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent)?;
    }

    if path.extension().is_none() {
        fs::create_dir(path)?;
    } else {
        fs::File::create(path)?;
    }

    Ok(())
}

/// Provides a String of hh-mm-ss_dd-mm-yy timestamp.
pub fn timestamper() -> String {
    let local = Local::now();
    let hour = local.hour();
    let minute = local.minute();
    let second = local.second();

    format!("{:02}-{:02}-{:02}", hour, minute, second)
}

/// dd-mm-yy as a String.
pub fn today() -> String {
    let local = Local::now();
    let day = local.day();
    let month = local.month();
    let year = local.year() % 100;

    format!("{:02}-{:02}-{:02}", day, month, year)
}

/// Grabs the `asssets/shaders/myshader.wgsl` and versions it with your screengrab.
pub fn version_current_shader(source: &Path, target: &Path) {
    let mut target_adjusted = target.to_path_buf();
    target_adjusted.set_extension("wgsl");

    if let Err(e) = fs::copy(source, &target_adjusted) {
        error!("versioning shader failed with error:{}", e);
        error!("source file: {}", source.display());
        error!("target file: {}", target.display());
    }
}
