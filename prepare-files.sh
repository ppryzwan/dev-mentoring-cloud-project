#!/bin/bash

BASE_DIR=$(pwd)
SOURCE_DIR="$BASE_DIR/src/cloud-functions"
TARGET_DIR="$BASE_DIR/src/dist_functions"
FILE_TO_COPY="$BASE_DIR/src/cloud-functions/utils.py"

if [ $# -eq 0 ]; then
    FUNCTIONS=()
    for dir in "$SOURCE_DIR"/*/; do
        if [ -d "$dir" ]; then
            FUNCTION_NAME=$(basename "$dir")
            FUNCTIONS+=("$FUNCTION_NAME")
        fi
    done
    set -- "${FUNCTIONS[@]}"  # Set the positional parameters to the found functions
fi

for FUNCTION_NAME in "$@"; do
    SUBFOLDER="$SOURCE_DIR/$FUNCTION_NAME"

    if [ ! -d "$SUBFOLDER" ]; then
        echo "Warning: Function directory '$FUNCTION_NAME' not found. Skipping..."
        continue
    fi

    echo "Processing $FUNCTION_NAME..."
    TEMP_DIR="$TARGET_DIR/$FUNCTION_NAME"
    mkdir -p "$TEMP_DIR"
    find "$SUBFOLDER" -type f -not -path "*/\.*" -not -path "*/__pycache__/*" -exec cp {} "$TEMP_DIR/" \;
    cp "$FILE_TO_COPY" "$TEMP_DIR/"
    cd "$TEMP_DIR"
    poetry export -f requirements.txt --output requirements.txt --without-hashes
    cd "$TARGET_DIR"
    zip -j "$FUNCTION_NAME.zip" "./$FUNCTION_NAME/"*
    cd "$BASE_DIR"
    echo "Completed processing $FUNCTION_NAME"
done

echo "All specified functions processed. Zip files are available in $TARGET_DIR directory."
