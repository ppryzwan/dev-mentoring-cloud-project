#!/bin/bash

BRANCH_NAME=$(git branch --show-current)

if [[ "$BRANCH_NAME" == *"feature/"* ]]; then
  WORKSPACE=${BRANCH_NAME#*feature/}
else
  WORKSPACE="default"
fi

cd src/terraform

if terraform workspace list | grep -q " ${WORKSPACE}\$"; then 
          terraform workspace select $workspace
          echo "Selected workspace: $WORKSPACE"
        else
          terraform workspace new $WORKSPACE
          echo "Created new workspace: $WORKSPACE"
        fi
