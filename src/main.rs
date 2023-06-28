#![allow(unused_imports)]
use bevy::{
    asset::ChangeWatcher,
    prelude::*,
    utils::Duration,
    window::{CompositeAlphaMode, WindowLevel},
    window::{Window, WindowPlugin},
};

use shader_utils::YourShader;

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
        .add_systems(Startup, utils::setup)
        .run();
}

/// The main place all our app's systems, input handling, spawning stuff into the world etc.
pub mod utils {
    use bevy::{
        prelude::*,
        window::{Window, WindowLevel},
    };

    #[derive(Component)]
    pub struct Cam3D;

    #[derive(Component)]
    pub struct Cam2D;

    ///Event: Triggers the 2D to 3D or vice-versa camera switch.
    #[derive(Event)]
    pub struct CamSwitch;

    use crate::shader_utils::YourShader;

    /// Move between always on bottom, always on top and just, 'normal' window modes, by hitting the 'L' key.
    pub fn switch_level(input: Res<Input<KeyCode>>, mut windows: Query<&mut Window>) {
        //TODO: move logic to helper func and have this trigger on key or Event.
        if input.just_pressed(KeyCode::L) {
            let mut window = windows.single_mut();

            window.window_level = match window.window_level {
                WindowLevel::AlwaysOnBottom => WindowLevel::Normal,
                WindowLevel::Normal => WindowLevel::AlwaysOnTop,
                WindowLevel::AlwaysOnTop => WindowLevel::AlwaysOnBottom,
            };
            info!("WINDOW_LEVEL: {:?}", window.window_level);
        }
    }

    /// Toggle the app's window decorations (the titlebar at the top with th close/minimise buttons etc);
    pub fn toggle_decorations(input: Res<Input<KeyCode>>, mut windows: Query<&mut Window>) {
        //TODO: move logic to helper func and have this trigger on key or Event.
        if input.just_pressed(KeyCode::D) {
            let mut window = windows.single_mut();

            window.decorations = !window.decorations;

            info!("WINDOW_DECORATIONS: {:?}", window.decorations);
        }
    }

    /// Toggle camera between 2D and 3D:
    pub fn switch_camera(
        mut cam3d: Query<&mut Camera, With<Cam3D>>,
        mut cam2d: Query<&mut Camera, With<Cam2D>>,
        mut trigger: EventReader<CamSwitch>,
    ) {
        // read the trigger, flip the cameras.
        // TODO: bind a hotkey.
        todo!()
    }

    pub fn setup(
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
            material: materials.add(crate::shader_utils::YourShader {}),
            ..default()
        });

        // 3D camera
        commands.spawn((
            Camera3dBundle {
                transform: Transform::from_xyz(-2.0, 2.5, 5.0).looking_at(Vec3::ZERO, Vec3::Y),
                camera: Camera {
                    order: 0,
                    ..default()
                },
                ..default()
            },
            Cam3D,
        ));

        // 2D camera
        commands.spawn((
            Camera2dBundle {
                camera: Camera {
                    is_active: false,
                    ..default()
                },
                ..default()
            },
            Cam3D,
        ));
    }
}

/// The UI buttons etc.
//NOTE: most of this should be pub(crate) or private.
pub mod ui {
    use bevy::prelude::*;

    #[derive(Event)]
    pub struct ToggleTransparency;

    fn toggle_transparency(trigger: EventWriter<ToggleTransparency>) {
        // on button press, toggle transparency.
    }
    //TODO: one of these dispatchers for every button.

    const NORMAL_BUTTON: Color = Color::rgb(0.15, 0.15, 0.15);
    const HOVERED_BUTTON: Color = Color::rgb(0.25, 0.25, 0.25);
    const PRESSED_BUTTON: Color = Color::rgb(0.35, 0.75, 0.35);

    ///System: handles the interaction with our App's buttons.
    pub fn button_interaction(
        mut interaction_query: Query<
            (
                &Interaction,
                &mut BackgroundColor,
                &mut BorderColor,
                &Children,
            ),
            (Changed<Interaction>, With<Button>),
        >,
        mut text_query: Query<&mut Text>,
    ) {
        for (interaction, mut color, mut border_color, children) in &mut interaction_query {
            let mut text = text_query.get_mut(children[0]).unwrap();
            match *interaction {
                Interaction::Clicked => {
                    text.sections[0].value = "Press".to_string();
                    *color = PRESSED_BUTTON.into();
                    border_color.0 = Color::RED;
                }
                Interaction::Hovered => {
                    text.sections[0].value = "Hover".to_string();
                    *color = HOVERED_BUTTON.into();
                    border_color.0 = Color::WHITE;
                }
                Interaction::None => {
                    text.sections[0].value = "Button".to_string();
                    *color = NORMAL_BUTTON.into();
                    border_color.0 = Color::BLACK;
                }
            }
        }
    }

    pub fn setup(mut commands: Commands, asset_server: Res<AssetServer>) {
        // Ideas:
        // https://github.com/bevyengine/bevy/blob/main/examples/ui/ui.rs
        todo!()
    }
}
/// The main place to put code/systems/events/resources etc that handle the shaders a user is playing with.
pub mod shader_utils {

    use bevy::{
        prelude::*,
        reflect::{TypePath, TypeUuid},
        render::render_resource::*,
    };

    #[derive(AsBindGroup, TypeUuid, TypePath, Debug, Clone)]
    #[uuid = "a3d71c04-d054-4946-80f8-ba6cfbc90cad"]
    pub struct YourShader {}

    impl Material for YourShader {
        fn fragment_shader() -> ShaderRef {
            "shaders/myshader.wgsl".into()
        }
    }
}
