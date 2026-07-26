use crate::camera::PanOrbitCamera;
use std::path::{Path, PathBuf};
use bevy::{
    math::sampling::mesh_sampling,
    prelude::*,
    window::{PrimaryWindow, RequestRedraw, Window, WindowLevel},
    winit::WinitWindows,
};

use crate::{prelude::*, shader_utils::YourShader};

#[derive(Debug, Clone, Copy, Default, Eq, PartialEq, Hash, States)]
pub enum AppState {
    #[default]
    TwoD,
    ThreeD,
    GifCapture,
}

#[derive(Component, Clone, Default)]
pub struct Shape;

#[derive(Component)]
pub struct BillBoardQuad;

#[derive(Component)]
pub struct Cam3D;

#[derive(Component)]
pub struct Cam2D;

#[derive(Resource, Default, Deref, DerefMut)]
pub struct MonitorsSpecs {
    pub current: (u32, u32),
}
impl MonitorsSpecs {
    pub fn get(&self) -> (f32, f32) {
        (self.current.0 as f32, self.current.1 as f32)
    }

    pub fn x(&self) -> f32 {
        self.current.0 as f32
    }

    pub fn y(&self) -> f32 {
        self.current.1 as f32
    }

    pub fn xy(&self) -> Vec2 {
        Vec2 {
            x: self.x(),
            y: self.y(),
        }
    }
}

#[derive(Resource, DerefMut, Deref)]
pub struct TransparencySet(pub bool);

#[derive(Resource, DerefMut, Deref, Default, Debug)]
pub struct ShadplayWindowDims(pub Vec2);
impl ShadplayWindowDims {
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

    pub(crate) fn to_uv(&self, xy: Vec2) -> Vec2 {
        Vec2 {
            x: xy.x / (self.x / 2.0) - 1.0,
            y: xy.y / (self.y / 2.0) - 1.0,
        }
    }
}

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

#[derive(Debug, Resource, Default, PartialEq)]
pub struct Rotating(pub bool);

pub fn toggle_rotate(input: Res<ButtonInput<KeyCode>>, mut toggle: ResMut<Rotating>) {
    if input.just_pressed(KeyCode::KeyR) {
        toggle.0 = !toggle.0;
        info!("Togling rotate to {toggle:#?}");
    }
}

pub fn rotate(mut query: Query<&mut Transform, With<Shape>>, time: Res<Time>) {
    query.iter_mut().for_each(|mut transform| {
        transform.rotate_local_z(time.delta_secs() * 0.25);
        transform.rotate_local_x(time.delta_secs() * 0.33);
        transform.rotate_y(time.delta_secs() * 0.250);
    });
}

