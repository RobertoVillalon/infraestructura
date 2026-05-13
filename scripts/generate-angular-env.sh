#!/bin/bash

set -e

mkdir -p src/environments

echo "export const environment = {" > src/environments/environment.ts

FIRST=true

IFS=';' read -ra KEYS <<< "$ENV_KEYS"

for key in "${KEYS[@]}"; do
    value=$(echo "$SECRETS_JSON" | jq -r --arg k "$key" '.[$k]')

    if [ "$value" = "null" ] || [ -z "$value" ]; then
        echo "Secret '$key' not found, skipping..."
        continue
    fi

    if [ "$FIRST" = true ]; then
        FIRST=false
    else
        echo "," >> src/environments/environment.ts
    fi

    js_key=$(echo "$key" | awk -F'_' '{
        print $1
    }')

    echo "  $js_key: \"$value\"" >> src/environments/environment.ts
done

echo "" >> src/environments/environment.ts
echo "}" >> src/environments/environment.ts

echo "Generated environment.ts:"
cat src/environments/environment.ts
