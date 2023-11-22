//! The Might example requires additional assets that're NOT kept in this repo.
use std::fs::{self, File};
use std::io::Write;
use std::path::Path;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {

    let current_dir = env::current_dir()?;
    println!("Current directory: {:?}", current_dir);    

    let urls = [
        "https://raw.githubusercontent.com/bevyengine/bevy/main/assets/environment_maps/pisa_diffuse_rgb9e5_zstd.ktx2",
        "https://raw.githubusercontent.com/bevyengine/bevy/main/assets/environment_maps/pisa_specular_rgb9e5_zstd.ktx2",
        "https://raw.githubusercontent.com/bevyengine/bevy/main/assets/environment_maps/info.txt",
    ];

    let out_dirs = vec!["../assets/environment_maps", "../assets/scenes"];

    for dir in out_dirs{        
        fs::create_dir_all(di)?;
    }

    for url in urls.iter() {
        let filename = Path::new(url).file_name()?;
        let filepath = Path::new(out_dir).join(filename);

        // Check if the file already exists
        if !filepath.exists() {
            let response = reqwest::get(url).await?.bytes().await?;
            let mut file = File::create(&filepath)?;
            file.write_all(&response)?;
            println!("Downloaded and saved: {:?}", filepath);
        } else {
            println!("File already exists: {:?}", filepath);
        }
    }    


  // Check for knight.glb in assets/scenes
    let knight_model_path = Path::new("../assets/scenes/knight.glb");
    if !knight_model_path.exists() {
        println!("knight.glb does not exist at {:?}.\nYou can purchase it here: https://www.artstation.com/marketplace/p/RGmbB/medieval-armor-set-unreal-engine-rigged", knight_model_path);
        std::os::exit(1);
        // Handle the absence of knight.glb as needed (e.g., download, notify, etc.)
    } else {
        println!("knight.glb already exists at {:?}", knight_model_path);
    }    

    Ok(())
}
