use std::path::PathBuf;
use std::thread;
use std::time::Duration;

use bevy::prelude::*;
use bevy::render::view::screenshot::ScreenshotManager;
use bevy::window::PrimaryWindow;

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
pub fn screenshot_for_10_seconds(
    input: Res<Input<KeyCode>>,
    main_window: Query<Entity, With<PrimaryWindow>>,
    mut screenshot_manager: ResMut<ScreenshotManager>,
) {
    if input.just_pressed(KeyCode::Return) {
        for i in 0..100 {
            let screenshot_path = PathBuf::from(format!(
                "screenshots/{}/{}/{}.png",
                super::today(),
                super::timestamper(),
                format!("{:08}", i) // Generates file names like 0001, 0002, etc.
            ));
            if let Err(e) = super::make_all(&screenshot_path) {
                error!("make_all failed: {}", e);
                continue;
            }

            match screenshot_manager.save_screenshot_to_disk(main_window.single(), &screenshot_path)
            {
                Err(e) => error!("screenshotting failed: {}", e),
                Ok(_) => {
                    info!("{} SAVED!", screenshot_path.display());
                }
            }

            thread::sleep(Duration::from_millis(100));
        }
    }
}
