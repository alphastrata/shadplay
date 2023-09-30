use bevy::prelude::*;
use bevy::render::view::screenshot::ScreenshotManager;
use bevy::window::PrimaryWindow;

pub fn screenshot_on_spacebar(
    input: Res<Input<KeyCode>>,
    main_window: Query<Entity, With<PrimaryWindow>>,
    mut screenshot_manager: ResMut<ScreenshotManager>,
) {
    if input.just_pressed(KeyCode::Space) {
        let path = format!("screenshots/{}.png", timestamper());
        match screenshot_manager.save_screenshot_to_disk(main_window.single(), path) {
            Ok(_) => {}
            Err(e) => eprintln!("{}", e),
        }
    }
}

use chrono::{Datelike, Local, Timelike};

/// Provides a String of hh-mm-ss_dd-mm-yy timestamp.
fn timestamper() -> String {
    let local = Local::now();

    let hour = local.hour();
    let minute = local.minute();
    let second = local.second();
    let day = local.day();
    let month = local.month();
    let year = local.year() % 100;

    format!(
        "{:02}-{:02}-{:02}_{:02}-{:02}-{:02}",
        hour, minute, second, day, month, year
    )
}
