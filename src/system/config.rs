//! Logic and Helpers etc for dealing with the system Shadplay is running on, i.e
//! the app's default config, long-lived settings and the clipboard interactions.
use bevy::{
    asset::{AssetApp, AssetServer, Assets},
    ecs::system::{Commands, Local, Res},
    input::{
        ButtonInput,
        keyboard::{KeyCode, KeyboardInput},
    },
    log,
    prelude::{Handle, Image, Query, ResMut, Resource},
    render::render_resource::Extent3d,
    render::render_resource::{TextureDescriptor, TextureDimension, TextureFormat, TextureUsages},
    window::{CompositeAlphaMode, Window, WindowLevel},
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
pub struct UserSession {
    #[serde(default = "default_window_dims")]
    pub window_dims: (u32, u32),
    #[serde(default = "neg")]
    decorations: bool,
    #[serde(default = "neg")]
    always_on_top: bool,
    #[serde(default = "default_last_updated")]
    last_updated: u64, //Toml doesn't supprot u128

    /// RenderTarget for when we're making a gif out of
    #[serde(skip)]
    pub gif_buffer: Option<Handle<Image>>,
    #[serde(default = "default_gif_framerate")]
    pub gif_framerate: f64,
}

fn default_gif_framerate() -> f64 {
    0.05
}

// Provide a default function for window_dims
fn default_window_dims() -> (u32, u32) {
    (800, 600) // Default window dimensions
}

fn neg() -> bool {
    false
}

// Provide a default function for last_updated
fn default_last_updated() -> u64 {
    std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap_or_default()
        .as_secs()
}

impl UserSession {
    pub fn get_config_path() -> PathBuf {
        match ProjectDirs::from("", "", "shadplay") {
            Some(proj_dirs) => {
                let config_path_full = proj_dirs.config_dir().join("config.toml");
                log::info!("Config directory is: {}", config_path_full.display());

                if !proj_dirs.config_dir().exists() {
                    log::error!("config_dir doesn't exist, creating it...",);
                    if let Err(e) = fs::create_dir_all(proj_dirs.config_dir()) {
                        log::error!("Failed to create directory: {:?}", e);
                    }
                    log::info!("config_dir created.")
                }

                config_path_full
            }
            None => {
                log::error!("Unable to find or create the config directory.");
                unreachable!(
                    "If you see this error, shadpaly was unable to write the default user configuration to your system, please open an issue, on GH."
                )
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
        let config: UserSession =
            toml::from_str(&file_contents).expect("Failed to deserialize TOML into UserConfig");

        Ok(config)
    }

    pub fn create_window_settings(&self) -> Window {
        Window {
            title: "shadplay".into(),
            resolution: self.window_dims.into(),
            // transparent: true,
            // decorations: self.decorations,
            transparent: false,
            decorations: true,
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
    pub fn runtime_updater(mut user_config: ResMut<UserSession>, windows: Query<&Window>) {
        let win = windows
            .single()
            .expect("Should be impossible to NOT get a window");

        let (width, height) = (win.width(), win.height());

        user_config.decorations = win.decorations;
        user_config.always_on_top = matches!(win.window_level, WindowLevel::AlwaysOnTop);
        user_config.window_dims = (width as u32, height as u32);
        user_config.last_updated = std::time::SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap_or_default()
            .as_secs();

        match user_config.save_to_toml(Self::get_config_path()) {
            Ok(_) => log::info!("User's config.toml's screen dims were updated."),
            Err(e) => log::error!("Failed to update user's config {}", e),
        }
    }

    /// Works like a `std::mem::swap(a, b)`, but takes the asset server to attain the Handle<Image> for `b`.
    fn pop_gif_buffer(&mut self, images: &mut ResMut<Assets<Image>>) -> anyhow::Result<Image> {
        let (width, height) = self.window_dims;
        let size = Extent3d {
            width: width as u32,
            height: height as u32,
            ..Default::default()
        };

        let mut new_scratch = Image {
            texture_descriptor: TextureDescriptor {
                label: None,
                size,
                dimension: TextureDimension::D2,
                format: TextureFormat::Bgra8UnormSrgb,
                mip_level_count: 1,
                sample_count: 1,
                usage: TextureUsages::TEXTURE_BINDING
                    | TextureUsages::COPY_DST
                    | TextureUsages::RENDER_ATTACHMENT,
                view_formats: &[],
            },
            ..Default::default()
        };
        new_scratch.resize(size);

        if let Some(current_buffer) = images.get_mut(&self.gif_buffer.clone().unwrap()) {
            Ok(std::mem::replace(current_buffer, new_scratch))
        } else {
            anyhow::bail!("Failed to swap the buffers..");
        }
    }

    /// takes the UserSession's current buffer and saves it to disk as an `ordererd` png.
    pub fn flush_gif_buffer_to_disk(
        &mut self,
        mut local: Local<usize>,
        mut images: ResMut<Assets<Image>>,
    ) {
        let image = self.pop_gif_buffer(&mut images).unwrap();
        let dynamic = image.clone().try_into_dynamic().unwrap();
        // let filename = format!(".gif_scratch/{:05}.png", *local);
        let filename = "output.png".to_string();
        let format = image::ImageFormat::from_path(filename.clone()).unwrap();
        log::debug!("ImCompressed: {}", image.is_compressed());
        let img_out = dynamic.to_rgb8();

        if let Err(e) = img_out.save_with_format(filename, format) {
            log::error!("Unable to save DynamicImage");
            log::error!("{}", e);
            return;
        }
        *local += 1;
    }
}

impl Default for UserSession {
    fn default() -> Self {
        Self {
            window_dims: (720, 480),
            decorations: true,
            always_on_top: true,
            last_updated: std::time::SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .unwrap_or_default()
                .as_secs(),
            gif_buffer: None,
            gif_framerate: 0.05,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::UserSession;
    use std::fs;

    #[test]
    fn save_and_load_user_config() {
        let test_config = UserSession {
            window_dims: (1024, 768),
            decorations: false,
            always_on_top: false,
            last_updated: 1635900000,
            gif_buffer: None,
            gif_framerate: 0.05,
        };

        let temp_path = "./temp_config.toml";
        test_config
            .save_to_toml(temp_path)
            .expect("Failed to save test config to TOML");

        let loaded_config =
            UserSession::load_from_toml(temp_path).expect("Failed to load test config from TOML");
        assert_eq!(test_config, loaded_config);

        fs::remove_file(temp_path).expect("Failed to remove temporary test config file");
    }

    #[test]
    fn config_path_for_user_config() {
        let p = UserSession::get_config_path();
        let test_config = UserSession {
            window_dims: (1024, 768),
            decorations: false,
            always_on_top: true,
            last_updated: 1635900000,
            gif_buffer: None,
            gif_framerate: 0.05,
        };
        test_config.save_to_toml(p).unwrap();
    }
}
