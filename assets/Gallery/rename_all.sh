#!/bin/bash

find . -type f -name "*.md" -exec sh -c '
    for file; do
        dir=$(dirname "$file")
        mv "$file" "$dir/README.md"
    done
' sh {} +