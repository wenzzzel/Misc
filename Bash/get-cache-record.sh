#!/bin/bash

# Source sensitive configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "${SCRIPT_DIR}/.env.secrets" ]]; then
    source "${SCRIPT_DIR}/.env.secrets"
else
    echo "Error: Configuration file .env.secrets not found in ${SCRIPT_DIR}" >&2
    return 1 2>/dev/null || exit 1
fi

# get_cache_record.sh - Get the cached value for the vehicle rest api based on the cache key
# Usage: get_cache_record.sh <domain> <environment> <key>

get_cache_record() {
    local domain="$1"
    local environment="$2"
    local key="$3"

    local client_id="";
    local client_secret="";
    local resource="";
    local subscription_key="";
    local cacheproxy_base_url="";

    case "$environment" in
        "test") 
            client_id="${CLIENT_ID_TEST}";
            client_secret="${CLIENT_SECRET_TEST}";
            resource="${RESOURCE_TEST}";
            subscription_key="${SUBSCRIPTION_KEY_TEST}";
            cacheproxy_base_url="${CACHEPROXY_BASE_URL_TEST}";
            ;;
        "qa") 
            client_id="${CLIENT_ID_QA}";
            client_secret="${CLIENT_SECRET_QA}";
            resource="${RESOURCE_QA}";
            subscription_key="${SUBSCRIPTION_KEY_QA}";
            cacheproxy_base_url="${CACHEPROXY_BASE_URL_QA}";
            ;;
        "prod") 
            client_id="${CLIENT_ID_PROD}";
            client_secret="${CLIENT_SECRET_PROD}";
            resource="${RESOURCE_PROD}";
            subscription_key="${SUBSCRIPTION_KEY_PROD}";
            cacheproxy_base_url="${CACHEPROXY_BASE_URL_PROD}";
            ;;
        *)
            echo "Error: Invalid environment '$environment'. Must be one of: test, qa, prod" >&2
            return 1
            ;;
    esac

    local cacheproxy_path=""

    case "$domain" in
        "order")
            cacheproxy_path="order";
            ;;
        "vehicle-graphql")
            cacheproxy_path="vehicle-graphql";
            ;;
        "vehicle-rest")
            cacheproxy_path="vehicle-rest";
            ;;
        "consumer")
            cacheproxy_path="consumer";
            ;;
        "policy")
            cacheproxy_path="policy";
            ;;
        *)
            echo "Error: Invalid domain '$domain'. Must be one of: order, vehicle-graphql, vehicle-rest, consumer, policy" >&2
            return 1
            ;;
    esac

    # Check if required environment variables are set
    if [[ -z "$CLIENT_ID_TEST" || 
        -z "$CLIENT_ID_QA" || 
        -z "$CLIENT_ID_PROD" || 
        -z "$CLIENT_SECRET_TEST" || 
        -z "$CLIENT_SECRET_QA" || 
        -z "$CLIENT_SECRET_PROD" || 
        -z "$RESOURCE_TEST" || 
        -z "$RESOURCE_QA" || 
        -z "$RESOURCE_PROD" || 
        -z "$SUBSCRIPTION_KEY_TEST" || 
        -z "$SUBSCRIPTION_KEY_QA" || 
        -z "$SUBSCRIPTION_KEY_PROD" || 
        -z "$CACHEPROXY_BASE_URL_TEST" || 
        -z "$CACHEPROXY_BASE_URL_QA" || 
        -z "$CACHEPROXY_BASE_URL_PROD" ]]; then
        echo "Error: Required environment variables CLIENT_ID_<ENV>, CLIENT_SECRET_<ENV>, RESOURCE_<ENV>, SUBSCRIPTION_KEY_<ENV> and CACHEPROXY_BASE_URL_<ENV> must be set for all environments" >&2
        return 1
    fi


    local oauth_token=$(curl -s \
        -X POST \
        --location 'https://login.microsoftonline.com/81fa766e-a349-4867-8bf4-ab35e250a08f/oauth2/token' \
        --header 'Content-Type: application/x-www-form-urlencoded' \
        --data-urlencode 'grant_type=client_credentials' \
        --data-urlencode "client_id=${client_id}" \
        --data-urlencode "client_secret=${client_secret}" \
        --data-urlencode "resource=${resource}" | jq -r '.access_token')

    local cache_response=$(curl -s \
        -X GET \
        --location "${cacheproxy_base_url}/${cacheproxy_path}/${key}" \
        --header "Authorization: Bearer ${oauth_token}" \
        --header "Ocp-Apim-Subscription-Key: ${subscription_key}" \
        --data '')

    # Extract the data field and format with proper indentation and colors
    echo "${cache_response}" | jq -r '.data' | jq -C '.'
}

# Create alias equivalent
alias gcr='get_cache_record'