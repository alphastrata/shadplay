///
/// ShadPlay
///
use argh::FromArgs;
use bevy::{
    prelude::*,
    window::{MonitorSelection, WindowMode, WindowResized},
};
use std::fs;
use std::path::Path;

use shadplay::{
    plugin::ShadPlayPlugin,
    system::config::UserSession,
    utils::{self, ScreensaverState},
};

#[derive(FromArgs)]
/// shadplay — live shader editor & screensaver
struct Args {
    /// run in screensaver mode, cycling through wgsl files in DIR
    #[argh(option, short = 'S')]
    screensaver: Option<String>,

    /// shader file to load
    #[argh(positional)]
    shader: Option<String>,
}

fn main() {
    let args: Args = argh::from_env();

    if let Some(ref dir) = args.screensaver {
        run_screensaver(dir, args.shader);
    } else {
        run_normal(args.shader);
    }
}

fn run_normal(shader_arg: Option<String>) {
    if let Some(ref path) = shader_arg {
        if let Err(e) = utils::apply_shader_file(Path::new(path)) {
            eprintln!("Error loading shader from {}: {}", path, e);
            std::process::exit(1);
        }
    }

    let path = UserSession::get_config_path();
    let user_config = UserSession::load_from_toml(path).unwrap_or_default();
    let user_cfg_window = user_config.create_window_settings();

    let mut app = App::new();
    app.insert_resource(user_config)
        .insert_resource(ClearColor(Color::NONE))
        .add_plugins((
            DefaultPlugins.set(WindowPlugin {
                primary_window: Some(user_cfg_window),
                ..default()
            }),
            ShadPlayPlugin,
        ))
        .add_systems(
            PostUpdate,
            (
                UserSession::runtime_updater
                    .run_if(on_message::<WindowResized>)
                    .run_if(time_passed(1.0)),
            ),
        )
        .run();
}

fn run_screensaver(dir: &str, shader_arg: Option<String>) {
    let dir_path = Path::new(dir);
    if !dir_path.is_dir() {
        eprintln!("Error: {} is not a directory", dir);
        std::process::exit(1);
    }

    let mut shaders: Vec<std::path::PathBuf> = if let Ok(entries) = fs::read_dir(dir_path) {
        entries
            .flatten()
            .map(|entry| entry.path())
            .filter(|path| path.extension().is_some_and(|e| e == "wgsl"))
            .collect()
    } else {
        Vec::new()
    };
    shaders.sort();

    if shaders.is_empty() {
        eprintln!("No .wgsl files found in {}", dir);
        std::process::exit(1);
    }

    // Load initial shader
    if let Some(ref path) = shader_arg {
        if let Err(e) = utils::apply_shader_file(Path::new(path)) {
            eprintln!("Error loading shader from {}: {}", path, e);
            std::process::exit(1);
        }
    } else if let Err(e) = utils::apply_shader_file(&shaders[0]) {
        eprintln!("Error loading shader: {}", e);
        std::process::exit(1);
    }

    let window = Window {
        title: "shadplay — screensaver".into(),
        mode: WindowMode::BorderlessFullscreen(MonitorSelection::Current),
        ..default()
    };

    let shader_count = shaders.len();
    let mut app = App::new();
    app.insert_resource(ClearColor(Color::BLACK))
        .insert_resource(ScreensaverState {
            shaders,
            index: 1 % shader_count,
            interval: 15.0,
        })
        .add_plugins((
            DefaultPlugins.set(WindowPlugin {
                primary_window: Some(window),
                ..default()
            }),
            ShadPlayPlugin,
        ))
        .add_systems(Update, utils::screensaver_hide_cursor)
        .add_systems(Update, utils::screensaver_cycle)
        .add_systems(Update, utils::screensaver_exit)
        .run();
}

fn time_passed(t: f32) -> impl FnMut(Local<f32>, Res<Time>) -> bool {
    move |mut timer: Local<f32>, time: Res<Time>| {
        *timer += time.delta_secs();
        *timer >= t
    }
}
