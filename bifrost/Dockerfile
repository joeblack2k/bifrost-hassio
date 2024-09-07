ARG BUILD_FROM
FROM $BUILD_FROM

# Copy local files
COPY rootfs /

# Set working directory
WORKDIR /config/bifrost

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install dependencies and set up the add-on
RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        jq \
    && rm -rf /var/lib/apt/lists/*

# Copy script to modify configuration
COPY copy_config.sh /
RUN chmod a+x /copy_config.sh

# Command to run the application
CMD ["/copy_config.sh && /usr/bin/bifrost"]