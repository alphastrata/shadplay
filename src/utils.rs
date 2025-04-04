use bevy::{
    math::sampling::mesh_sampling,
    prelude::*,
    window::{PrimaryWindow, RequestRedraw, Window, WindowLevel},
    winit::WinitWindows,
};
use bevy_panorbit_camera::PanOrbitCamera;

use crate::{prelude::*, shader_utils::YourShader};
/// State: Used to transition between 2d and 3d mode.    
/// Used by: cam_switch_system, screenshot
#[derive(Debug, Clone, Copy, Default, Eq, PartialEq, Hash, States)]
pub enum AppState {
    // Startup,
    #[default]
    TwoD,
    ThreeD,
    GifCapture,
}

/// Component: Marking shapes that we spawn.
/// Used by: the rotate system.
#[derive(Component, Clone, Default)]
pub struct Shape;

/// Component: Marking the 2d geometry we use inplace of a custom vertex shader.
/// Used by: size_quad
#[derive(Component)]
pub struct BillBoardQuad;

/// Component: Marking the 3d camera.
/// Used by: the CamSwitch event.
#[derive(Component)]
pub struct Cam3D;

/// Component: Marking the 2d camera.
/// Used by: the CamSwitch event.
#[derive(Component)]
pub struct Cam2D;

/// Resource: Holds the current monitor, and a list of the others' [`winit::monitor::MonitorHandle`](s), info, we go outside of bevy to get these,
/// pre-startup so, they cannot be reasonably updated yet..
#[derive(Resource, Default, Deref, DerefMut)]
pub struct MonitorsSpecs {
    // Index of the current primary monitor (at app startup)
    pub current: (u32, u32), // max-width, max-height
}
impl MonitorsSpecs {
    pub fn get(&self) -> (f32, f32) {
        (self.current.0 as f32, self.current.1 as f32)
    }

    // self.x as f32
    pub fn x(&self) -> f32 {
        self.current.0 as f32
    }

    // self.y as f32
    pub fn y(&self) -> f32 {
        self.current.1 as f32
    }

    // self.xy as Vec2
    pub fn xy(&self) -> Vec2 {
        Vec2 {
            x: self.x(),
            y: self.y(),
        }
    }
}

/// Resource: Used for toggling on/off the transparency of the app.
#[derive(Resource, DerefMut, Deref)]
pub struct TransparencySet(pub bool);

/// Resource: Used to ensure the mouse, when passed to the 2d Shader cannot go stupidly out of bounds.
#[derive(Resource, DerefMut, Deref, Default, Debug)]
pub struct ShadplayWindowDims(pub Vec2);
impl ShadplayWindowDims {
    // is the mouse 'in' the shadplay window?
    pub(crate) fn hittest(&self, mouse_in: Vec2) -> bool {
        std::ops::Range {
            start: 0.0,
            end: self.x,
        }
        .contains(&mouse_in.x)
            || std::ops::Range {
                start: 0.0,
                end: self.y,
            }
            .contains(&mouse_in.y)
    }

    /// Normalise the width (0) and height (1) on Self, to -0.5, to 0.5
    pub(crate) fn to_uv(&self, xy: Vec2) -> Vec2 {
        Vec2 {
            x: xy.x / (self.x / 2.0) - 1.0,
            y: xy.y / (self.y / 2.0) - 1.0,
        }
    }
}

/// Resource: All the shapes we have the option of displaying. 3d Only.
#[allow(clippy::type_complexity)]
#[derive(Resource, Default)]
pub struct ShapeOptions(
    pub  Vec<(
        bool,
        Handle<Mesh>,
        Handle<YourShader>,
        bevy::prelude::Transform,
        utils::Shape,
    )>,
);

/// Resource: Tracking whether or not we're rotating our shapes. 3d only.
#[derive(Debug, Resource, Default, PartialEq)]
pub struct Rotating(pub bool);

/// System: to toggle on/off the rotating, 3d only.
pub fn toggle_rotate(input: Res<ButtonInput<KeyCode>>, mut toggle: ResMut<Rotating>) {
    if input.just_pressed(KeyCode::KeyR) {
        toggle.0 = !toggle.0;
        info!("Togling rotate to {toggle:#?}");
    }
}

