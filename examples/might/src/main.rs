use bevy::{
    gltf::Gltf,
    log,
    prelude::*,
    render::render_resource::{AsBindGroup},
    shader::ShaderRef,
};

use shadplay::camera::{PanOrbitCamera, PanOrbitCameraPlugin};

use std::f32::consts::*;

/// marker component for our knight
#[derive(Resource, PartialEq, Eq)]
struct Knight {
    handle: Handle<Gltf>,
}

/// marker resource to track whether or not we can spawn the loaded knight asset
#[derive(Resource, PartialEq, Eq)]
struct WasLoaded(bool);

fn main() {
    // Check the knight model is available and if not, show where it can be got.
    // The environment maps used, are automatically downloadable so the shadplay/build.rs fetches them for you.
    let knight_model_path = std::path::Path::new("../assets/scenes/knight.glb");
    if !knight_model_path.exists() {
        dbg!(
            "knight.glb does not exist at {:?}.\nThere's a free non-rigged version available of it here: https://sketchfab.com/3d-models/elysia-knight-d099f11914f445afbe727fe5c3ddd39d or,\nYou can a rigged version purchase here: https://www.artstation.com/marketplace/p/RGmbB/medieval-armor-set-unreal-engine-rigged",
            knight_model_path
        );
    }

    App::new()
        .insert_resource(DirectionalLightShadowMap { size: 4096 })
        .add_plugins((DefaultPlugins, PanOrbitCameraPlugin))
        .add_systems(Startup, setup)
        .add_systems(Update, (animate_light_direction, quit_listener))
        // Our Systems:
        .add_systems(Startup, load_knight)
        .add_systems(
            Update,
            spawn_knight
                .after(load_knight)
                .run_if(resource_exists::<Knight>)
                .run_if(resource_exists_and_equals::<WasLoaded>(WasLoaded(false))),
        )
        // Our Materials
        .add_plugins(MaterialPlugin::<AuraMaterial>::default())
        .run();
}

fn setup(
    mut commands: Commands,
    asset_server: Res<AssetServer>,
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<StandardMaterial>>,
) {
    commands.spawn((
        Camera3d::default(),
        Transform::from_xyz(2.0, 6.0, 6.0).looking_at(Vec3::new(0.0, 0.0, 0.0), Vec3::Y),
        PanOrbitCamera::default(),
        EnvironmentMapLight {
            diffuse_map: asset_server.load("environment_maps/pisa_diffuse_rgb9e5_zstd.ktx2"),
            specular_map: asset_server.load("environment_maps/pisa_specular_rgb9e5_zstd.ktx2"),
            intensity: 1.0,
            ..Default::default()
        },
    ));

    commands.spawn((
        DirectionalLight {
            shadows_enabled: true,
            ..default()
        },
        CascadeShadowConfig {
            num_cascades: 1,
            maximum_distance: 1.6,
            first_cascade_far_bound: 0.1,
            ..default()
        },
    ));

    // ground plane
    commands.spawn((
        Mesh3d(meshes.add(Plane3d::default().mesh().size(50.0, 50.0))),
        MeshMaterial3d(materials.add(StandardMaterial {
            base_color: Color::BLACK,
            perceptual_roughness: 1.0,
            double_sided: false,
            unlit: true,
            ..default()
        })),
    ));
}

// Loads our knight into the asset server, it isn't spawned.
fn load_knight(mut commands: Commands, asset_server: Res<AssetServer>) {
    let hndl = asset_server.load("scenes/knight.glb");
    commands.insert_resource(Knight { handle: hndl });
    commands.insert_resource(WasLoaded(false));

    log::info!("load_knight done.");
}
// Spawns the knight model in.
fn spawn_knight(
    mut commands: Commands,
    knight: Res<Knight>,
    assets_gltf: Res<Assets<Gltf>>,
    mut meshes: ResMut<Assets<Mesh>>,
    mut was_loaded: ResMut<WasLoaded>,
    // mut materials: ResMut<Assets<ExtendedMaterial<StandardMaterial, AuraMaterial>>>,
    mut materials: ResMut<Assets<AuraMaterial>>,
) {
    if let Some(gltf) = assets_gltf.get(&knight.handle) {
        log::info!("Spawning scene...");

        let disc = Mesh::from(Cylinder::new(1.2, 0.001));

        let as_custom_mat = AuraMaterial { inner: 0.0 };

        commands
            .spawn(SceneRoot(gltf.scenes[0].clone()))
            .with_children(|parent| {
                parent.spawn((
                    Mesh3d(meshes.add(disc)),
                    MeshMaterial3d(materials.add(as_custom_mat)),
                ));
            });

        was_loaded.0 = true;

        log::info!("Spawn complete...");
    }
}

// from the bevy load_gltf example
fn animate_light_direction(
    time: Res<Time>,
    mut query: Query<&mut Transform, With<DirectionalLight>>,
) {
    for mut transform in &mut query {
        transform.rotation = Quat::from_euler(
            EulerRot::ZYX,
            0.0,
            time.elapsed_secs() * PI / 5.0,
            -FRAC_PI_4,
        );
    }
}

/// Our Aura shader:
#[derive(Asset, AsBindGroup, TypePath, Debug, Clone)]
pub struct AuraMaterial {
    /// This is currently unused but reserving for future use :wink
    #[uniform(100)]
    inner: f32,
}

impl Material for AuraMaterial {
    fn fragment_shader() -> ShaderRef {
        "shaders/aura.wgsl".into()
    }

    // Available in StandardMaterial
    fn alpha_mode(&self) -> AlphaMode {
        AlphaMode::Blend
    }
}

/// System: listening for `q` or `esc` to quit.
fn quit_listener(input: Res<ButtonInput<KeyCode>>) {
    if input.just_pressed(KeyCode::KeyQ) || input.just_pressed(KeyCode::Escape) {
        std::process::exit(0)
    }
}
