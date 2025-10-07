#!/usr/bin/env python3
"""
Script to check all shaders in the project using the new CLI argument functionality.
"""

import subprocess
import sys
import os
from pathlib import Path


def find_wgsl_files(directory):
    """Find all .wgsl files in the directory and subdirectories."""
    wgsl_files = []
    dir_path = Path(directory)
    for file_path in dir_path.rglob("*.wgsl"):
        wgsl_files.append(str(file_path.resolve()))
    return wgsl_files


def test_shader(shader_path):
    """Test a single shader using the shadplay CLI."""
    try:
        # Run shadplay with the shader file as argument
        # Use -- to separate cargo args from app args
        result = subprocess.run([
            'cargo', 'run', '--release', '--', shader_path
        ], capture_output=True, text=True, timeout=30, cwd=os.path.dirname(os.path.dirname(os.path.abspath(__file__))))  # 30 second timeout, run from project root
        
        # Check if the shader detection worked
        output = result.stdout + result.stderr
        success = "Loaded" in output and ("2D" in output or "3D" in output)
        
        return success, output, result.returncode
    except subprocess.TimeoutExpired:
        return False, "TIMEOUT", -1
    except Exception as e:
        return False, str(e), -1


def main():
    """Main function to check all shaders in the project."""
    # Default directory to search for shaders
    shader_dir = "./assets/shaders"
    
    # Allow specifying a different directory
    if len(sys.argv) > 1:
        shader_dir = sys.argv[1]
    
    print(f"Searching for .wgsl files in: {shader_dir}")
    
    # Find all wgsl files
    wgsl_files = find_wgsl_files(shader_dir)
    
    if not wgsl_files:
        print(f"No .wgsl files found in {shader_dir}")
        sys.exit(1)
    
    print(f"Found {len(wgsl_files)} .wgsl files to test\n")
    
    success_count = 0
    error_count = 0
    
    for i, shader_path in enumerate(wgsl_files, 1):
        print(f"Testing ({i}/{len(wgsl_files)}): {os.path.basename(shader_path)}")
        
        success, output, return_code = test_shader(shader_path)
        
        if success:
            print(f"  ✓ SUCCESS - {output.split('Loaded')[1].split('to')[0].strip()} shader detected")
            success_count += 1
        else:
            print(f"  ✗ FAILED - Exit code: {return_code}")
            if "TIMEOUT" in output:
                print(f"    Timeout occurred")
            else:
                # Extract relevant error information
                lines = output.split('\n')
                error_lines = [line for line in lines if 'error' in line.lower() or 'Error' in line]
                if error_lines:
                    for err in error_lines[:3]:  # Show first 3 error lines
                        print(f"    {err.strip()}")
            error_count += 1
        
        print()
    
    print(f"Summary: {success_count} successful, {error_count} failed out of {len(wgsl_files)} shaders")
    
    if error_count > 0:
        print("\nSome shaders failed to load. Check the output above for details.")
        sys.exit(1)
    else:
        print("\nAll shaders loaded successfully!")
        sys.exit(0)


if __name__ == "__main__":
    main()