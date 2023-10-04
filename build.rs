use std::fs;
use std::path::PathBuf;
use std::process::exit;

fn main() {
    // Clone the Bevy repository
    if !PathBuf::from("bevy").exists()
        && !std::process::Command::new("git")
            .args(["clone", "https://github.com/bevyengine/bevy"])
            .status()
            .expect("Failed to execute git clone command")
            .success()
    {
        eprintln!("Failed to clone Bevy repository");
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
}
