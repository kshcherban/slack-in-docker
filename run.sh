#!/bin/bash

# Allow connections to X server, uncomment if slack is not starting
#xhost +

# Build docker image
VERSION=${SLACK_VERSION:-3.3.3}
docker build --build-arg SLACK_VERSION=$VERSION --build-arg uid=$(id -u) --build-arg gid=$(id -g)  -t slack .

# Run slack
CONTAINER_HOME="/home/insider"
docker run -it --rm \
    -e NO_AT_BRIDGE=1 \
    -e DISPLAY=$DISPLAY \
    -e XAUTHORITY=${CONTAINER_HOME}/.Xauthority \
    -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
    -e DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
    --device /dev/snd \
    --device /dev/dri \
    --device /dev/video0 \
    --group-add audio \
    --group-add video \
    -v "${HOME}/.config/Slack:${CONTAINER_HOME}/.config/Slack" \
    -v "${XDG_RUNTIME_DIR}/bus:${XDG_RUNTIME_DIR}/bus" \
    -v $XAUTHORITY:${CONTAINER_HOME}/.Xauthority \
    -v /etc/localtime:/etc/localtime:ro \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "/run/dbus:/run/dbus" \
    --ipc="host" \
    --name slack \
    slack
