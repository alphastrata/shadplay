pub mod drag_n_drop;
pub mod screenshot;
pub mod shader_utils;
pub mod system_clipboard;
pub mod texture_tooling;
pub mod ui;
pub mod utils;

pub mod system {
    #![allow(dead_code, unused_imports)]
    //! Logic and Helpers etc for dealing with the system Shadplay is running on, i.e
    //! the app's default config, long-lived settings and the clipboard interactions.
    use bevy::{prelude::Resource, window::WindowLevel};
    use directories::ProjectDirs;
    use log;
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
        fn get_config_path() -> PathBuf {
            match ProjectDirs::from("", "", "shadplay") {
                Some(proj_dirs) => {
                    let config_path_full = proj_dirs.config_dir().join("config.toml");
                    log::info!("Config directory is: {}", config_path_full.display());

                    if !proj_dirs.config_dir().exists() {
                        log::error!("config.toml doesn't exist, creating it...",);
                        if let Err(e) = fs::create_dir_all(&config_path_full) {
                            log::error!("Failed to create directory: {:?}", e);
                        }
                        log::info!("config.toml created...",);
                    }

                    config_path_full
                }
                None => {
                    log::error!("Unable to find or create the config directory.");
                    Self::write_defaults()
                        .expect("Unable to write default config to $PATH, this is an app error.\n Please open an Issue: https://github.com/alphastrata/shadplay/issues")
                }
            }
        }

        fn write_defaults() -> Result<PathBuf, std::io::Error> {
            let default_path = Self::get_config_path();
            Self::default().save_to_toml(&default_path)?;

            Ok(default_path)
        }

        fn save_to_toml<P: AsRef<Path>>(&self, path: P) -> io::Result<()> {
            fs::write(
                path,
                toml::to_string(self).expect("Failed to serialize UserConfig to TOML"),
            )?;

            Ok(())
        }

        fn load_from_toml<P: AsRef<Path>>(path: P) -> io::Result<Self> {
            let mut file_contents = String::new();
            fs::File::open(path)?.read_to_string(&mut file_contents)?;
            let config: UserConfig =
                toml::from_str(&file_contents).expect("Failed to deserialize TOML into UserConfig");

            Ok(config)
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
        use pretty_env_logger;
        use std::fs;

        #[test]
        fn save_and_load_user_config() {
            // Setup: Create a sample UserConfig and save it to a temporary file
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
            dbg!(&p);
        }
    }
}
