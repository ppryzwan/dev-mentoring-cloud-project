#!/bin/bash

# Initialize base terraform command as array
TERRAFORM_CMD=("terraform" "plan" "-out=tf.plan")

if [[ ! -f "target_modules" ]]; then
    echo "target_modules file not found - running normal terraform plan"
else
    if ! grep -v '^[[:space:]]*#' target_modules | grep -v '^[[:space:]]*$' > /dev/null; then
        echo "No targets - running normal terraform plan"
    else

        while IFS= read -r line; do
            if [[ -n "$line" && ! "$line" =~ ^[[:space:]]*# ]]; then
                if [[ "$line" == *","* ]]; then
                    IFS=',' read -ra TARGETS <<< "$line"
                    for target in "${TARGETS[@]}"; do
                        target=$(echo "$target" | xargs)
                        if [[ -n "$target" ]]; then
                            echo "DEBUG: Adding target: $target"
                            TERRAFORM_CMD+=("-target=$target")
                        fi
                    done
                else
                    target=$(echo "$line" | xargs)
                    if [[ -n "$target" ]]; then
                        TERRAFORM_CMD+=("-target=$target")
                    fi
                fi
            else
                echo "Skipping line (empty or comment)"
            fi
        done < target_modules
        echo "Final command: ${TERRAFORM_CMD[*]}"
    fi
fi

cd src/terraform
terraform init

echo "Executing: ${TERRAFORM_CMD[*]}"
"${TERRAFORM_CMD[@]}"

if [[ $? -eq 0 ]]; then
    echo "Plan created successfully: tf.plan"
else
    echo "Plan failed"
    exit 1
fi