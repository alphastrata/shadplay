use std::env;
use std::fs::{self, File};
use std::io::Write;
use std::path::{Path, PathBuf};
use std::process::exit;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    // Clone the Bevy repository
    if !PathBuf::from("bevy").exists()
        && !std::process::Command::new("git")
            .args(["clone", "https://github.com/bevyengine/bevy"])
            .status()
            .expect("Failed to execute git clone command")
            .success()
    {
        eprintln!("Failed to clone Bevy repository.\nShadplay makes a copy of the bevy codebase here to help generate documentation for you, if you don't want that modify _this_ file `./shadplay/build.rs`");

        exit(1);
    }

    // Collect paths of all .wgsl files using `glob` crate
    let wgsl_files = glob::glob("bevy/**/*.wgsl")
        .expect("Failed to read .wgsl files")
        .filter_map(Result::ok);

    // Create the 'bevy_shaders' directory
    fs::create_dir_all("bevy_shaders").expect("Failed to create 'bevy_shaders' directory");

    // Move the .wgsl files to the 'bevy_shaders' directory
    wgsl_files.into_iter().for_each(|path| {
        let filename = path.file_name().expect("Failed to get filename");
        let destination = format!("bevy_shaders/{}", filename.to_string_lossy());
        fs::rename(path, destination).expect("Failed to move file");
    });

    let current_dir = env::current_dir()?;
    println!("Current directory: {:?}", current_dir);

    let urls = [
        "https://raw.githubusercontent.com/bevyengine/bevy/main/assets/environment_maps/pisa_diffuse_rgb9e5_zstd.ktx2",
        "https://raw.githubusercontent.com/bevyengine/bevy/main/assets/environment_maps/pisa_specular_rgb9e5_zstd.ktx2",
        "https://raw.githubusercontent.com/bevyengine/bevy/main/assets/environment_maps/info.txt",
    ];

    let out_dirs = vec!["../assets/environment_maps", "../assets/scenes"];

    for dir in out_dirs {
        fs::create_dir_all(dir)?;
    }

    for url in urls.iter() {
        let filename = Path::new(url).file_name().unwrap();
        let filepath = Path::new("assets/environment_maps").join(filename);

        // Check if the file already exists
        if !filepath.exists() {
            let response = reqwest::get(url.to_string()).await?.bytes().await?;
            let mut file = File::create(&filepath)?;
            file.write_all(&response)?;
            dbg!("Downloaded and saved: {:?}", filepath);
        } else {
            dbg!("File already exists: {:?}", filepath);
        }
    }

    // Check for knight.glb in assets/scenes
    let knight_model_path = Path::new("../assets/scenes/knight.glb");
    if !knight_model_path.exists() {
        dbg!("knight.glb does not exist at {:?}.\nThere's a free non-rigged version available of it here: https://sketchfab.com/3d-models/elysia-knight-d099f11914f445afbe727fe5c3ddd39d or,\nYou can a rigged version purchase here: https://www.artstation.com/marketplace/p/RGmbB/medieval-armor-set-unreal-engine-rigged", knight_model_path);
        // Handle the absence of knight.glb as needed (e.g., download, notify, etc.)
    } else {
        dbg!("knight.glb already exists at {:?}", knight_model_path);
    }

    println!("cargo:rerun-if-changed=build.rs");

    Ok(())
}
