pub mod drag_n_drop;
pub mod screenshot;
pub mod shader_utils;
pub mod system_clipboard;
pub mod texture_tooling;
pub mod ui;
pub mod utils;

pub mod system {
    //! Logic and Helpers etc for dealing with the system Shadplay is running on, i.e
    //! the app's default config, long-lived settings and the clipboard interactions.
    use bevy::{
        log,
        prelude::{Query, ResMut, Resource},
        window::{Window, WindowLevel},
    };
    use directories::ProjectDirs;
    use serde::{Deserialize, Serialize};
    use std::{
        fs,
        io::{self, Read},
        path::{Path, PathBuf},
        time::UNIX_EPOCH,
    };

    #[derive(Resource, Debug, Serialize, PartialEq, PartialOrd, Deserialize)]
    pub struct UserConfig {
        window_dims: (f32, f32),
        decorations: bool,
        always_on_top: bool,
        last_updated: u64,
    }

    impl UserConfig {
        pub fn get_config_path() -> PathBuf {
            match ProjectDirs::from("", "", "shadplay") {
                Some(proj_dirs) => {
                    let config_path_full = proj_dirs.config_dir().join("config.toml");
                    log::info!("Config directory is: {}", config_path_full.display());

                    if !proj_dirs.config_dir().exists() {
                        log::error!("config_dir doesn't exist, creating it...",);
                        if let Err(e) = fs::create_dir_all(&proj_dirs.config_dir()) {
                            log::error!("Failed to create directory: {:?}", e);
                        }
                        log::info!("config_dir created.")
                    }

                    config_path_full
                }
                None => {
                    log::error!("Unable to find or create the config directory.");
                    unreachable!("If you see this error, shadpaly was unable to write the default user configuration to your system, please open an issue, on GH.")
                }
            }
        }

        pub fn save_to_toml<P: AsRef<Path>>(&self, path: P) -> io::Result<()> {
            fs::write(
                path,
                toml::to_string(self).expect("Failed to serialize UserConfig to TOML"),
            )?;

            Ok(())
        }

        pub fn load_from_toml<P: AsRef<Path>>(path: P) -> io::Result<Self> {
            let mut file_contents = String::new();
            fs::File::open(path)?.read_to_string(&mut file_contents)?;
            let config: UserConfig =
                toml::from_str(&file_contents).expect("Failed to deserialize TOML into UserConfig");

            Ok(config)
        }

        pub fn create_window_settings(&self) -> Window {
            Window {
                title: "shadplay".into(),
                resolution: self.window_dims.into(),
                transparent: true,
                decorations: self.decorations,
                // Mac only
                #[cfg(target_os = "macos")]
                composite_alpha_mode: CompositeAlphaMode::PostMultiplied,
                window_level: self.window_level(),
                ..bevy::prelude::default()
            }
        }

        fn window_level(&self) -> WindowLevel {
            match self.always_on_top {
                true => WindowLevel::AlwaysOnTop,
                _ => WindowLevel::Normal,
            }
        }

        /// System: When the screen dims change, we update the Self we have in the bevy [`Resource`]s.
        pub fn runtime_updater(mut user_config: ResMut<UserConfig>, windows: Query<&Window>) {
            let win = windows
                .get_single()
                .expect("Should be impossible to NOT get a window");

            let (width, height) = (win.width(), win.height());
            user_config.window_dims = (width, height);

            match user_config.save_to_toml(Self::get_config_path()) {
                Ok(_) => log::info!("User's config.toml's screen dims were updated."),
                Err(e) => log::error!("Failed to update user's config {}", e),
            }
        }
    }

    impl Default for UserConfig {
        fn default() -> Self {
            Self {
                window_dims: (720.0, 480.0),
                decorations: true,
                always_on_top: true,
                last_updated: std::time::SystemTime::now()
                    .duration_since(UNIX_EPOCH)
                    .unwrap_or_default()
                    .as_secs(),
            }
        }
    }

    #[cfg(test)]
    mod tests {
        use super::UserConfig;
        use std::fs;

        #[test]
        fn save_and_load_user_config() {
            let test_config = UserConfig {
                window_dims: (1024.0, 768.0),
                decorations: false,
                always_on_top: false,
                last_updated: 1635900000,
            };

            let temp_path = "./temp_config.toml";
            test_config
                .save_to_toml(temp_path)
                .expect("Failed to save test config to TOML");

            let loaded_config = UserConfig::load_from_toml(temp_path)
                .expect("Failed to load test config from TOML");
            assert_eq!(test_config, loaded_config);

            fs::remove_file(temp_path).expect("Failed to remove temporary test config file");
        }

        #[test]
        fn config_path_for_user_config() {
            let p = UserConfig::get_config_path();
            let test_config = UserConfig {
                window_dims: (1024.0, 768.0),
                decorations: false,
                always_on_top: true,
                last_updated: 1635900000,
            };
            test_config.save_to_toml(p).unwrap();
        }
    }
}
