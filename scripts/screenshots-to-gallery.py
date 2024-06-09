import argparse
import os
import shutil


def create_directory_and_move_files(file_path, title):
    target_directory = f"./assets/Gallery/{title}"
    os.makedirs(target_directory, exist_ok=True)

    screenshot_png_path = file_path
    screenshot_wgsl_path = file_path.replace(".png", ".wgsl")

    shutil.move(screenshot_png_path, os.path.join(target_directory, "screenshot.png"))
    shutil.move(screenshot_wgsl_path, os.path.join(target_directory, "screenshot.wgsl"))

    with open(os.path.join(target_directory, "screenshot.wgsl"), "r") as wgsl_file:
        wgsl_contents = wgsl_file.read()

    readme_contents = f"""
## {title}

![photo](screenshot.png)

## Fragment:
```rust
{wgsl_contents}

```
"""

    with open(os.path.join(target_directory, "README.md"), "w") as readme_file:
        readme_file.write(readme_contents)

    # as the contents of the shader are moved into the README for the named shader in the README we create, we remove the previous source.
    os.remove(os.path.join(target_directory, "screenshot.wgsl"))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Move screenshots and create a README file."
    )
    parser.add_argument("input", type=str, help="Path to the screenshot.png file")
    parser.add_argument("title", type=str, help="Title for the directory and README")
    args = parser.parse_args()

    create_directory_and_move_files(args.input, args.title)