pub fn switch_level(input: Res<ButtonInput<KeyCode>>, mut windows: Query<&mut Window>) {
    if input.just_pressed(KeyCode::KeyL) {
        let mut window = match windows.iter_mut().next() {
            Some(w) => w,
            None => {
                error!("No primary window found");
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

pub fn quit(input: Res<ButtonInput<KeyCode>>) {
    if input.just_pressed(KeyCode::KeyQ) {
        std::process::exit(0)
    }
}

pub fn toggle_transparency(
    input: Res<ButtonInput<KeyCode>>,
    mut clear_colour: ResMut<ClearColor>,
    mut transparency_set: ResMut<TransparencySet>,
    mut _windows: Query<&mut Window>,
    mut event: EventWriter<RequestRedraw>,
) {
    if input.just_pressed(KeyCode::KeyO) {
        if **transparency_set {
            *clear_colour = ClearColor(Color::BLACK);
        } else {
            *clear_colour = ClearColor(Color::NONE);
        }
        **transparency_set = !**transparency_set;
        event.write(RequestRedraw);
    }
}

pub fn switch_shape(
    input: Res<ButtonInput<KeyCode>>,
    mut shape_options: ResMut<ShapeOptions>,
    mut commands: Commands,
    query: Query<Entity, With<Shape>>,
) {
    if input.just_pressed(KeyCode::KeyS) {
        info!("Shape change requested...");
        let Some(idx) = shape_options.0.iter().position(|v| v.0) else {
            return;
        };
        shape_options.0[idx].0 = false;
        query.iter().for_each(|e| commands.entity(e).despawn());

        let next = (idx + 1) % shape_options.0.len();
        let (_vis, mesh_handle, mat_handle, tf, shp) = &shape_options.0[next];
        commands.spawn((
            Mesh3d(mesh_handle.clone()),
            MeshMaterial3d(mat_handle.clone()),
            *tf,
            shp.clone(),
        ));
        shape_options.0[next].0 = true;
        info!("shape change complete");
    }
}

pub fn toggle_decorations(input: Res<ButtonInput<KeyCode>>, mut windows: Query<&mut Window>) {
    if input.just_pressed(KeyCode::KeyD) {
        let mut window = match windows.iter_mut().next() {
            Some(w) => w,
            None => {
                error!("No primary window found");
                return;
            }
        };
        window.decorations = !window.decorations;
        info!("WINDOW_DECORATIONS: {:?}", window.decorations);
    }
}

#[cfg(target_os = "windows")]
pub fn toggle_window_passthrough(
    keyboard_input: Res<ButtonInput<KeyCode>>,
    mut windows: Query<&mut Window>,
) {
    if keyboard_input.just_pressed(KeyCode::KeyP) {
        let mut window = windows.iter_mut().next().unwrap();
        info!("PASSTHROUGH TOGGLED.: {:?}", window.decorations);
    }

    if keyboard_input.just_pressed(KeyCode::KeyX) {
        let mut window = match windows.iter_mut().next() {
            Some(w) => w,
            None => {
                error!("No primary window found");
                return;
            }
        };
        debug!("PASSTHROUGH TOGGLED.: {:?}", window.decorations);
        window.cursor.hit_test = !window.cursor.hit_test;
    }
}

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

pub fn setup_3d(mut commands: Commands, shape_options: Res<ShapeOptions>) {
    commands.spawn((
        Name::new("Cam3D"),
        Camera3d::default(),
        PanOrbitCamera::default(),
        Transform::from_xyz(-2.0, 2.5, 5.0).looking_at(Vec3::ZERO, Vec3::Y),
    ));
    info!("Spawned Cam3d");

    assert!(!shape_options.0.is_empty());
    assert_eq!(shape_options.0.len(), 3);
    shape_options.0.iter().filter(|vis| vis.0).for_each(
        |(_vis, mesh_handle, mat_handle, tf, shp)| {
            commands.spawn((
                Mesh3d(mesh_handle.clone()),
                MeshMaterial3d(mat_handle.clone()),
                *tf,
                shp.clone(),
            ));
            info!("Spawned mesh");
        },
    );
}

pub fn cleanup_3d(
    mut commands: Commands,
    mut cam_q: Query<(Entity, &mut Camera)>,
    mut shape_q: Query<(Entity, &Transform), With<Shape>>,
) {
    cam_q.iter_mut().for_each(|(ent, _cam)| {
        commands.entity(ent).despawn();
        info!("Despawned 3D camera.")
    });
    shape_q.iter_mut().for_each(|(ent, _tf)| {
        commands.entity(ent).despawn();
        info!("Despawned shape.")
    });
}

pub fn cleanup_2d(mut commands: Commands, mut cam_q: Query<(Entity, &mut Camera)>) {
    cam_q.iter_mut().for_each(|(ent, _q)| {
        commands.entity(ent).despawn();
        info!("Despawned 2D camera.")
    });
}

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

pub fn setup_2d(
    mut commands: Commands,
    mut meshes: ResMut<Assets<Mesh>>,
    mut your_shader: ResMut<Assets<YourShader2D>>,
    mut msd: ResMut<ShadplayWindowDims>,
    mut user_textures: ResMut<TexHandleQueue>,
    asset_server: Res<AssetServer>,
    windows: Query<&Window>,
) {
    let texture: Handle<Image> = asset_server.load("textures/space.jpg");
    user_textures.insert(0, texture.clone());

    commands.spawn((Camera2d, Cam2D));
    info!("Spawned 2d Cam");

    let win = windows
        .iter()
        .next()
        .expect("Should be impossible to NOT get a window");
    let (width, height) = (win.width(), win.height());

    *msd = ShadplayWindowDims(Vec2 {
        x: width / 2.0,
        y: height / 2.0,
    });

    info!("Set MaxSceenDims set to {width}, {height}");

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

pub fn size_quad(
    windows: Query<&Window>,
    mut query: Query<&mut Transform, With<BillBoardQuad>>,
    mut msd: ResMut<ShadplayWindowDims>,
) {
    let win = windows
        .iter()
        .next()
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

pub fn max_mon_res(
    window_query: Query<Entity, With<Window>>,
    winit_windows: NonSend<WinitWindows>,
    mut mon_specs: ResMut<MonitorsSpecs>,
) {
    let Ok(entity) = window_query.iter().next().ok_or(()) else {
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
    let win = match window.iter().next() {
        Some(w) => w,
        None => return,
    };

    let mouse_xy = match win.physical_cursor_position() {
        Some(pos) => pos,
        None => return,
    };

    if shadplay_win_dims.hittest(mouse_xy)
        && let Some((_, shad_mat)) = shader_mat.iter_mut().next() {
            let sh_xy = shadplay_win_dims.to_uv(mouse_xy);
            shad_mat.mouse_pos = sh_xy.into();
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

// ---- ---- ---- ---- ---- ---- ---- ---- ----
// Screensaver mode
// ---- ---- ---- ---- ---- ---- ---- ---- ----

#[derive(Resource)]
pub struct ScreensaverState {
    pub shaders: Vec<PathBuf>,
    pub index: usize,
    pub interval: f32,
}

pub fn detect_shader_type(shader_content: &str) -> bool {
    let mut is_2d_score = 0;
    let mut is_3d_score = 0;

    if shader_content.contains("bevy_sprite::mesh2d_view_bindings") {
        is_2d_score += 1000;
    }
    if shader_content.contains("bevy_sprite::mesh2d_vertex_output") {
        is_2d_score += 1000;
    }
    if shader_content.contains("mesh2d_") {
        is_2d_score += 500;
    }
    if shader_content.contains("bevy_pbr::") {
        is_3d_score += 1000;
    }
    if shader_content.contains("forward_io") {
        is_3d_score += 500;
    }
    if shader_content.contains("mesh_view_bindings") {
        is_3d_score += 300;
    }
    if shader_content.contains("bevy_sprite::") {
        is_2d_score += 100;
    }
    if shader_content.contains("VertexOutput") && shader_content.contains("bevy_sprite::") {
        is_2d_score += 200;
    }

    is_2d_score > is_3d_score
}

pub fn apply_shader_file(path: &Path) -> Result<(), Box<dyn std::error::Error>> {
    let content = std::fs::read_to_string(path)?;
    let is_2d = detect_shader_type(&content);
    let target = if is_2d {
        "assets/shaders/myshader_2d.wgsl"
    } else {
        "assets/shaders/myshader.wgsl"
    };
    std::fs::write(target, &content)?;
    Ok(())
}

pub fn screensaver_cycle(
    mut local_timer: Local<f32>,
    time: Res<Time>,
    mut state: ResMut<ScreensaverState>,
) {
    if state.shaders.is_empty() {
        return;
    }
    *local_timer += time.delta_secs();
    if *local_timer < state.interval {
        return;
    }
    *local_timer = 0.0;

    let path = &state.shaders[state.index];
    if let Err(e) = apply_shader_file(path) {
        error!("screensaver: failed to load shader {}: {}", path.display(), e);
    }
    state.index = (state.index + 1) % state.shaders.len();
}

pub fn screensaver_exit(
    keyboard: Res<ButtonInput<KeyCode>>,
    mouse_buttons: Res<ButtonInput<MouseButton>>,
    mut mouse_motion: EventReader<bevy::input::mouse::MouseMotion>,
) {
    if keyboard.get_just_pressed().next().is_some() {
        std::process::exit(0);
    }
    if mouse_buttons.get_just_pressed().next().is_some() {
        std::process::exit(0);
    }
    mouse_motion.read().for_each(|ev| {
        if ev.delta.length_squared() > 0.0 {
            std::process::exit(0);
        }
    });
}

pub fn screensaver_hide_cursor(mut cursors: Query<&mut bevy::window::Cursor>) {
    if let Ok(mut cursor) = cursors.iter_mut().next() {
        cursor.visible = false;
    }
}
