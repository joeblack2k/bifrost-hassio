#!/usr/bin/env bashio

bashio::log.info "Preparing to start..."

# Check if HA supervisor started
# Workaround for:
# - https://github.com/home-assistant/supervisor/issues/3884
# - https://github.com/BIFROST/hassio-BIFROST/issues/387
bashio::config.require 'data_path'

# Socat
if bashio::config.true 'socat.enabled'; then
    bashio::log.info "Socat enabled"
    SOCAT_MASTER=$(bashio::config 'socat.master')
    SOCAT_SLAVE=$(bashio::config 'socat.slave')

    # Validate input
    if [[ -z "$SOCAT_MASTER" ]]; then
    bashio::exit.nok "Socat is enabled but not started because no master address specified"
    fi
    if [[ -z "$SOCAT_SLAVE" ]]; then
    bashio::exit.nok "Socat is enabled but not started because no slave address specified"
    fi
    bashio::log.info "Starting socat"

    DATA_PATH=$(bashio::config 'data_path')
    SOCAT_OPTIONS=$(bashio::config 'socat.options')

    # Socat start configuration
    bashio::log.blue "Socat startup parameters:"
    bashio::log.blue "Options:     $SOCAT_OPTIONS"
    bashio::log.blue "Master:      $SOCAT_MASTER"
    bashio::log.blue "Slave:       $SOCAT_SLAVE"

    bashio::log.info "Starting socat process ..."
    exec socat $SOCAT_OPTIONS $SOCAT_MASTER $SOCAT_SLAVE &

    bashio::log.debug "Modifying process for logging if required"
    if bashio::config.true 'socat.log'; then
        bashio::log.debug "Socat loggin enabled, setting file path to $DATA_PATH/socat.log"
        exec &>"$DATA_PATH/socat.log" 2>&1
    else
    bashio::log.debug "No logging required"
    fi
else
    bashio::log.info "Socat not enabled"
fi

export BIFROST_DATA="$(bashio::config 'data_path')"
if ! bashio::fs.file_exists "$BIFROST_DATA/configuration.yaml"; then
    mkdir -p "$BIFROST_DATA" || bashio::exit.nok "Could not create $BIFROST_DATA"

    cat <<EOF > "$BIFROST_DATA/configuration.yaml"
homeassistant: true
advanced:
  network_key: GENERATE
  pan_id: GENERATE
  ext_pan_id: GENERATE
EOF
fi

if bashio::config.has_value 'watchdog'; then
    export BIFROST_WATCHDOG="$(bashio::config 'watchdog')"
    bashio::log.info "Enabled BIFROST watchdog with value '$BIFROST_WATCHDOG'"
fi

export NODE_PATH=/app/node_modules
export BIFROST_CONFIG_FRONTEND='{"port": 8099}'

if bashio::config.true 'disable_tuya_default_response'; then
    bashio::log.info "Disabling TuYa default responses"
    export DISABLE_TUYA_DEFAULT_RESPONSE="true"
fi

# Expose addon configuration through environment variables.
function export_config() {
    local key=${1}
    local subkey

    if bashio::config.is_empty "${key}"; then
        return
    fi

    for subkey in $(bashio::jq "$(bashio::config "${key}")" 'keys[]'); do
        export "BIFROST_CONFIG_$(bashio::string.upper "${key}")_$(bashio::string.upper "${subkey}")=$(bashio::config "${key}.${subkey}")"
    done
}

export_config 'z2m'
export_config 'serial'

if (bashio::config.is_empty 'z2m' || ! (bashio::config.has_value 'z2m.server' || bashio::config.has_value 'z2m.user' || bashio::config.has_value 'z2m.password')) && bashio::var.has_value "$(bashio::services 'z2m')"; then
    if bashio::var.true "$(bashio::services 'z2m' 'ssl')"; then
        export BIFROST_CONFIG_z2m_SERVER="http://$(bashio::services 'z2m' 'host'):$(bashio::services 'z2m' 'port')"
    else
        export BIFROST_CONFIG_z2m_SERVER="http://$(bashio::services 'z2m' 'host'):$(bashio::services 'z2m' 'port')"
    fi
    export BIFROST_CONFIG_z2m_USER="$(bashio::services 'z2m' 'username')"
    export BIFROST_CONFIG_z2m_PASSWORD="$(bashio::services 'z2m' 'password')"
fi

bashio::log.info "Starting BIFROST..."
cd /app
exec node index.js
