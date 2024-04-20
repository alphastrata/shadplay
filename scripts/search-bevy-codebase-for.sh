#!/bin/bash

# # Check if the argument is provided
# if [ $# -ne 1 ]; then
#     echo "----------------------------------------------"
#     echo ""
#     ehco ">>>HELP"
#     echo "       Usage: $0 <search_query>"
#     echo ""
#     echo ""
#     echo "       Examples:"
#     echo "              ./scripts/search-bevy-codebase-for.sh mesh2d_vertex_output"
#     echo "              ./scripts/search-bevy-codebase-for.sh MeshVertexOutput"
#     echo ""
#     echo ""
#     echo "----------------------------------------------"
#     exit 1
# fi

# Define the GitHub search URL for WGSL code in the Bevy repository
search_query="$1"
github_url="https://github.com/search?q=repo%3Abevyengine%2Fbevy+$search_query+language%3AWGSL&type=code&l=WGSL"

# Open the URL in the default web browser (sorry, assumes linux/gnome users..)
xdg-open "$github_url"
