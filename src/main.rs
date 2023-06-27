use bevy::{
    asset::ChangeWatcher,
    prelude::*,
    reflect::{TypePath, TypeUuid},
    render::render_resource::*,
    utils::Duration,
    window::{CompositeAlphaMode, WindowLevel},
    window::{Window, WindowPlugin},
};

fn main() {
    App::new()
        .add_plugins(
            //..
            (
                // We make a few customisations...
                DefaultPlugins
                    .set(AssetPlugin {
                        // We want to watch for when our myshader.wgsl is changed on disk to re-render.
                        watch_for_changes: ChangeWatcher::with_delay(Duration::from_millis(200)),
                        ..default()
                    })
                    // We want the window to not be shit.
                    .set(WindowPlugin {
                        primary_window: Some(Window {
                            title: "shadplay".into(),
                            resolution: (320., 180.).into(),
                            // Setting `transparent` allows the `ClearColor`'s alpha value to take effect
                            transparent: true,
                            // Disabling window decorations to make it feel more like a widget than a window
                            decorations: true,
                            #[cfg(target_os = "macos")]
                            composite_alpha_mode: CompositeAlphaMode::PostMultiplied,
                            // We want our shader to be ontop of everything, always :)
                            window_level: WindowLevel::AlwaysOnTop,
                            ..default()
                        }),
                        // exit_condition: todo!(),
                        // close_when_requested: todo!(),
                        ..default()
                    }),
                //..
                // YOUR SHADER STUFF!!
                MaterialPlugin::<YourShader>::default(),
                //..
            ),
            //..
        )
        .insert_resource(ClearColor(Color::NONE)) // Transparent Window
        .add_systems(Startup, setup)
        .run();
}

fn setup(
    mut commands: Commands,
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<YourShader>>,
) {
    // shape
    commands.spawn(MaterialMeshBundle {
        mesh: meshes.add(Mesh::from(shape::Torus {
            radius: 2.,
            ring_radius: 0.2,
            subdivisions_segments: 128,
            subdivisions_sides: 128,
        })),
        transform: Transform::from_xyz(0.0, 0.5, 0.0),
        material: materials.add(YourShader {}),
        ..default()
    });

    // cameras
    commands.spawn(Camera3dBundle {
        transform: Transform::from_xyz(-2.0, 2.5, 5.0).looking_at(Vec3::ZERO, Vec3::Y),
        ..default()
    });
}

#[derive(AsBindGroup, TypeUuid, TypePath, Debug, Clone)]
#[uuid = "a3d71c04-d054-4946-80f8-ba6cfbc90cad"]
struct YourShader {}

impl Material for YourShader {
    fn fragment_shader() -> ShaderRef {
        "shaders/myshader.wgsl".into()
    }
}
