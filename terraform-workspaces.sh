
#!/bin/bash

operation=$1
BRANCH_NAME=$2


if [[ "$BRANCH_NAME" == *"feature/"* ]]; then
    WORKSPACE=${BRANCH_NAME#*feature/}
elif [[ "$BRANCH_NAME" == *"bugfix/"* ]]; then
    WORKSPACE=${BRANCH_NAME#*bugfix/}
elif [[ "$BRANCH_NAME" == "main" ]]; then
    WORKSPACE="default"
else
    WORKSPACE="$BRANCH_NAME"
fi

cd src/terraform

if [[ "$operation" == "create" ]]; then
    if terraform workspace list | grep -q " ${WORKSPACE}\$"; then
        terraform workspace select "$WORKSPACE"
        echo "Selected workspace: $WORKSPACE"
    else
        terraform workspace select default
        terraform state pull > terraform-default.tfstate
        terraform workspace new "$WORKSPACE"
        terraform state push terraform-default.tfstate
        rm -f terraform-default.tfstate
        echo "Created new workspace: $WORKSPACE"
    fi
elif [[ "$operation" == "delete" ]]; then
    if terraform workspace list | grep -q " ${WORKSPACE}\$"; then
        terraform workspace select "$WORKSPACE"
        echo "Selected workspace: $WORKSPACE"
        echo "Deleting old infrastructure for workspace"
        terraform workspace select default 
        terraform state list > default_resources.txt
        terraform workspace select "$WORKSPACE"
        terraform state list > workspace_resources.txt
        sort workspace_resources.txt -o workspace_resources.txt
        sort default_resources.txt -o default_resources.txt
        destroy_resources=$(comm -23 workspace_resources.txt default_resources.txt)
        echo "Resources to destroy: $destroy_resources"
        rm -f workspace_resources.txt default_resources.txt
        if [[ -z "$destroy_resources" ]]; then
            echo "No resources to destroy"
            terraform workspace select default
            terraform workspace delete -force "$WORKSPACE"  2>/dev/null

            echo "Deleted workspace: $WORKSPACE"
            exit 0
        fi

        DESTROY_CMD="terraform destroy -auto-approve"
        while IFS= read -r resource; do
            if [[ -n "$resource" ]]; then
                DESTROY_CMD="$DESTROY_CMD -target=\"$resource\""
            fi
        done <<< "$destroy_resources"
        
        echo "Executing: $DESTROY_CMD"
        eval "$DESTROY_CMD"
        echo "Destroyed old infrastructure for workspace"
    fi
        terraform workspace select default
        terraform workspace delete -force "$WORKSPACE" 2>/dev/null

        echo "Deleted workspace: $WORKSPACE"
fi