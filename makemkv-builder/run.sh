#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILDER_DOCKER_IMAGE="ubuntu:xenial"

exec docker run --rm \
    -v "$SCRIPT_DIR:/output" \
    -v "$SCRIPT_DIR/builder:/builder:ro" \
    "$BUILDER_DOCKER_IMAGE" /builder/build.sh /output
