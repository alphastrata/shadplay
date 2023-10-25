import re
import os
import argparse


def pascal_to_snake(name):
    """Convert a pascalCase string to snake_case."""
    s1 = re.sub("(.)([A-Z][a-z]+)", r"\1_\2", name)
    return re.sub("([a-z0-9])([A-Z])", r"\1_\2", s1).lower()


def colorize(text, color_code):
    """Return text wrapped in an ANSI color code."""
    return f"\033[{color_code}m{text}\033[0m"


def orange(text):
    """Return text in orange."""
    return colorize(text, "33")  # ANSI code for orange


def cyan(text):
    """Return text in cyan."""
    return colorize(text, "36")  # ANSI code for cyan


def process_file(file_path, preview):
    """Process a single WGSL file."""
    with open(file_path, "r") as file:
        lines = file.readlines()

    modified_lines = []
    for line in lines:
        # Skip lines that start with // or ///
        if line.strip().startswith(("//", "///")):
            modified_lines.append(line)
            continue

        # Find all pascalCase variable names
        pascal_names = re.findall(r"\b([a-z]+[A-Z][a-zA-Z0-9]*)\b", line)

        # Convert each found name to snake_case and replace in line
        for name in set(pascal_names):  # Using set to avoid processing duplicates
            snake_name = pascal_to_snake(name)
            line = line.replace(name, snake_name)

            if preview:
                print(f"{orange(name)} -> {cyan(snake_name)}")

        modified_lines.append(line)

    if not preview:
        with open(file_path, "w") as file:
            file.writelines(modified_lines)
    else:
        print(f"Processed (preview): {file_path}")


def main():
    parser = argparse.ArgumentParser(
        description="Convert pascalCase variable names in WGSL files to snake_case."
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
    args = parser.parse_args()

    for root, dirs, files in os.walk(args.target):
        for file in files:
            if file.endswith(".wgsl"):
                process_file(os.path.join(root, file), args.preview)


if __name__ == "__main__":
    main()
