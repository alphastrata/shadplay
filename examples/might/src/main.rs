use bevy::{
    gltf::Gltf,
    log::{self},
    pbr::{
        CascadeShadowConfigBuilder, DirectionalLightShadowMap, ExtendedMaterial, MaterialExtension,
        OpaqueRendererMethod,
    },
    prelude::*,
    render::render_resource::{AsBindGroup, ShaderRef},
};

use bevy_panorbit_camera::PanOrbitCamera;

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
    App::new()
        .insert_resource(DirectionalLightShadowMap { size: 4096 })
        .add_plugins((
            DefaultPlugins,
            #[cfg(debug_assertions)]
            bevy_editor_pls::EditorPlugin::default(),
            bevy_panorbit_camera::PanOrbitCameraPlugin,
        ))
        .add_systems(Startup, setup)
        .add_systems(Update, (animate_light_direction, quit_listener))
        // Our Systems:
        .add_systems(Startup, load_knight)
        .add_systems(
            Update,
            spawn_knight
                .after(load_knight)
                .run_if(resource_exists::<Knight>())
                .run_if(resource_exists_and_equals::<WasLoaded>(WasLoaded(false))),
        )
        // Our Materials
        .add_plugins(MaterialPlugin::<
            ExtendedMaterial<StandardMaterial, AuraMaterial>,
        >::default())
        .run();
}

fn setup(
    mut commands: Commands,
    asset_server: Res<AssetServer>,
    mut meshes: ResMut<Assets<Mesh>>,
    mut materials: ResMut<Assets<StandardMaterial>>,
) {
    commands.spawn((
        Camera3dBundle {
            transform: Transform::from_xyz(2.0, 6.0, 6.0)
                .looking_at(Vec3::new(0.0, 0.0, 0.0), Vec3::Y),
            ..default()
        },
        PanOrbitCamera::default(),
        EnvironmentMapLight {
            diffuse_map: asset_server.load("environment_maps/pisa_diffuse_rgb9e5_zstd.ktx2"),
            specular_map: asset_server.load("environment_maps/pisa_specular_rgb9e5_zstd.ktx2"),
        },
    ));

    commands.spawn(DirectionalLightBundle {
        directional_light: DirectionalLight {
            shadows_enabled: true,
            ..default()
        },
        cascade_shadow_config: CascadeShadowConfigBuilder {
            num_cascades: 1,
            maximum_distance: 1.6,
            ..default()
        }
        .into(),
        ..default()
    });

    // ground plane
    commands.spawn(PbrBundle {
        mesh: meshes.add(shape::Plane::from_size(10.0).into()),
        material: materials.add(StandardMaterial {
            base_color: Color::BLACK,
            perceptual_roughness: 1.0,
            ..default()
        }),
        ..default()
    });
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
    mut materials: ResMut<Assets<ExtendedMaterial<StandardMaterial, AuraMaterial>>>,
) {
    if let Some(gltf) = assets_gltf.get(&knight.handle) {
        log::info!("Spawning scene...");

        let disc = Mesh::from(shape::Cylinder {
            radius: 1.2, //1.2 meters
            height: 0.001,
            resolution: 20,
            segments: 1,
        });

        commands
            .spawn(SceneBundle {
                scene: gltf.scenes[0].clone(),
                ..Default::default()
            })
            .with_children(|parent| {
                parent.spawn(MaterialMeshBundle {
                    mesh: meshes.add(disc),
                    material: materials.add(ExtendedMaterial {
                        base: StandardMaterial {
                            base_color: Color::NONE,
                            opaque_render_method: OpaqueRendererMethod::Auto,
                            // Note: to run in deferred mode, you must also add a `DeferredPrepass` component to the camera and either
                            // change the above to `OpaqueRendererMethod::Deferred` or add the `DefaultOpaqueRendererMethod` resource.
                            ..default()
                        },
                        extension: AuraMaterial { inner: 0.0 },
                    }),
                    ..default()
                });
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
            time.elapsed_seconds() * PI / 5.0,
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

impl MaterialExtension for AuraMaterial {
    fn fragment_shader() -> ShaderRef {
        "shaders/aura.wgsl".into()
    }

    fn deferred_fragment_shader() -> ShaderRef {
        "shaders/aura.wgsl".into()
    }
}

/// System: listening for `q` or `esc` to quit.
fn quit_listener(input: Res<Input<KeyCode>>) {
    if input.just_pressed(KeyCode::Q) || input.just_pressed(KeyCode::Escape) {
        std::process::exit(0)
    }
}

#[derive(Asset, AsBindGroup, TypePath, Debug, Clone)]
struct MyExtension {
    // We need to ensure that the bindings of the base material and the extension do not conflict,
    // so we start from binding slot 100, leaving slots 0-99 for the base material.
    #[uniform(100)]
    quantize_steps: u32,
}

impl MaterialExtension for MyExtension {
    fn fragment_shader() -> ShaderRef {
        "shaders/extended_material.wgsl".into()
    }

    fn deferred_fragment_shader() -> ShaderRef {
        "shaders/extended_material.wgsl".into()
    }
}
