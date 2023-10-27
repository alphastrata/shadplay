import re
import os
import argparse


def snake_to_camel(name: str) -> str:
    """Convert a snake_case string to camelCase."""
    components = name.split("_")
    return components[0] + "".join(x.title() for x in components[1:])


def camel_to_snake(name: str) -> str:
    """Convert a camelCase string to snake_case."""
    s1 = re.sub("(.)([A-Z][a-z]+)", r"\1_\2", name)
    return re.sub("([a-z0-9])([A-Z])", r"\1_\2", s1).lower()


def process_file(file_path: str, preview: bool, mode: str):
    """Process a single WGSL file."""
    with open(file_path, "r") as file:
        lines = file.readlines()

    modified_lines = []
    for line in lines:
        # Skip lines that start with // or ///
        if line.strip().startswith(("//", "///")):
            modified_lines.append(line)
            continue

        if mode == "snake":
            # Convert camelCase to snake_case
            camel_names = re.findall(r"\b([a-z]+[A-Z][a-zA-Z0-9]*)\b", line)
            for name in set(camel_names):
                snake_name = camel_to_snake(name)
                line = line.replace(name, snake_name)
                if preview:
                    print(f"{orange(name)} -> {cyan(snake_name)}")
        else:
            # Convert snake_case to camelCase
            snake_names = re.findall(r"\b([a-z]+_[a-z0-9_]+)\b", line)
            for name in set(snake_names):
                camel_name = snake_to_camel(name)
                line = line.replace(name, camel_name)
                if preview:
                    print(f"{orange(name)} -> {cyan(camel_name)}")

        modified_lines.append(line)

    # If preview is False, save the modified content back to the file
    if not preview:
        with open(file_path, "w") as file:
            file.writelines(modified_lines)
    else:
        print(f"Processed (dry run): {file_path}")


def colorize(text: str, color_code: str) -> str:
    """Return text wrapped in an ANSI color code."""
    return f"\033[{color_code}m{text}\033[0m"


def orange(text: str) -> str:
    """Return text in orange."""
    return colorize(text, "33")  # ANSI code for orange


def cyan(text: str) -> str:
    """Return text in cyan."""
    return colorize(text, "36")  # ANSI code for cyan


def main():
    parser = argparse.ArgumentParser(
        description="Convert variable names in WGSL files between snake_case and camelCase."
    )
    parser.add_argument(
        "--preview",
        action="store_true",
        help="Perform a dry run without making actual changes.",
    )
    parser.add_argument(
        "--target",
        type=str,
        default=".",
        help="Target directory to process. Default is current directory.",
    )
    parser.add_argument(
        "--mode",
        type=str,
        choices=["snake", "camel"],
        required=True,
        help="Conversion mode: 'snake' for camelCase to snake_case, 'camel' for snake_case to camelCase.",
    )
    args = parser.parse_args()

    for root, dirs, files in os.walk(args.target):
        for file in files:
            if file.endswith(".wgsl"):
                process_file(os.path.join(root, file), args.preview, args.mode)


if __name__ == "__main__":
    main()
