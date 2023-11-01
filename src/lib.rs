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
    use serde::{Deserialize, Serialize};
    use std::{path::PathBuf, time::UNIX_EPOCH};

    #[derive(Resource, Debug, Serialize, Deserialize)]
    struct UserConfig {
        window_dims: (f32, f32),
        decorations: bool,
        always_on_top: bool,
        last_updated: u64,
    }

    impl UserConfig {
        fn get_config_path() -> PathBuf {
            match ProjectDirs::from("", "shadplay", "settings.toml") {
                Some(proj_dirs) => {
                    println!("Config directory is: {:?}", proj_dirs.config_dir());
                    return proj_dirs.config_dir().to_path_buf();
                }
                _ => Self::write_defaults()
                    .expect("Unable to write default config to $PATH, this is an app error."), //FIXME:
            }
        }

        fn from_file() -> Result<Self, std::io::Error> {
            // Self { window_dims: , decorations: , always_on_top:  }
            todo!()
        }

        fn write_defaults() -> Result<PathBuf, std::io::Error> {
            // write the default to the location on disk,
            // read that from_file, return it.
            todo!()
        }

        fn write_to_disk(&self) -> Result<(), std::io::Error> {
            todo!()
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
}
