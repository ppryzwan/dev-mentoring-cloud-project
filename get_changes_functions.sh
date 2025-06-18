#!/bin/bash

CLOUD_FUNCTIONS_DIR="src/cloud-functions"

all_changed_files=$(git diff-tree --no-commit-id --name-only -r HEAD 2>/dev/null)
changed_files=$(echo "$all_changed_files" | grep "^$CLOUD_FUNCTIONS_DIR/")

if [ -z "$changed_files" ]; then
    echo "No changes detected in $CLOUD_FUNCTIONS_DIR"
    exit 0
fi

changed_folders=""
utils_changed=false

for file in $all_changed_files; do
    relative_path=${file#$CLOUD_FUNCTIONS_DIR/}

    if [ "$relative_path" = "utils.py" ]; then
        utils_changed=true
        continue
    fi

    folder_name=$(echo "$relative_path" | cut -d'/' -f1)

    if [ -d "$CLOUD_FUNCTIONS_DIR/$folder_name" ]; then
        if [[ ! " $changed_folders " =~ " $folder_name " ]]; then
            changed_folders="$changed_folders $folder_name"
        fi
    fi
done

if [ "$utils_changed" = true ]; then
    for dir in "$CLOUD_FUNCTIONS_DIR"/*/; do
        if [ -d "$dir" ]; then
            folder_name=$(basename "$dir")
            changed_folders="$changed_folders $folder_name"
        fi
    done
    changed_folders=$(echo $changed_folders | tr ' ' '\n' | sort -u | tr '\n' ' ')
fi

if [ -n "$changed_folders" ]; then
    echo $changed_folders
fi
