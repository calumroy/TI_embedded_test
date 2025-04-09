#!/usr/bin/env bash

CONTAINER_NAME="my-ti-container"
IMAGE_NAME="ti_embedded_test:latest"

# 1) Check if container already exists
if ! podman ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo "Container '${CONTAINER_NAME}' does not exist. Creating and starting it..."
    podman run -d --privileged \
        -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v "$(pwd)/project:/app/project" \
        -e DISPLAY \
        --group-add=keep-groups \
        --device=/dev/ttyACM0:/dev/ttyACM0 \
        --device=/dev/ttyACM1:/dev/ttyACM1 \
        --name "${CONTAINER_NAME}" \
        "${IMAGE_NAME}"
fi

# 2) If container exists but is not running, start it
if ! podman ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo "Container '${CONTAINER_NAME}' is not running. Starting it..."
    podman start "${CONTAINER_NAME}"
else
    echo "Container '${CONTAINER_NAME}' is already running."
fi

# 3) Finally, run an interactive bash shell inside the container in the project directory
echo "Attaching to '${CONTAINER_NAME}'..."
podman exec -it -w /app/project "${CONTAINER_NAME}" /bin/bash
