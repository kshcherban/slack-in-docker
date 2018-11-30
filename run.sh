#!/bin/bash

# Allow connections to X server
#xhost +

# Build docker image
VERSION=${SLACK_VERSION:-3.3.3}
docker build --build-arg SLACK_VERSION=$VERSION --build-arg uid=$(id -u) --build-arg gid=$(id -g)  -t slack .

docker run -it --rm \
    -v /etc/localtime:/etc/localtime:ro \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $XAUTHORITY:/home/insider/.Xauthority \
    -e NO_AT_BRIDGE=1 \
    -e DISPLAY=$DISPLAY \
    -e XAUTHORITY=/home/insider/.Xauthority \
    -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
    -e DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
    --device /dev/snd \
    --device /dev/dri \
    --device /dev/video0 \
    --group-add audio \
    --group-add video \
    -v "${HOME}/.config/Slack:/home/insider/.config/Slack" \
    -v "${XDG_RUNTIME_DIR}/bus:${XDG_RUNTIME_DIR}/bus" \
    -v "/run/dbus:/run/dbus" \
    --ipc="host" \
    --net="host" \
    --name slack \
    slack
