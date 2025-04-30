import os
import re
from pathlib import Path
from collections import defaultdict


def parse_files(root_dir):
    """Parse Rust and WGSL files to find matching structs and bindings."""
    # Patterns
    rust_struct_pattern = re.compile(r"pub\s+struct\s+(\w+)\s*\{([^}]+)\}", re.DOTALL)
    rust_attribute_pattern = re.compile(
        r"#\[(uniform|texture|sampler)\((\d+)\)\]\s*pub\s+(\w+)", re.DOTALL
    )
    wgsl_binding_pattern = re.compile(
        r"@group\((\d+)\)\s*@binding\((\d+)\)\s*var<uniform>\s+(\w+):\s*(\w+);"
    )
    wgsl_struct_pattern = re.compile(r"struct\s+(\w+)\s*\{([^}]+)\}", re.DOTALL)

    results = defaultdict(
        lambda: {
            "rust_struct": None,
            "wgsl_bindings": defaultdict(list),
            "rust_attributes": [],
            "wgsl_structs": {},
        }
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
                    for struct_match in rust_struct_pattern.finditer(content):
                        struct_name = struct_match.group(1)
                        struct_body = struct_match.group(2)

                        results[struct_name]["rust_struct"] = {
                            "file": str(file_path),
                            "line": content.count("\n", 0, struct_match.start()) + 1,
                            "body": struct_body.strip(),
                        }

                        for attr_match in rust_attribute_pattern.finditer(struct_body):
                            attr_type = attr_match.group(1)
                            binding = attr_match.group(2)
                            var_name = attr_match.group(3)

                            results[struct_name]["rust_attributes"].append(
                                {
                                    "binding": binding,
                                    "group": None,
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
                    # Find all WGSL structs first
                    for struct_match in wgsl_struct_pattern.finditer(content):
                        struct_name = struct_match.group(1)
                        struct_body = struct_match.group(2)
                        results[struct_name]["wgsl_structs"][
                            str(file_path)
                        ] = struct_body.strip()

                    # Then find bindings
                    for binding_match in wgsl_binding_pattern.finditer(content):
                        group = binding_match.group(1)
                        binding = binding_match.group(2)
                        var_name = binding_match.group(3)
                        type_name = binding_match.group(4)

                        # Also look for View and other common uniforms
                        if type_name in results or type_name in [
                            "View",
                            "Light",
                            "Mesh",
                        ]:
                            results[type_name]["wgsl_bindings"][group].append(
                                {
                                    "binding": binding,
                                    "var_name": var_name,
                                    "file": str(file_path),
                                    "line": content.count(
                                        "\n", 0, binding_match.start()
                                    )
                                    + 1,
                                }
                            )

                            # Match with Rust attributes
                            if type_name in results:
                                for attr in results[type_name]["rust_attributes"]:
                                    if attr["binding"] == binding:
                                        attr["group"] = group

            except UnicodeDecodeError:
                print(f"Skipping binary file: {file_path}")
            except Exception as e:
                print(f"Error processing {file_path}: {e}")

    return results


import os
import re
from pathlib import Path
from collections import defaultdict


def parse_files(root_dir):
    """Parse Rust and WGSL files to find matching structs and bindings."""
    # Patterns
    rust_struct_pattern = re.compile(r"pub\s+struct\s+(\w+)\s*\{([^}]+)\}", re.DOTALL)
    rust_attribute_pattern = re.compile(
        r"#\[(uniform|texture|sampler)\((\d+)\)\]\s*pub\s+(\w+)", re.DOTALL
    )
    wgsl_binding_pattern = re.compile(
        r"@group\((\d+)\)\s*@binding\((\d+)\)\s*var<uniform>\s+(\w+):\s*(\w+);"
    )
    wgsl_struct_pattern = re.compile(r"struct\s+(\w+)\s*\{([^}]+)\}", re.DOTALL)

    results = defaultdict(
        lambda: {
            "rust_struct": None,
            "wgsl_bindings": defaultdict(list),
            "rust_attributes": [],
            "wgsl_structs": {},
        }
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
                    for struct_match in rust_struct_pattern.finditer(content):
                        struct_name = struct_match.group(1)
                        struct_body = struct_match.group(2)

                        results[struct_name]["rust_struct"] = {
                            "file": str(file_path),
                            "line": content.count("\n", 0, struct_match.start()) + 1,
                            "body": struct_body.strip(),
                        }

                        for attr_match in rust_attribute_pattern.finditer(struct_body):
                            attr_type = attr_match.group(1)
                            binding = attr_match.group(2)
                            var_name = attr_match.group(3)

                            results[struct_name]["rust_attributes"].append(
                                {
                                    "binding": binding,
                                    "group": None,
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
                    # Find all WGSL structs first
                    for struct_match in wgsl_struct_pattern.finditer(content):
                        struct_name = struct_match.group(1)
                        struct_body = struct_match.group(2)
                        results[struct_name]["wgsl_structs"][
                            str(file_path)
                        ] = struct_body.strip()

                    # Then find bindings
                    for binding_match in wgsl_binding_pattern.finditer(content):
                        group = binding_match.group(1)
                        binding = binding_match.group(2)
                        var_name = binding_match.group(3)
                        type_name = binding_match.group(4)

                        # Also look for View and other common uniforms
                        if type_name in results or type_name in [
                            "View",
                            "Light",
                            "Mesh",
                        ]:
                            results[type_name]["wgsl_bindings"][group].append(
                                {
                                    "binding": binding,
                                    "var_name": var_name,
                                    "file": str(file_path),
                                    "line": content.count(
                                        "\n", 0, binding_match.start()
                                    )
                                    + 1,
                                }
                            )

                            # Match with Rust attributes
                            if type_name in results:
                                for attr in results[type_name]["rust_attributes"]:
                                    if attr["binding"] == binding:
                                        attr["group"] = group

            except UnicodeDecodeError:
                print(f"Skipping binary file: {file_path}")
            except Exception as e:
                print(f"Error processing {file_path}: {e}")

    return results


def print_markdown_report(results):
    """Print bindings organized by group in Markdown format."""
    # First collect all groups across all structs
    all_groups = set()
    for struct_data in results.values():
        for group in struct_data["wgsl_bindings"].keys():
            all_groups.add(int(group))
    all_groups = sorted(all_groups)

    # Track which structs we've already printed
    printed_structs = set()

    # Print each group in order
    for group in all_groups:
        group_str = str(group)
        print(f"\n## GROUP {group}\n")

        for struct_name, data in results.items():
            if not data["wgsl_bindings"].get(group_str):
                continue

            # Get unique bindings
            unique_bindings = {}
            for binding in data["wgsl_bindings"][group_str]:
                key = (binding["binding"], binding["var_name"])
                if key not in unique_bindings:
                    unique_bindings[key] = binding

            if not unique_bindings:
                continue

            print(f"### {struct_name}\n")
            print("| Group | Binding | WGSL Uniform | WGSL Location | Rust Location |")
            print("|-------|---------|--------------|---------------|---------------|")

            # Sort bindings numerically
            for (binding_num, var_name), binding in sorted(
                unique_bindings.items(), key=lambda x: int(x[0][0])
            ):
                # Find matching Rust attribute
                rust_attr = next(
                    (
                        attr
                        for attr in data.get("rust_attributes", [])
                        if attr.get("binding") == binding_num
                        and attr.get("group") == group_str
                    ),
                    None,
                )

                rust_location = "Not found"
                if data.get("rust_struct"):
                    base_rust_loc = f"{data['rust_struct']['file'].split(os.sep)[-1]}:{data['rust_struct']['line']}"
                    if rust_attr:
                        rust_location = (
                            f"{base_rust_loc} (field: {rust_attr['var_name']})"
                        )
                    else:
                        rust_location = f"{base_rust_loc} (no binding match)"

                wgsl_location = f"{binding['file'].split(os.sep)[-1]}:{binding['line']}"

                print(
                    f"| {group} | {binding_num} | {var_name} | {wgsl_location} | {rust_location} |"
                )

            # Print WGSL struct definition if available and not already printed
            if data["wgsl_structs"] and struct_name not in printed_structs:
                print("\n```wgsl")
                # Just take the first struct definition we find
                file_path, struct_body = next(iter(data["wgsl_structs"].items()))
                print(f"// From {file_path.split(os.sep)[-1]}")
                print(f"struct {struct_name} {{")
                print(struct_body)
                print("}\n```")
                printed_structs.add(struct_name)
            print()  # Extra newline for spacing


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Usage: python match_bindings.py <directory>")
        sys.exit(1)

    root_directory = sys.argv[1]
    if not os.path.isdir(root_directory):
        print(f"Error: {root_directory} is not a valid directory")
        sys.exit(1)

    results = parse_files(root_directory)
    print_markdown_report(results)
