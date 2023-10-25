import os
import re
import glob
import argparse

# Define the pattern to search for the import path definition
import_path_pattern = r"#define_import_path\s+(.+)"

# Define regular expression patterns for function names, struct names, and uniform declarations
function_name_pattern = r"fn\s+([a-zA-Z_]\w*)\s*\("
struct_name_pattern = r"struct\s+([a-zA-Z_]\w*)\s*{"
uniform_declaration_pattern = (
    r"@group\(1\)\s+@binding\(0\)\s+var<uniform>\s+([a-zA-Z_]\w*):"
)


# Function to extract import path from a file
def extract_import_path(file_path):
    with open(file_path, "r") as file:
        content = file.read()
        match = re.search(import_path_pattern, content)
        if match:
            return match.group(1)
    return None


# Function to extract module path and function names from a file
def extract_module_and_function_names(file_path):
    module_and_functions = set()  # Use a set to store unique module::function pairs
    import_path = extract_import_path(file_path)
    if import_path:
        with open(file_path, "r") as file:
            content = file.read()
            matches = re.finditer(function_name_pattern, content)
            for match in matches:
                function_name = match.group(1)
                module_and_functions.add(f"{import_path}::{function_name}")
    return module_and_functions


# Function to extract struct names from a file
def extract_struct_names(file_path):
    struct_names = []  # Use a list to store struct names
    import_path = extract_import_path(file_path)
    if import_path:
        with open(file_path, "r") as file:
            content = file.read()
            matches = re.finditer(struct_name_pattern, content)
            for match in matches:
                struct_name = match.group(1)
                struct_names.append(f"{import_path}::{struct_name}")
    return struct_names


# Function to extract uniform declarations from a file
def extract_uniform_declarations(file_path):
    uniform_declarations = []  # Use a list to store uniform declarations
    import_path = extract_import_path(file_path)
    if import_path:
        with open(file_path, "r") as file:
            content = file.read()
            matches = re.finditer(uniform_declaration_pattern, content)
            for match in matches:
                uniform_declaration = match.group(1)
                uniform_declarations.append(f"{import_path}::{uniform_declaration}")
    return uniform_declarations


# Directory where you have your .wgsl files
directory_path = "."

# Create a parser for command-line arguments
parser = argparse.ArgumentParser(
    description="Extract function, struct, and uniform names from .wgsl files."
)
parser.add_argument(
    "--functions", action="store_true", help="Extract and print function names."
)
parser.add_argument(
    "--structs", action="store_true", help="Extract and print struct names."
)
parser.add_argument(
    "--uniforms", action="store_true", help="Extract and print uniform declarations."
)

args = parser.parse_args()

if not args.functions and not args.structs and not args.uniforms:
    print("Please specify at least one of --functions, --structs, or --uniforms.")
else:
    # Search for .wgsl files recursively
    wgsl_files = glob.glob(os.path.join(directory_path, "**/*.wgsl"), recursive=True)

    # Create a list to store the names based on the user's choice
    names = []

    # Iterate through each .wgsl file
    for file_path in wgsl_files:
        if args.functions:
            module_and_functions = extract_module_and_function_names(file_path)
            if module_and_functions:
                names.extend(module_and_functions)

        if args.structs:
            struct_names = extract_struct_names(file_path)
            if struct_names:
                names.extend(struct_names)

        if args.uniforms:
            uniform_declarations = extract_uniform_declarations(file_path)
            if uniform_declarations:
                names.extend(uniform_declarations)

    # Print the names (with potential duplicates)
    for name in names:
        print(name)
