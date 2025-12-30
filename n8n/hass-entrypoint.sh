#!/bin/sh

export N8N_SECURE_COOKIE=false
export N8N_HIRING_BANNER_ENABLED=false
export N8N_PERSONALIZATION_ENABLED=false
export N8N_VERSION_NOTIFICATIONS_ENABLED=false
export N8N_RUNNERS_ENABLED=true
export N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
export N8N_PUBLIC_API_ENDPOINT=n8n-api

CONFIG_PATH="/data/options.json"

# Extract the values from env
eval "$(jq -r '.env | .[] | "export " + .' "$CONFIG_PATH")"


metadata() {
    wget -O - -q --header "Authorization: Bearer ${SUPERVISOR_TOKEN}" http://supervisor/$1
}

ADDON_INFO=$(metadata addons/self/info || echo $ADDON_INFO_FALLBACK)
ADDON_INFO=${ADDON_INFO:-'{}'}

export N8N_PATH=${N8N_PATH:-"$(echo "$ADDON_INFO" | jq -r '.data.ingress_url // "/"')"}
export N8N_USER_FOLDER="/data"

exec /docker-entrypoint.sh
