#![allow(unused_imports, dead_code, unused_variables)]
use bevy::{
    gltf::{Gltf, GltfMesh},
    log::{self, LogPlugin},
    pbr::{CascadeShadowConfigBuilder, DirectionalLightShadowMap},
    prelude::*,
    render::render_resource::{AsBindGroup, ShaderRef},
};
use bevy_editor_pls::prelude::*;
use bevy_panorbit_camera::{PanOrbitCamera, PanOrbitCameraPlugin};

use std::f32::consts::*;

/// marker component for our knight
#[derive(Resource, PartialEq, Eq)]
struct Knight {
    handle: Handle<Gltf>,
}

#[derive(Resource, PartialEq, Eq)]
struct WasLoaded(bool);

/// A handle to the mesh we're going to attach our aura too
#[derive(Resource, Default)]
struct AuraMesh {
    mesh: Option<Handle<GltfMesh>>,
    mat: Option<Handle<AuraMaterial>>,
}

fn main() {
    App::new()
        .insert_resource(DirectionalLightShadowMap { size: 4096 })
        .add_plugins((
            DefaultPlugins,
            #[cfg(debug_assertions)]
            EditorPlugin::default(),
            PanOrbitCameraPlugin,
        ))
        .add_systems(Startup, setup)
        .add_systems(Update, animate_light_direction)
        // Our Systems:
        .add_systems(Startup, setup_aura_mats)
        .add_systems(Startup, load_knight)
        .add_systems(
            Update,
            spawn_knight
                .after(load_knight)
                .run_if(resource_exists::<Knight>())
                .run_if(resource_exists_and_equals::<WasLoaded>(WasLoaded(false))),
        )
        // All the times
        // .add_systems(Update, update_aura_mat)
        // Our Materials
        .add_plugins(MaterialPlugin::<AuraMaterial>::default())
        // our resources
        .insert_resource(AuraMesh::default())
        .run();
}

fn setup(mut commands: Commands, asset_server: Res<AssetServer>) {
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
}

// Loads our knight into the asset server, it isn't spawned.
fn load_knight(mut commands: Commands, asset_server: Res<AssetServer>) {
    // let hndl = asset_server.load("scenes/untitled.glb#Scene0");
    let hndl = asset_server.load("scenes/untitled.glb");
    commands.insert_resource(Knight { handle: hndl });
    commands.insert_resource(WasLoaded(false));

    log::info!("load_knight done.");
}
fn spawn_knight(
    mut commands: Commands,
    knight: Res<Knight>,
    assets_gltf: Res<Assets<Gltf>>,
    mut meshes: ResMut<Assets<Mesh>>,
    mut was_loaded: ResMut<WasLoaded>,
    mut materials: ResMut<Assets<AuraMaterial>>,
) {
    if let Some(gltf) = assets_gltf.get(&knight.handle) {
        log::info!("Spawning scene...");
        commands
            .spawn(SceneBundle {
                scene: gltf.scenes[0].clone(),
                ..Default::default()
            })
            .with_children(|parent| {
                parent.spawn(MaterialMeshBundle {
                    mesh: meshes.add(Mesh::from(shape::Cylinder {
                        radius: 1.2, //1.2 meters
                        height: 0.001,
                        resolution: 20,
                        segments: 1,
                    })),
                    material: materials.add(AuraMaterial {
                        color: Color::WHITE,
                    }),
                    ..Default::default()
                });
            });

        was_loaded.0 = true;

        log::info!("Spawn complete...");
    }
}

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

/// Shield shader:
#[derive(AsBindGroup, Debug, Clone, Asset, TypePath)]
pub struct AuraMaterial {
    // Uniform bindings must implement `ShaderType`, which will be used to convert the value to
    // its shader-compatible equivalent. Most core math types already implement `ShaderType`.
    #[uniform(0)]
    color: Color,
    // Images can be bound as textures in shaders. If the Image's sampler is also needed, just
    // add the sampler attribute with a different binding index.
    // #[texture(1)]
    // #[sampler(2)]
    // color_texture: Handle<Image>,
}

// All functions on `Material` have default impls. You only need to implement the
// functions that are relevant for your material.
impl Material for AuraMaterial {
    fn fragment_shader() -> ShaderRef {
        "shaders/aura.wgsl".into()
    }
}

//  Spawn an entity using `CustomMaterial`.
fn setup_aura_mats(mut commands: Commands, mut materials: ResMut<Assets<AuraMaterial>>) {
    commands.spawn(MaterialMeshBundle {
        material: materials.add(AuraMaterial { color: Color::RED }),
        ..Default::default()
    });
}
