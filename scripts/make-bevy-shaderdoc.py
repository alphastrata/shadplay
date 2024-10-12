import argparse
import os
import shutil
import subprocess
from pathlib import Path
from typing import Dict, Union
from tqdm import tqdm


def move_to_shadplay() -> None:
    current_dir = Path.cwd()
    shadplay_dir = None

    # Check if the current directory is already 'shadplay'
    if current_dir.name == "shadplay":
        print("Already in the 'shadplay' directory.")
        return

    # Search up the directory tree for 'shadplay'
    for parent in current_dir.parents:
        shadplay_dir = parent / "shadplay"
        if shadplay_dir.exists():
            print(f"Found 'shadplay' directory at: {shadplay_dir}")
            break

    # If not found, search down from the current directory
    if not shadplay_dir or not shadplay_dir.exists():
        for child in current_dir.iterdir():
            if child.is_dir() and child.name == "shadplay":
                shadplay_dir = child
                print(f"Found 'shadplay' directory at: {shadplay_dir}")
                break

    # If 'shadplay' directory is found, change the current working directory to it
    if shadplay_dir and shadplay_dir.exists():
        os.chdir(shadplay_dir)
        print(f"Moved to 'shadplay' directory: {shadplay_dir}")
    else:
        print("'shadplay' directory not found.")


def collect_wgsl_contents(directory: Path) -> Dict[Path, str]:
    wgsl_contents = {}

    # Recursively search for .wgsl files
    for wgsl_file in tqdm(directory.rglob("*.wgsl"), desc="Processing .wgsl files"):
        # Extract the relative path without the file extension

        relative_path = wgsl_file.relative_to(directory).with_suffix("")
        with open(wgsl_file, "r") as file:
            wgsl_contents[relative_path] = file.read()

    return wgsl_contents


def write_script_header(output_file: Path) -> None:
    output_file.write("# All the BevyEngine Shaders\n\n")
    output_file.write(
        "This document is really to give you an easy, one-stop-shop to reference all the Bevy Engine's shaders -- as they're not well documented.\n\n"
    )
    output_file.write("## Table of Contents\n\n")


def write_table_of_contents(output_file: Path, wgsl_contents: Dict[Path, str]) -> None:
    for filename in tqdm(wgsl_contents.keys(), desc="writing toc"):
        # Replace slashes with dashes or another separator to create valid anchors
        anchor = str(filename).replace("/", "-")
        output_file.write(f"- [{filename}](#{anchor})\n")


def write_wgsl_contents(output_file: Path, wgsl_contents: Dict[Path, str]) -> None:
    for filename, content in tqdm(wgsl_contents.items(), desc="writing contents"):
        # Replace slashes with dashes to match the anchor format
        anchor = str(filename).replace("/", "-")
        output_file.write(f"### {anchor}\n```rust\n{content}\n```\n")


def write_to_markdown(
    wgsl_contents: Dict[Path, str], output_path: Union[str, Path]
) -> None:
    with open(output_path, "w") as markdown_file:
        write_script_header(markdown_file)
        write_table_of_contents(markdown_file, wgsl_contents)
        write_wgsl_contents(markdown_file, wgsl_contents)


def clone_bevy_codebase() -> None:
    # Define the URL of the Bevy repository
    repo_url = "https://github.com/bevyengine/bevy.git"

    # Define the directory where you want to clone the repository
    # This is set to a directory named 'bevy' in the current working directory
    clone_dir = os.path.join(os.getcwd(), "bevy")

    # Check if the directory already exists
    if os.path.exists(clone_dir):
        print(
            f"The directory '{clone_dir}' already exists. To be certain you get the latest, we'll remove it and reclone the source.."
        )
        shutil.rmtree(clone_dir)
        print(f"Directory '{clone_dir}' removed.")

        clone_bevy_codebase()

    # Use subprocess to run the git clone command
    try:
        subprocess.run(["git", "clone", repo_url, clone_dir], check=True)
        print(f"Bevy codebase cloned successfully into '{clone_dir}'.")
    except subprocess.CalledProcessError as e:
        print(f"Failed to clone the Bevy codebase. Error: {e}")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Convert .wgsl files to a markdown document."
    )
    parser.add_argument(
        "--input",
        type=str,
        default=".",
        help="Input directory containing .wgsl files (default: current directory)",
    )
    parser.add_argument(
        "--output",
        type=str,
        default="bevy-shader-book.md",
        help="Output markdown file (default: bevy-shader-book.md)",
    )
    parser.add_argument(
        "--skip-clone", action="store_true", help="Skip cloning the Bevy codebase."
    )

    args = parser.parse_args()

    move_to_shadplay()

    # Skip cloning if the --skip-clone flag is set
    if not args.skip_clone:
        clone_bevy_codebase()

    input_directory = Path(args.input)
    output_path = Path(args.output)

    if not input_directory.exists() or not input_directory.is_dir():
        raise ValueError(
            f"The input directory '{input_directory}' does not exist or is not a directory."
        )

    wgsl_contents = collect_wgsl_contents(input_directory)

    if not wgsl_contents:
        raise ValueError(
            f"No .wgsl files found in the '{input_directory}' directory or its subdirectories."
        )

    write_to_markdown(wgsl_contents, output_path)
    print(f"Markdown file '{output_path}' created successfully.")


if __name__ == "__main__":
    main()
