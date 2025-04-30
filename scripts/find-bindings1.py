import os
import re
from pathlib import Path
from collections import defaultdict


def parse_files(root_dir):
    """Parse Rust and WGSL files to find matching structs and bindings."""
    # Patterns
    rust_struct_pattern = re.compile(r"pub\s+struct\s+(\w+)\s*\{([^}]+)\}", re.DOTALL)
    rust_attribute_pattern = re.compile(
        r'#\[(uniform|texture|sampler)\((\d+)(?:,\s*dimension\s*=\s*"([^"]+)")?\)\]\s*pub\s+(\w+)',
        re.DOTALL,
    )
    wgsl_binding_pattern = re.compile(
        r"@group\((\d+)\)\s*@binding\((\d+)\)\s*var<uniform>\s+(\w+):\s*(\w+);"
    )

    # Results storage
    results = defaultdict(
        lambda: {"rust_struct": None, "wgsl_bindings": [], "rust_attributes": []}
    )

    for root, _, files in os.walk(root_dir):
        for file in files:
            file_path = Path(root) / file
            if file_path.suffix not in (".rs", ".wgsl"):
                continue

            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    content = f.read()

                if file_path.suffix == ".rs":
                    # Find Rust structs
                    for struct_match in rust_struct_pattern.finditer(content):
                        struct_name = struct_match.group(1)
                        struct_body = struct_match.group(2)

                        # Store struct info
                        results[struct_name]["rust_struct"] = {
                            "file": str(file_path),
                            "line": content.count("\n", 0, struct_match.start()) + 1,
                            "body": struct_body.strip(),
                        }

                        # Find attributes within the struct
                        for attr_match in rust_attribute_pattern.finditer(struct_body):
                            attr_type = attr_match.group(1)
                            binding = attr_match.group(2)
                            dimension = attr_match.group(3)
                            var_name = attr_match.group(4)

                            results[struct_name]["rust_attributes"].append(
                                {
                                    "type": attr_type,
                                    "binding": binding,
                                    "dimension": dimension,
                                    "var_name": var_name,
                                    "line": content.count(
                                        "\n",
                                        0,
                                        struct_match.start() + attr_match.start(1),
                                    )
                                    + 1,
                                }
                            )

                elif file_path.suffix == ".wgsl":
                    # Find WGSL bindings
                    for binding_match in wgsl_binding_pattern.finditer(content):
                        group = binding_match.group(1)
                        binding = binding_match.group(2)
                        var_name = binding_match.group(3)
                        type_name = binding_match.group(4)

                        # Try to find matching Rust struct
                        if type_name in results:
                            results[type_name]["wgsl_bindings"].append(
                                {
                                    "group": group,
                                    "binding": binding,
                                    "var_name": var_name,
                                    "file": str(file_path),
                                    "line": content.count(
                                        "\n", 0, binding_match.start()
                                    )
                                    + 1,
                                }
                            )

            except UnicodeDecodeError:
                print(f"Skipping binary file: {file_path}")
            except Exception as e:
                print(f"Error processing {file_path}: {e}")

    return results


def print_side_by_side(results):
    """Print matching Rust structs and WGSL bindings in a side-by-side table."""
    from tabulate import tabulate

    for struct_name, data in results.items():
        if not data["rust_struct"] or not data["wgsl_bindings"]:
            continue

        print(f"\n\033[1mStruct: {struct_name}\033[0m")
        print(f"Rust File: {data['rust_struct']['file']}:{data['rust_struct']['line']}")

        # Prepare table data
        table_data = []
        max_rows = max(len(data["rust_attributes"]), len(data["wgsl_bindings"]))

        for i in range(max_rows):
            rust_attr = (
                data["rust_attributes"][i] if i < len(data["rust_attributes"]) else {}
            )
            wgsl_bind = (
                data["wgsl_bindings"][i] if i < len(data["wgsl_bindings"]) else {}
            )

            table_data.append(
                [
                    rust_attr.get("type", ""),
                    rust_attr.get("binding", ""),
                    rust_attr.get("var_name", ""),
                    rust_attr.get("dimension", ""),
                    wgsl_bind.get("group", ""),
                    wgsl_bind.get("binding", ""),
                    wgsl_bind.get("var_name", ""),
                    wgsl_bind.get("file", "").split("/")[-1]
                    + ":"
                    + str(wgsl_bind.get("line", "")),
                ]
            )

        print(
            tabulate(
                table_data,
                headers=[
                    "Rust Type",
                    "Binding",
                    "Var Name",
                    "Dimension",
                    "WGSL Group",
                    "Binding",
                    "Var Name",
                    "Location",
                ],
                tablefmt="grid",
                stralign="left",
                showindex=True,
            )
        )


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Usage: python match_bindings.py <directory>")
        sys.exit(1)

    root_directory = sys.argv[1]
    if not os.path.isdir(root_directory):
        print(f"Error: {root_directory} is not a valid directory")
        sys.exit(1)

    try:
        from tabulate import tabulate
    except ImportError:
        print("Please install tabulate: pip install tabulate")
        sys.exit(1)

    results = parse_files(root_directory)
    print_side_by_side(results)
