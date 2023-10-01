use std::fs;
use std::path::Path;
use std::path::PathBuf;

use bevy::prelude::*;
use bevy::render::view::screenshot::ScreenshotManager;
use bevy::window::PrimaryWindow;
use chrono::{Datelike, Local, Timelike};

const DEFAULT_SHADER: &str = "assets/shaders/myshader.wgsl";

/// Saves a screenshot && versions the shader (from [`DEFAULT_SHADER`]) that was active when screenshotting.
/// giving you something like this:
///```shell
/// screenshots
///└──  01-2-23
///    └──  09-23-29
///        ├──  screeenshot.png
///        └──  screeenshot.wgsl
///```
pub fn screenshot_and_version_shader_on_spacebar(
    input: Res<Input<KeyCode>>,
    main_window: Query<Entity, With<PrimaryWindow>>,
    mut screenshot_manager: ResMut<ScreenshotManager>,
) {
    if input.just_pressed(KeyCode::Space) {
        let target = PathBuf::from(format!(
            "screenshots/{}/{}/screeenshot.png",
            today(),
            timestamper()
        ));
        if let Err(e) = make_all(&target) {
            error!("make_all failed: {}", e);
        }

        match screenshot_manager.save_screenshot_to_disk(main_window.single(), &target) {
            Err(e) => error!("screenshotting failed: {}", e),
            Ok(_) => {
                version_current_shader(Path::new(DEFAULT_SHADER), &target);
            }
        }
    }
}

// FILESYSTEM HELPERS:

/// Make every file/dir etc required from a given `p`:
///```rust
/// fn main() -> Result<(), Box<dyn std::error::Error>> {
///     let dir_path = "my_directory";
///     let file_path = "my_directory/my_file.txt";
///
///     // Create a directory if it doesn't exist
///     make_all(dir_path)?;
///
///     // Create a file if it doesn't exist
///     make_all(file_path)?;
///
///     Ok(())
/// }```
fn make_all<P>(p: P) -> Result<(), std::io::Error>
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
fn timestamper() -> String {
    let local = Local::now();
    let hour = local.hour();
    let minute = local.minute();
    let second = local.second();

    format!("{:02}-{:02}-{:02}", hour, minute, second)
}

fn today() -> String {
    let local = Local::now();
    let day = local.day();
    let month = local.month();
    let year = local.year() % 100;

    format!("{:02}-{:02}-{:02}", day, month, year)
}

/// Grabs the `asssets/shaders/myshader.wgsl` and versions it with your screengrab.
fn version_current_shader(source: &Path, target: &Path) {
    let mut target_adjusted = target.to_path_buf();
    target_adjusted.set_extension("wgsl");

    if let Err(e) = fs::copy(source, &target_adjusted) {
        error!("versioning shader failed with error:{}", e);
        error!("source file: {}", source.display());
        error!("target file: {}", target.display());
    }
}
