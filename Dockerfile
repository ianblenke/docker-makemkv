#
# makemkv Dockerfile
#
# https://github.com/jlesage/docker-makemkv
#

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.8-v3.5.1

# Define software versions.
ARG OPENJDK_VERSION=11.0.1

# Define software download URLs.
ARG OPENJDK_URL=https://download.java.net/java/GA/jdk11/13/GPL/openjdk-${OPENJDK_VERSION}_linux-x64_bin.tar.gz

# Define working directory.
WORKDIR /tmp

# Install MakeMKV.
ADD makemkv-builder/makemkv.tar.gz /

# Install Java.
RUN \
    add-pkg --virtual build-dependencies \
        curl \
        binutils \
        findutils \
        && \
    mkdir /usr/lib/jvm/ && \
    # Download and extract.
    curl -# -L "${OPENJDK_URL}" | tar xz -C /usr/lib/jvm/ && \
    # Removed uneeded stuff.
    rm -r \
        /usr/lib/jvm/jdk-${OPENJDK_VERSION}/include \
        /usr/lib/jvm/jdk-${OPENJDK_VERSION}/jmods \
        /usr/lib/jvm/jdk-${OPENJDK_VERSION}/legal \
        /usr/lib/jvm/jdk-${OPENJDK_VERSION}/release \
        /usr/lib/jvm/jdk-${OPENJDK_VERSION}/lib/modules \
        /usr/lib/jvm/jdk-${OPENJDK_VERSION}/lib/src.zip \
        && \
    # Strip.
    find /usr/lib/jvm/jdk-${OPENJDK_VERSION} -type f -executable -or -name *.so -exec strip {} ';' && \
    # Cleanup.
    del-pkg build-dependencies && \
    rm -rf /tmp/* /tmp/.[!.]*

# Install dependencies.
RUN \
    add-pkg \
        wget \
        sed \
        findutils \
        util-linux \
        lsscsi

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/makemkv-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /

# Update the default configuration file with the latest beta key.
RUN /opt/makemkv/bin/makemkv-update-beta-key /defaults/settings.conf

# Set environment variables.
ENV APP_NAME="MakeMKV" \
    MAKEMKV_KEY="BETA"

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/storage"]
VOLUME ["/output"]

# Metadata.
LABEL \
      org.label-schema.name="makemkv" \
      org.label-schema.description="Docker container for MakeMKV" \
      org.label-schema.version="unknown" \
      org.label-schema.vcs-url="https://github.com/jlesage/docker-makemkv" \
      org.label-schema.schema-version="1.0"
