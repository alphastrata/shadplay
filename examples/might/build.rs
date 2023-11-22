//! The Might example requires additional assets that're NOT kept in this repo.
use std::fs::{self, File};
use std::io::Write;
use std::path::Path;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let urls = [
        "https://raw.githubusercontent.com/bevyengine/bevy/main/assets/environment_maps/pisa_diffuse_rgb9e5_zstd.ktx2",
        "https://raw.githubusercontent.com/bevyengine/bevy/main/assets/environment_maps/pisa_specular_rgb9e5_zstd.ktx2",
        "https://raw.githubusercontent.com/bevyengine/bevy/main/assets/environment_maps/info.txt",
    ];

    let out_dir = "../assets/environment_maps";
    fs::create_dir_all(out_dir)?;

    for url in urls.iter() {
        let filename = Path::new(url).file_name().unwrap();
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

    
    Ok(())
}
