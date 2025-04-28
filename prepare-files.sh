#!/bin/bash

BASE_DIR=$(pwd)
SOURCE_DIR="$BASE_DIR/src/cloud-functions"
TARGET_DIR="$BASE_DIR/src/dist_functions"
FILE_TO_COPY="$BASE_DIR/src/cloud-functions/utils.py"

for SUBFOLDER in "$SOURCE_DIR"/*/ ; do
    if [ -d "$SUBFOLDER" ]; then
        FOLDER_NAME=$(basename "$SUBFOLDER")
        echo "Processing $FOLDER_NAME..."
        TEMP_DIR="$TARGET_DIR/$FOLDER_NAME"
        mkdir -p "$TEMP_DIR"
        find "$SUBFOLDER" -type f -not -path "*/\.*" -not -path "*/__pycache__/*" -exec cp {} "$TEMP_DIR/" \;
        cp "$FILE_TO_COPY" "$TEMP_DIR/"
        cd "$TEMP_DIR"
        poetry export -f requirements.txt --output requirements.txt --without-hashes
        cd $TARGET_DIR
        zip -j "$FOLDER_NAME.zip" ./$FOLDER_NAME/*

        cd $BASE_DIR
        echo "Completed processing $FOLDER_NAME"
    fi
done

echo "All folders processed. Zip files are available in $TARGET_DIR directory."
