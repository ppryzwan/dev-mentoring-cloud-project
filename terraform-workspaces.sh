#!/bin/bash
operation = $1

BRANCH_NAME=$(git branch --show-current)

if [[ "$BRANCH_NAME" == *"feature/"* ]]; then
  WORKSPACE=${BRANCH_NAME#*feature/}
else
  WORKSPACE="default"
fi

cd src/terraform
if [[ "$operation" == "create" ]]; then
  if terraform workspace list | grep -q " ${WORKSPACE}\$"; then

            terraform workspace select $workspace
            echo "Selected workspace: $WORKSPACE"

          else
            terraform workspace select default
            terraform state pull > terraform-default.tfstate
            terraform workspace new $WORKSPACE
            terraform state push terraform-default.tfstate
            echo "Created new workspace: $WORKSPACE"
          fi

elif [[ "$operation" == "delete" ]]; then
fi
