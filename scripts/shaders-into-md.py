import os
import argparse


def convert_wgsl_to_md(directory: str) -> None:
    """Converts .wgsl files to .md format in the specified directory."""
    for root, _, files in os.walk(directory):
        for file in files:
            if file == "screenshot.wgsl":
                wgsl_path = os.path.join(root, file)

                # Read the content of the .wgsl file
                with open(wgsl_path, "r") as wgsl_file:
                    wgsl_content = wgsl_file.read()

                # Extract the parent directory's name for the summary section
                parent_name = os.path.basename(root)

                # Create the markdown content using f-string
                md_content = f"""## {parent_name}
                 

![photo](screenshot.png)

### fragment

```rust
{wgsl_content}
```

your comments go here...

"""

                # Write the markdown content to a new .md file named after the parent directory
                md_path = os.path.join(root, f"{parent_name}.md")
                with open(md_path, "w") as md_file:
                    md_file.write(md_content)

                # Optionally, delete the .wgsl file
                os.remove(wgsl_path)


def main() -> None:
    """Main function to parse arguments and call the conversion function."""
    parser = argparse.ArgumentParser(description="Convert .wgsl files to .md format.")
    parser.add_argument(
        "directory", type=str, help="Path to the directory containing .wgsl files."
    )

    args = parser.parse_args()
    convert_wgsl_to_md(args.directory)


if __name__ == "__main__":
    main()
