use bevy::{
    input::mouse::{MouseMotion, MouseWheel},
    prelude::*,
};

pub struct PanOrbitCameraPlugin;

impl Plugin for PanOrbitCameraPlugin {
    fn build(&self, app: &mut App) {
        app.add_systems(Update, pan_orbit_camera);
    }
}

#[derive(Component)]
pub struct PanOrbitCamera {
    pub focus: Vec3,
    pub radius: f32,
    pub upside_down: bool,
}

impl Default for PanOrbitCamera {
    fn default() -> Self {
        PanOrbitCamera {
            focus: Vec3::ZERO,
            radius: 5.0,
            upside_down: false,
        }
    }
}

fn pan_orbit_camera(
    windows: Query<&Window>,
    mut ev_motion: EventReader<MouseMotion>,
    mut ev_scroll: EventReader<MouseWheel>,
    input_mouse: Res<ButtonInput<MouseButton>>,
    input_keyboard: Res<ButtonInput<KeyCode>>,
    mut query: Query<(&mut PanOrbitCamera, &mut Transform)>,
) {
    let window = match windows.iter().next() {
        Some(w) => w,
        None => return,
    };
    let mut pan = Vec2::ZERO;
    let mut rotation_move = Vec2::ZERO;
    let mut scroll = 0.0;
    let orbit_button_changed = false;

    if input_mouse.pressed(MouseButton::Left) {
        ev_motion.read().for_each(|ev| rotation_move += ev.delta);
    }

    if input_mouse.pressed(MouseButton::Right) {
        ev_motion.read().for_each(|ev| pan += ev.delta);
    }

    ev_scroll.read().for_each(|ev| scroll += ev.y);

    if input_keyboard.pressed(KeyCode::ArrowUp) {
        pan.y -= 1.0;
    }
    if input_keyboard.pressed(KeyCode::ArrowDown) {
        pan.y += 1.0;
    }
    if input_keyboard.pressed(KeyCode::ArrowLeft) {
        pan.x -= 1.0;
    }
    if input_keyboard.pressed(KeyCode::ArrowRight) {
        pan.x += 1.0;
    }

    query.iter_mut().for_each(|(mut pan_orbit, mut transform)| {
        if orbit_button_changed {
            let up = transform.rotation * Vec3::Y;
            pan_orbit.upside_down = up.y <= 0.0;
        }

        let mut any = false;
        if rotation_move.length_squared() > 0.0 {
            any = true;
            let window_size = Vec2::new(window.width(), window.height());
            let delta_x = {
                let delta = rotation_move.x / window_size.x * std::f32::consts::PI * 2.0;
                if pan_orbit.upside_down { -delta } else { delta }
            };
            let delta_y = rotation_move.y / window_size.y * std::f32::consts::PI;
            let yaw = Quat::from_rotation_y(-delta_x);
            let pitch = Quat::from_rotation_x(-delta_y);
            transform.rotation = yaw * transform.rotation;
            transform.rotation *= pitch;
        } else if pan.length_squared() > 0.0 {
            any = true;
            let window_size = Vec2::new(window.width(), window.height());
            let pan_x = pan.x / window_size.x * pan_orbit.radius;
            let pan_y = pan.y / window_size.y * pan_orbit.radius;
            let right = transform.rotation * Vec3::X * -pan_x;
            let up = transform.rotation * Vec3::Y * pan_y;
            let translation = right + up;
            pan_orbit.focus += translation;
        } else if scroll.abs() > 0.0 {
            any = true;
            pan_orbit.radius -= scroll * pan_orbit.radius * 0.2;
            pan_orbit.radius = f32::max(pan_orbit.radius, 0.05);
        }

        if any {
            let rot_matrix = Mat3::from_quat(transform.rotation);
            transform.translation =
                pan_orbit.focus + rot_matrix.mul_vec3(Vec3::new(0.0, 0.0, pan_orbit.radius));
        }
    });
}
