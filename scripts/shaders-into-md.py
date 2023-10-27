import os
import argparse
from typing import List, Tuple


def convert_wgsl_to_md(directory: str) -> List[Tuple[str, str]]:
    """Converts .wgsl files to .md format in the specified directory and returns a list of parent names and their paths."""
    toc_entries = []

    for root, _, files in os.walk(directory):
        print(f"Checking directory: {root}")  # Debug print
        for file in files:
            print(f"Found file: {file}")  # Debug print
            if file == "screenshot.wgsl":
                print(f"Processing .wgsl file: {file}")  # Debug print
                wgsl_path = os.path.join(root, file)
                with open(wgsl_path, "r") as wgsl_file:
                    wgsl_content = wgsl_file.read()

                parent_name = os.path.basename(root)

                md_content = f"""## {parent_name} 

![photo](screenshot.png)
- your comments go here.

### fragment

```rust
{wgsl_content}

"""

            md_path = os.path.join(root, f"{parent_name}.md")
            with open(md_path, "w") as md_file:
                md_file.write(md_content)

            os.remove(wgsl_path)

            toc_entries.append((parent_name, md_path))

    return toc_entries


def update_gallery_readme(
    toc_entries: List[Tuple[str, str]], gallery_path: str
) -> None:
    """Updates the Gallery README.md with a TOC."""
    toc_content = "| Name | Screenshot |\n|------|------------|\n"
    print(toc_entries)
    for name, path in toc_entries:
        print(name, path)
        relative_path = os.path.relpath(path, gallery_path)
        toc_content += f"| {name} | ![screenshot]({os.path.join(os.path.dirname(relative_path), 'screenshot.png')}) |\n"

    print(toc_content)
    with open(os.path.join(gallery_path, "README.md"), "w") as readme_file:
        readme_file.write(toc_content)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Convert .wgsl files to .md format and update Gallery README.md."
    )
    parser.add_argument(
        "gallery_path", type=str, help="Path to the assets/Gallery directory."
    )


if __name__ == "main":
    main()
