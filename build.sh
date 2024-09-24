#!/bin/bash

set -eo pipefail
SCRIPT_DIR="$(readlink -f "$(dirname -- "${BASH_SOURCE[0]}")")"

ENV_PROXY_ARGS=("--progress=plain")
while IFS='' read -r line; do ENV_PROXY_ARGS+=("--build-arg"); ENV_PROXY_ARGS+=("$line"); done < <(compgen -e | grep -E "_(proxy|PROXY)")

IMAGE_CACHE_REGISTRY="${IMAGE_CACHE_REGISTRY:-docker.io/library}"
IMAGE_REGISTRY="${IMAGE_REGISTRY:-docker.io}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
NETBOOT_FULL_TAG="${NETBOOT_FULL_TAG:-${IMAGE_REGISTRY}/tools/netboot-xyz:${IMAGE_TAG}}"

docker buildx build "${ENV_PROXY_ARGS[@]}" "$@" \
    --build-arg IMAGE_CACHE_REGISTRY="${IMAGE_CACHE_REGISTRY}" \
    -t "${NETBOOT_FULL_TAG}" \
    -f "${SCRIPT_DIR}/Dockerfile" \
    "${SCRIPT_DIR}"
