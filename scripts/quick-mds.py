import os
import argparse
import re

# Mapping of WGSL functions to their descriptions
wgsl_functions = {
    "y = x % 0.5;": "Return x modulo 0.5",
    "y = fract(x);": "Return only the fraction part of a number",
    "y = ceil(x);": "Return the nearest integer that is greater than or equal to x",
    "y = floor(x);": "Return the nearest integer less than or equal to x",
    "y = sign(x);": "Extract the sign of x",
    "y = abs(x);": "Return the absolute value of x",
    "y = clamp(x, 0.0, 1.0);": "Constrain x to lie between 0.0 and 1.0",
    "y = min(0.0, x);": "Return the lesser of x and 0.0",
    "y = max(0.0, x);": "Return the greater of x and 0.0",
}


def extract_function_name(wgsl_code):
    # Use regex to extract the function name
    pattern = r"fn\s+([\w\d_]+)\s*\("
    match = re.search(pattern, wgsl_code)
    if match:
        return match.group(1)
    return "Function"


def generate_markdown_summary(input_folder, save=False):
    # Iterate through files in the input folder
    for root, _, files in os.walk(input_folder):
        for filename in files:
            # if it ends with png we want to keep it in our dict of work.
            if filename.endswith(".wgsl"):
                file_path = os.path.join(root, filename)
                with open(file_path, "r") as file:
                    wgsl_code = file.read()

                # Extract the function name
                function_name = extract_function_name(wgsl_code)

                # Extract relevant WGSL function comments and descriptions
                markdown_summary = []

                # Add the function name as the heading
                markdown_summary.append(f"#### {function_name}")

                markdown_summary.append(f"![photo](screeenshot.png)")

                # Find the line with "@fragment"
                start_index = wgsl_code.find("@fragment")
                if start_index != -1:
                    truncated_code = wgsl_code[start_index:]
                    markdown_summary.append(f"```rust\n{truncated_code}\n```")

                markdown_summary.append("### Summary")
                for func, desc in wgsl_functions.items():
                    if func in wgsl_code:
                        markdown_summary.append(f"#### {func}")
                        markdown_summary.append(f"{desc}\n")

                markdown_summary = "\n".join(markdown_summary)

                # Print or save the markdown summary
                if save:
                    output_file = os.path.splitext(filename)[0] + ".md"
                    output_path = os.path.join(root, output_file)
                    with open(output_path, "w") as md_file:
                        md_file.write(markdown_summary)
                    print(f"Saved summary to {output_path}")
                else:
                    print(markdown_summary)


def main():
    parser = argparse.ArgumentParser(
        description="Generate markdown summaries for WGSL code files."
    )
    parser.add_argument(
        "input_folder", help="Input folder containing .wgsl files")
    parser.add_argument(
        "--save", action="store_true", help="Save markdown summaries in the same folder"
    )
    args = parser.parse_args()

    input_folder = args.input_folder
    save = args.save

    generate_markdown_summary(input_folder, save)


if __name__ == "__main__":
    main()
