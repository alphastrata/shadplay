#!/bin/bash

# Configuration file
config_file="$HOME/.config/shadplay/config.toml"

# Read window dimensions from the TOML file
readarray -t dims < <(grep 'window_dims' $config_file | awk -F'[' '{print $2}' | tr -d '[]' | tr ',' '\n')

# Assign width and height
width=$(printf "%.0f" "${dims[0]}")
height=$(printf "%.0f" "${dims[1]}")

# Directory containing the PNG files
input_dir=".gif_scratch"

# Output file
output_file="output.gif"

# Frame rate
fps=10

# Run FFmpeg command
ffmpeg -framerate $fps -pattern_type glob -i "$input_dir/*.png" -vf "scale=$width:$height:flags=lanczos" -loop 0 $output_file
