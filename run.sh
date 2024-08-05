#!/bin/bash

set -eo pipefail
SCRIPT_DIR="$(readlink -f "$(dirname -- "${BASH_SOURCE[0]}")")"

RUN_PROXY_ARGS=("-d" "-u" "0:0" "--name=netbootxyz" "--net=host" "--privileged" "--restart" "unless-stopped")
RUN_PROXY_ARGS+=("-e" "http_proxy=${http_proxy}" "-e" "https_proxy=${https_proxy}" "-e" "no_proxy=${no_proxy}" "-e" "TZ=Europe/Warsaw")

IMAGE_REGISTRY="${IMAGE_REGISTRY:-docker.io/}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
NETBOOT_FULL_TAG="${NETBOOT_FULL_TAG:-${IMAGE_REGISTRY}/netboot-xyz:${IMAGE_TAG}}"

docker run "${RUN_PROXY_ARGS[@]}" "$@" \
    -e MENU_VERSION=2.0.80 \
    -e PORT_RANGE=30000:30010 \
    -e NGINX_PORT=80 \
    -e WEB_APP_PORT=3000 \
    -v /opt/netboot-xyz/config:/config \
    -v /opt/netboot-xyz/assets:/assets \
    ${NETBOOT_FULL_TAG}