/// System: Rotates the currently active geometry in the scene, 3d only.
pub fn rotate(mut query: Query<&mut Transform, With<Shape>>, time: Res<Time>) {
    for mut transform in &mut query {
        transform.rotate_local_z(time.delta_secs() * 0.25);
        transform.rotate_local_x(time.delta_secs() * 0.33);
        transform.rotate_y(time.delta_secs() * 0.250);
    }
}

/// System:
/// Move between always on bottom, always on top and just, 'normal' window modes, by hitting the 'L' key.
pub fn switch_level(input: Res<ButtonInput<KeyCode>>, mut windows: Query<&mut Window>) {
    //TODO: move logic to helper func and have this trigger on key or Event.
    if input.just_pressed(KeyCode::KeyL) {
        let mut window = match windows.single_mut() {
            Ok(w) => w,
            Err(e) => {
                error!("No primary window found {}", e);
                return;
            }
        };

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
pub fn quit(input: Res<ButtonInput<KeyCode>>) {
    if input.just_pressed(KeyCode::KeyQ) {
        std::process::exit(0)
    }
}

/// System:
/// Toggles the window's transparency (on supported OS')
pub fn toggle_transparency(
    input: Res<ButtonInput<KeyCode>>,
    mut clear_colour: ResMut<ClearColor>,
    mut transparency_set: ResMut<TransparencySet>,
    mut _windows: Query<&mut Window>,
    mut event: EventWriter<RequestRedraw>,
) {
    if input.just_pressed(KeyCode::KeyO) {
        // let mut window = windows.single_mut();
        // window.transparent = !window.transparent; // Not supported after creation.
        if **transparency_set {
            *clear_colour = ClearColor(Color::BLACK);
        } else {
            *clear_colour = ClearColor(Color::NONE);
        }
        **transparency_set = !**transparency_set;
        event.write(RequestRedraw);
    }
}

/// System: Runs in [`AppState::ThreeD`] only.
/// Switch the shape we're currently playing with a shader on.
pub fn switch_shape(
    input: Res<ButtonInput<KeyCode>>,
    mut shape_options: ResMut<ShapeOptions>,
    mut commands: Commands,
    query: Query<Entity, With<Shape>>,
) {
    if input.just_pressed(KeyCode::KeyS) {
        info!("Shape change requested...");
        // Old
        let Some(idx) = shape_options.0.iter().position(|v| v.0) else {
            return;
        };
        shape_options.0[idx].0 = false;
        query.iter().for_each(|e| commands.entity(e).despawn());

        // New
        let next = (idx + 1) % shape_options.0.len();
        let (_vis, mesh_handle, mat_handle, tf, shp) = &shape_options.0[next];
        commands.spawn((
            Mesh3d(mesh_handle.clone_weak()),
            MeshMaterial3d(mat_handle.clone_weak()),
            *tf,
            shp.clone(),
        ));
        shape_options.0[next].0 = true;
        info!("shape change complete");
    }
}

/// System:
/// Toggle the app's window decorations (the titlebar at the top with th close/minimise buttons etc);
pub fn toggle_decorations(input: Res<ButtonInput<KeyCode>>, mut windows: Query<&mut Window>) {
    if input.just_pressed(KeyCode::KeyD) {
        let mut window = match windows.single_mut() {
            Ok(w) => w,
            Err(e) => {
                error!("No primary window found {}", e);
                return;
            }
        };
        window.decorations = !window.decorations;

        info!("WINDOW_DECORATIONS: {:?}", window.decorations);
    }
}

/// System:
/// Toggle mouse passthrough.
/// This is ONLY supported on Windows.
#[cfg(target_os = "windows")]
pub fn toggle_window_passthrough(
    keyboard_input: Res<ButtonInput<KeyCode>>,
    mut windows: Query<&mut Window>,
) {
    if keyboard_input.just_pressed(KeyCode::KeyX) {
        let mut window = match windows.single_mut() {
            Ok(w) => w,
            Err(e) => {
                error!("No primary window found {}", e);
                return;
            }
        };
        debug!("PASSTHROUGH TOGGLED.: {:?}", window.decorations);

        window.cursor_options.hit_test = !window.cursor_options.hit_test;
    }
}

/// System: Startup, initialises the scene's geometry. 3d only.
pub fn init_shapes(
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<YourShader>>,
    mut shape_options: ResMut<ShapeOptions>,
    mut user_textures: ResMut<TexHandleQueue>,
    asset_server: Res<AssetServer>,
) {
    let texture: Handle<Image> = asset_server.load("textures/space.jpg");
    user_textures.insert(0, texture.clone());
    let mat = materials.add(YourShader {
        color: Color::default().into(),
        img: texture.clone(),
    });
    info!("{texture:#?} (space.jpg) texture added!");

    shape_options.0.push((
        false,
        meshes.add(Mesh::from(Torus {
            major_radius: 2.0,
            minor_radius: 0.3,
        })),
        mat.clone(),
        Transform::from_xyz(0.0, 0.3, 0.0),
        Shape,
    ));
    info!("Torus added");

    shape_options.0.push((
        true,
        meshes.add(Mesh::from(Cuboid::default())),
        mat.clone(),
        Transform::from_xyz(0.0, 0.3, 0.0),
        Shape,
    ));
    info!("Cube added");

    shape_options.0.push((
        false,
        meshes.add(Sphere::default()),
        mat.clone(),
        Transform::from_xyz(0.0, 0.3, 0.0),
        Shape,
    ));
    info!("Sphere added");

    info!("Shapes initialised!");
}

/// System: Setup 3d Camera. Called on entry of [`AppState::ThreeD`]
pub fn setup_3d(mut commands: Commands, shape_options: Res<ShapeOptions>) {
    // 3D camera
    commands.spawn((
        Name::new("Cam3D"),
        Camera3d::default(),
        Transform::from_xyz(-2.0, 2.5, 5.0).looking_at(Vec3::ZERO, Vec3::Y),
    ));
    info!("Spawned Cam3d");

    assert!(!shape_options.0.is_empty());
    assert_eq!(shape_options.0.len(), 3);
    shape_options.0.iter().filter(|vis| vis.0).for_each(
        |(_vis, mesh_handle, mat_handle, tf, shp)| {
            commands.spawn(
                //
                (
                    Mesh3d(mesh_handle.clone_weak()),
                    MeshMaterial3d(mat_handle.clone_weak()),
                    *tf,
                    shp.clone(),
                ), //
            );

            info!("Spawned mesh");
        },
    );
}

/// System: Cleans up the 3d camera. Called on exit of [`AppState::ThreeD`]
pub fn cleanup_3d(
    mut commands: Commands,
    mut cam_q: Query<(Entity, &mut Camera)>,
    mut shape_q: Query<(Entity, &Transform), With<Shape>>,
) {
    for (ent, _cam) in cam_q.iter_mut() {
        commands.entity(ent).despawn();
        info!("Despawned 3D camera.")
    }
    for (ent, _tf) in shape_q.iter_mut() {
        commands.entity(ent).despawn();
        info!("Despawned shape.")
    }
}

/// System: Cleans up the 2d camera. Called on exit of [`AppState::TwoD`]
pub fn cleanup_2d(mut commands: Commands, mut cam_q: Query<(Entity, &mut Camera)>) {
    for (ent, _q) in cam_q.iter_mut() {
        commands.entity(ent).despawn();
        info!("Despawned 2D camera.")
    }
}

/// System: switches between 3d and 2d cameras, by triggering the [`AppState::XYZ`] transitions.
pub fn cam_switch_system(
    mut next_state: ResMut<NextState<AppState>>,
    keyboard_input: Res<ButtonInput<KeyCode>>,
) {
    if keyboard_input.pressed(KeyCode::KeyT) {
        info!("Swapping to 2D");
        next_state.set(AppState::TwoD)
    }
    if keyboard_input.pressed(KeyCode::KeyH) {
        info!("Swapping to 3D");
        next_state.set(AppState::ThreeD)
    }
}

/// System: initialises 2d Camera. Called on entry of [`AppState::TwoD`]
/// NOTE: this also initialises the [`TexHandleQueue`], the default texture is bound to 0 by this system on startup.
pub fn setup_2d(
    mut commands: Commands,
    mut meshes: ResMut<Assets<Mesh>>,
    mut your_shader: ResMut<Assets<YourShader2D>>,
    mut msd: ResMut<ShadplayWindowDims>,
    mut user_textures: ResMut<TexHandleQueue>,
    asset_server: Res<AssetServer>,
    windows: Query<&Window>,
) {
    //FIXME:
    // TODO: hoist this into its own startup initialiser.
    let texture: Handle<Image> = asset_server.load("textures/space.jpg");
    user_textures.insert(0, texture.clone());

    // 2D camera
    commands.spawn((Camera2d, Cam2D));
    info!("Spawned 2d Cam");

    let win = windows
        .single()
        .expect("Should be impossible to NOT get a window");
    let (width, height) = (win.width(), win.height());

    *msd = ShadplayWindowDims(Vec2 {
        x: width / 2.0,
        y: height / 2.0,
    });

    info!("Set MaxSceenDims set to {width}, {height}");

    // Quad
    commands.spawn((
        Mesh2d(meshes.add(Rectangle::default())),
        MeshMaterial2d(your_shader.add(YourShader2D {
            img: texture,
            mouse_pos: MousePos { x: 100.0, y: 128.0 },
        })),
        Transform::from_translation(Vec3::ZERO),
        BillBoardQuad,
    ));
}

/// System: Runs only when in [`AppState::TwoD`]
/// Resize the quad such that it's always the width/height of the viewport when in 2D mode.
pub fn size_quad(
    windows: Query<&Window>,
    mut query: Query<&mut Transform, With<BillBoardQuad>>,
    mut msd: ResMut<ShadplayWindowDims>,
    // monitors: Res<MonitorsSpecs>,
) {
    let win = windows
        .single()
        .expect("Should be impossible to NOT get a window");

    let (width, height) = (win.width(), win.height());

    query.iter_mut().for_each(|mut transform| {
        *msd = ShadplayWindowDims(Vec2 {
            x: width,
            y: height,
        });

        transform.scale = Vec3::new(width * 0.95, height * 0.95, 1.0);
        info!("Window Resized, resizing quad");
    });
}

// Monitor Maximum Res.
pub fn max_mon_res(
    window_query: Query<Entity, With<Window>>,
    winit_windows: NonSend<WinitWindows>,
    mut mon_specs: ResMut<MonitorsSpecs>,
) {
    let Ok(entity) = window_query.single() else {
        error!("Unable to pull single Window, this is a horrible thing to have happen.");
        return;
    };
    if let Some(winit_window) = winit_windows.get_window(entity) {
        let current_monitor = winit_window.current_monitor().unwrap();
        let (w, h) = (current_monitor.size().width, current_monitor.size().height);
        *mon_specs = MonitorsSpecs { current: (w, h) };
    }
}
pub fn update_mouse_pos(
    window: Query<&Window, With<PrimaryWindow>>,
    mut shader_mat: ResMut<Assets<YourShader2D>>,
    shadplay_win_dims: Res<ShadplayWindowDims>,
) {
    let win = match window.single() {
        Ok(w) => w,
        Err(_) => return,
    };

    let mouse_xy = match win.physical_cursor_position() {
        Some(pos) => pos,
        None => return,
    };

    // Is the mouse on our window?
    if shadplay_win_dims.hittest(mouse_xy) {
        if let Some((_, shad_mat)) = shader_mat.iter_mut().next() {
            let sh_xy = shadplay_win_dims.to_uv(mouse_xy);
            shad_mat.mouse_pos = sh_xy.into();
        }
    }
}

impl From<Vec2> for MousePos {
    fn from(value: Vec2) -> Self {
        MousePos {
            x: value.x,
            y: value.y,
        }
    }
}
