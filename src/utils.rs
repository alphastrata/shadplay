use bevy::render::camera::ScalingMode;
use bevy::{
    prelude::*,
    window::{RequestRedraw, Window, WindowLevel},
};
use bevy_panorbit_camera::{PanOrbitCamera, PanOrbitCameraPlugin};

use crate::shader_utils::YourShader;

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

/// Resource: Used for toggling on/off the transparency of the app.
#[derive(Resource, DerefMut, Deref)]
pub struct TransparencySet(pub bool);

/// Event: Triggers the 2D to 3D or vice-versa camera switch.
#[derive(Event)]
pub struct CamSwitch;

/// Resource: All the shapes we have the option of displaying.
#[derive(Resource, Default)]
pub struct ShapeOptions(pub Vec<(bool, (MaterialMeshBundle<YourShader>, Shape))>);

#[derive(Resource, Default, PartialEq)]
pub struct Rotating(pub bool);

/// System: to toggle on/off the rotating
pub fn toggle_rotate(input: Res<Input<KeyCode>>, mut toggle: ResMut<Rotating>) {
    if input.just_pressed(KeyCode::R) {
        toggle.0 = !toggle.0;
    }
}

/// System: Rotates the currently active geometry in the scene
pub fn rotate(mut query: Query<&mut Transform, With<Shape>>, time: Res<Time>) {
    for mut transform in &mut query {
        transform.rotate_local_z(time.delta_seconds() * 0.25);
        transform.rotate_local_x(time.delta_seconds() * 0.33);
        transform.rotate_y(time.delta_seconds() * 0.250);
    }
}

/// System:
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

/// System:
/// Quits the app...
pub fn quit(input: Res<Input<KeyCode>>) {
    if input.just_pressed(KeyCode::Q) {
        panic!()
    }
}

/// System:
pub fn toggle_transparency(
    input: Res<Input<KeyCode>>,
    mut clear_colour: ResMut<ClearColor>,
    mut transparency_set: ResMut<TransparencySet>,
    mut _windows: Query<&mut Window>,
    mut event: EventWriter<RequestRedraw>,
) {
    if input.just_pressed(KeyCode::T) {
        // let mut window = windows.single_mut();
        // window.transparent = !window.transparent; // Not supported after creation.
        if **transparency_set {
            *clear_colour = ClearColor(Color::BLACK);
        } else {
            *clear_colour = ClearColor(Color::NONE);
        }

        **transparency_set = !**transparency_set;
        event.send(RequestRedraw);
    }
}

/// System:
/// Switch the shape we're currently playing with a shader on.
pub fn switch_shape(
    input: Res<Input<KeyCode>>,
    mut shape_options: ResMut<ShapeOptions>,
    mut commands: Commands,
    query: Query<Entity, With<Shape>>,
) {
    if input.just_pressed(KeyCode::S) {
        // Old
        let Some(idx) = shape_options.0.iter().position(|v| v.0) else {
            return;
        };
        shape_options.0[idx].0 = false;
        query.iter().for_each(|e| commands.entity(e).despawn());

        // New
        let next = (idx + 1) % shape_options.0.len();
        commands.spawn(shape_options.0[next].1.clone());
        shape_options.0[next].0 = true;
    }
}

/// System:
/// Toggle the app's window decorations (the titlebar at the top with th close/minimise buttons etc);
pub fn toggle_decorations(input: Res<Input<KeyCode>>, mut windows: Query<&mut Window>) {
    //TODO: move logic to helper func and have this trigger on key or Event.
    if input.just_pressed(KeyCode::D) {
        let mut window = windows.single_mut();

        window.decorations = !window.decorations;

        info!("WINDOW_DECORATIONS: {:?}", window.decorations);
    }
}

/// System:
/// Toggle mouse passthrough.
pub fn toggle_mouse_passthrough(
    keyboard_input: Res<Input<KeyCode>>,
    mut windows: Query<&mut Window>,
) {
    if keyboard_input.just_pressed(KeyCode::P) {
        let mut window = windows.single_mut();
        info!("PASSTHROUGH TOGGLED.: {:?}", window.decorations);

        window.cursor.hit_test = !window.cursor.hit_test;
    }
}

/// System:
/// Toggle camera between 2D and 3D:
//TODO: Maybe do this with scenes?
#[allow(unused_mut, dead_code, unused_variables)]
pub fn switch_camera(
    mut cam3d: Query<&mut Camera, With<Cam3D>>,
    mut cam2d: Query<&mut Camera, With<Cam2D>>,
    mut trigger: EventReader<CamSwitch>,
    keyboard_input: Res<Input<KeyCode>>,
) {
    if keyboard_input.just_pressed(KeyCode::Tab) {
        info!("2d/3d Cam toggle");
    }

    todo!()
}

/// System: Startup, initialises the scene's geometry.
pub fn init_shapes(
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<YourShader>>,
    mut shape_options: ResMut<ShapeOptions>,
) {
    shape_options.0.push((
        false,
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
        true,
        ((
            MaterialMeshBundle {
                mesh: meshes.add(Mesh::from(shape::Cube { size: 2.0 })).clone(),
                transform: Transform::from_xyz(0.0, 0.5, 0.0),
                material: materials.add(crate::shader_utils::YourShader {
                    color: Color::default(),
                }),
                ..default()
            },
            Shape,
        )),
    ));

    shape_options.0.push((
        false,
        ((
            MaterialMeshBundle {
                mesh: meshes.add(
                    shape::Icosphere {
                        radius: 1.40,
                        subdivisions: 23,
                    }
                    .try_into()
                    .unwrap(),
                ),
                transform: Transform::from_xyz(0.0, 0.5, 0.0),
                material: materials.add(crate::shader_utils::YourShader {
                    color: Color::default(),
                }),
                ..default()
            },
            Shape,
        )),
    ));
}

/// System: Startup, initialises the scene's geometry.
pub fn setup(
    mut commands: Commands,
    shape_options: Res<ShapeOptions>,
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<YourShader>>,
) {
    // 3D camera
    commands.spawn((
        Camera3dBundle {
            transform: Transform::from_translation(Vec3::new(0.0, 1.5, 5.0)),
            ..default()
        },
        PanOrbitCamera::default(),
        Cam3D,
    ));

    for matmeshbund in shape_options.0.iter().filter(|v| v.0) {
        commands.spawn(matmeshbund.1.clone());
    }
}
