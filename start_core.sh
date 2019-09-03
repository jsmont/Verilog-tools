#!/bin/bash

REPOROOT=$1
CONTAINER_NAME=$2

export DOCKERTAG="jsola/verilog-tools:latest"
if [[ "$(docker images -q $DOCKERTAG 2> /dev/null)" == "" ]]; then
    echo "Docker image not detected, pulling image... "
    docker pull $DOCKERTAG 

fi

if [[ "$(docker ps -f name=^$CONTAINER_NAME$ | sed -n '1!p')" == "" ]]; then 
    echo "Creating container ..."
    docker run -w $REPOROOT --user $(id -u $(whoami)) -i -t -d -v $REPOROOT:$REPOROOT --name=$CONTAINER_NAME $DOCKERTAG > /dev/null
fi
