use std::path::Path;
use std::path::PathBuf;

use bevy::log;
use bevy::prelude::*;
use bevy::render::view::screenshot::ScreenshotManager;
use bevy::window::PrimaryWindow;

use crate::utils::AppState;

const DEFAULT_SHADER_3D: &str = "assets/shaders/myshader.wgsl";
const DEFAULT_SHADER_2D: &str = "assets/shaders/myshader_2d.wgsl";

/// Saves a screenshot && versions the shader (from [`DEFAULT_SHADER`]) that was active when screenshotting.
/// giving you something like this:
///```shell
/// screenshots
///└──  01-2-23
///    └──  09-23-29
///        ├──  screenshot.png
///        └──  screenshot.wgsl
///```
pub fn screenshot_and_version_shader_on_spacebar(
    input: Res<ButtonInput<KeyCode>>,
    main_window: Query<Entity, With<PrimaryWindow>>,
    mut screenshot_manager: ResMut<ScreenshotManager>,
    app_state: Res<State<AppState>>,
) {
    if input.just_pressed(KeyCode::Space) {
        let target = PathBuf::from(format!(
            "screenshots/{}/{}/screenshot.png",
            super::today(),
            super::timestamper()
        ));
        if let Err(e) = super::make_all(&target) {
            error!("make_all failed: {}", e);
        }

        match screenshot_manager.save_screenshot_to_disk(main_window.single(), &target) {
            Err(e) => error!("Screenshot(still) failed: {}", e),
            Ok(_) => {
                let shader_path = match app_state.get() {
                    AppState::TwoD => DEFAULT_SHADER_2D,
                    AppState::ThreeD => DEFAULT_SHADER_3D,
                    _ => {
                        log::debug!("Sceenshot system do nothing in GifMode.");
                        return;
                    }
                };
                super::version_current_shader(Path::new(shader_path), &target);
            }
        }
    }
}
