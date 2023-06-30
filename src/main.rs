#![allow(unused_imports)]
/// The UI buttons etc.
//NOTE: most of this should be pub(crate) or private.
pub mod ui;

use bevy::{
    asset::ChangeWatcher,
    prelude::*,
    utils::Duration,
    window::{CompositeAlphaMode, WindowLevel},
    window::{Window, WindowPlugin},
};

use shader_utils::YourShader;
use utils::{switch_level, toggle_decorations, ShapeOptions};

fn main() {
    App::new()
        .insert_resource(ShapeOptions::default())
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
        .add_systems(
            Update,
            (
                rotate,
                toggle_decorations,
                switch_level, //..
            ),
        )
        .run();
}

fn rotate(mut query: Query<&mut Transform, With<utils::Shape>>, time: Res<Time>) {
    for mut transform in &mut query {
        transform.rotate_local_z(time.delta_seconds() / 2.);
        transform.rotate_local_x(time.delta_seconds() / 8.);
        transform.rotate_y(time.delta_seconds() / 0.5);
    }
}
/// The main place all our app's systems, input handling, spawning stuff into the world etc.
pub mod utils {
    use bevy::{
        ecs::component::ComponentDescriptor,
        prelude::*,
        window::{Window, WindowLevel},
    };

    /// Component: Marking shapes that we spawn.
    /// Used by: the rotate system.
    #[derive(Component)]
    pub struct Shape;

    /// Component: Marking the 3d camera.
    /// Used by: the CamSwitch event.
    #[derive(Component)]
    pub struct Cam3D;

    /// Component: Marking the 2d camera.
    /// Used by: the CamSwitch event.
    #[derive(Component)]
    pub struct Cam2D;

    ///Event: Triggers the 2D to 3D or vice-versa camera switch.
    #[derive(Event)]
    pub struct CamSwitch;

    ///Resource: All the shapes we have the option of displaying.
    #[derive(Resource, Deref, DerefMut, Default)]
    pub struct ShapeOptions(pub Vec<(String, (Handle<Mesh>, bool))>);

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

    /// Switch the shape we're currently playing with a shader on.
    pub fn switch_shape(mut shape_options: ResMut<ShapeOptions>) {
        // find the true one, then go one more, be careful of wrapping around, % it out.
        // set the true one's Visibility to Hidden, and the compute Visibility too.
        // idx +1 % shape_options.len() to Visible and such.
        todo!()
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
        mut shape_options: ResMut<ShapeOptions>,
    ) {
        // --------SHAPES-------- //
        let torus = meshes.add(Mesh::from(shape::Torus {
            radius: 2.,
            ring_radius: 0.2,
            subdivisions_segments: 128,
            subdivisions_sides: 128,
        }));

        commands.spawn((
            MaterialMeshBundle {
                mesh: torus.clone(),
                transform: Transform::from_xyz(0.0, 0.5, 0.0),
                material: materials.add(crate::shader_utils::YourShader {
                    color: Color::default(),
                }),
                ..default()
            },
            Shape,
        ));

        shape_options.push(("torus".into(), (torus, true)));

        let cube = meshes.add(Mesh::from(shape::Cube { size: 1.0 }));

        commands.spawn((
            MaterialMeshBundle {
                mesh: cube.clone(),
                transform: Transform::from_xyz(0.0, 0.5, 0.0),
                material: materials.add(crate::shader_utils::YourShader {
                    color: Color::default(),
                }),
                visibility: Visibility::Hidden,
                computed_visibility: ComputedVisibility::HIDDEN,
                ..default()
            },
            Shape,
        ));

        shape_options.push(("cube".into(), (cube, false)));

        //-----------------------CAMERAS-------------------------//
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

/// The main place to put code/systems/events/resources etc that handle the shaders a user is playing with.
pub mod shader_utils {

    use bevy::{
        prelude::*,
        reflect::{TypePath, TypeUuid},
        render::render_resource::*,
    };

    #[derive(AsBindGroup, TypeUuid, TypePath, Debug, Clone)]
    #[uuid = "a3d71c04-d054-4946-80f8-ba6cfbc90cad"]
    pub struct YourShader {
        #[uniform(0)]
        pub color: Color, //RGBA
    }

    impl Material for YourShader {
        fn fragment_shader() -> ShaderRef {
            "shaders/myshader.wgsl".into()
        }
    }
}
