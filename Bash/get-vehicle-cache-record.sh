#!/bin/bash

# Source sensitive configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "${SCRIPT_DIR}/.env.secrets" ]]; then
    source "${SCRIPT_DIR}/.env.secrets"
else
    echo "Error: Configuration file .env.secrets not found in ${SCRIPT_DIR}" >&2
    return 1 2>/dev/null || exit 1
fi

# get_vehicle_cache_record.sh - Get the cached value for the vehicle rest api based on the cache key
# Usage: get_vehicle_cache_record.sh <key>

get_vehicle_cache_record() {
    local key="$1"

    # Check if required environment variables are set
    if [[ -z "$CLIENT_SECRET" || -z "$SUBSCRIPTION_KEY" ]]; then
        echo "Error: Required environment variables CLIENT_SECRET and SUBSCRIPTION_KEY must be set" >&2
        return 1
    fi

    local oauth_token=$(curl \
        -X POST \
        --location 'https://login.microsoftonline.com/81fa766e-a349-4867-8bf4-ab35e250a08f/oauth2/token' \
        --header 'Content-Type: application/x-www-form-urlencoded' \
        --data-urlencode 'grant_type=client_credentials' \
        --data-urlencode "client_id=${CLIENT_ID}" \
        --data-urlencode "client_secret=${CLIENT_SECRET}" \
        --data-urlencode 'resource=162d0933-e604-45e8-945b-6579ab2a868b' | jq -r '.access_token')

    local cache_response=$(curl \
        -X GET \
        --location "https://emea-grip-qa2.westeurope.cloudapp.azure.com/api/v1/vehicle-rest/${key}" \
        --header "Authorization: Bearer ${oauth_token}" \
        --header "Ocp-Apim-Subscription-Key: ${SUBSCRIPTION_KEY}" \
        --data '')

    # Extract the data field and format with proper indentation and colors
    echo "${cache_response}" | jq -r '.data' | jq -C '.'
}

# Create alias equivalent
alias gvcr='get_vehicle_cache_record'