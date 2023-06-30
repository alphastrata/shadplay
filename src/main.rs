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
use utils::{init_shapes, switch_level, toggle_decorations, ShapeOptions};

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
        .add_systems(PreStartup, utils::init_shapes)
        .add_systems(Startup, utils::setup)
        .add_systems(
            Update,
            (
                rotate,
                utils::toggle_decorations,
                utils::switch_level, //..
                utils::switch_shape,
                utils::quit,
            ),
        )
        .run();
}

//TODO: up/down arrows to increase/decrease rotation speed.
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
        prelude::{shape::CapsuleUvProfile, *},
        window::{Window, WindowLevel},
    };

    /// Component: Marking shapes that we spawn.
    /// Used by: the rotate system.
    #[derive(Component, Clone, Default)]
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
    #[derive(Resource, Default)]
    pub struct ShapeOptions(pub Vec<(bool, (MaterialMeshBundle<YourShader>, Shape))>);

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
    /// Quits the app...
    pub fn quit(input: Res<Input<KeyCode>>) {
        if input.just_pressed(KeyCode::Q) {
            panic!()
        }
    }

    /// Switch the shape we're currently playing with a shader on.
    pub fn switch_shape(
        input: Res<Input<KeyCode>>,
        mut shape_options: ResMut<ShapeOptions>,
        mut commands: Commands,
        query: Query<Entity, With<Shape>>,
    ) {
        if input.just_pressed(KeyCode::S) {
            // Old
            let Some(idx) = shape_options.0.iter().position(|v| v.0) else{return};
            shape_options.0[idx].0 = false;
            query.iter().for_each(|e| commands.entity(e).despawn());

            // New
            let next = (idx + 1) % shape_options.0.len();
            commands.spawn(shape_options.0[next].1.clone());
            shape_options.0[next].0 = true;
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

    pub fn init_shapes(
        mut meshes: ResMut<Assets<Mesh>>,
        mut materials: ResMut<Assets<YourShader>>,
        mut shape_options: ResMut<ShapeOptions>,
    ) {
        // --------SHAPES-------- //
        shape_options.0.push((
            true,
            (
                MaterialMeshBundle {
                    mesh: meshes
                        .add(Mesh::from(shape::Torus {
                            radius: 2.,
                            ring_radius: 0.2,
                            subdivisions_segments: 128,
                            subdivisions_sides: 128,
                        }))
                        .clone(),
                    transform: Transform::from_xyz(0.0, 0.5, 0.0),
                    material: materials.add(crate::shader_utils::YourShader {
                        color: Color::default(),
                    }),
                    ..default()
                },
                Shape,
            ),
        ));

        shape_options.0.push((
            false,
            ((
                MaterialMeshBundle {
                    mesh: meshes.add(Mesh::from(shape::Cube { size: 3.0 })).clone(),
                    transform: Transform::from_xyz(0.0, 0.5, 0.0),
                    material: materials.add(crate::shader_utils::YourShader {
                        color: Color::default(),
                    }),
                    ..default()
                },
                Shape,
            )),
        ));

        //TODO: add more shapes...
    }

    pub fn setup(mut commands: Commands, shape_options: Res<ShapeOptions>) {
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

        for matmeshbund in shape_options.0.iter().filter(|v| v.0) {
            println!("found one!");
            commands.spawn(matmeshbund.1.clone());
        }
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
