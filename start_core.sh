#!/bin/bash

COMMAND=$1

pushd $(dirname $0) &>/dev/null
REPOROOT=$(git rev-parse --show-superproject-working-tree)
if [ -z "$REPOROOT" ]; then
    REPOROOT=$(git rev-parse --show-toplevel)
fi
echo "REPOROOT=$REPOROOT"
CONTAINER_NAME=$(basename $REPOROOT)
popd &>/dev/null

export DOCKERTAG="jsola/verilog-tools:latest"
if [[ "$(docker images -q $DOCKERTAG 2> /dev/null)" == "" ]]; then
    echo "Docker image not detected, pulling image... "
    docker pull $DOCKERTAG 

fi

if [[ "$(docker ps -f name=^$CONTAINER_NAME$ | sed -n '1!p')" == "" ]]; then 
    echo "Creating container ..."
    docker run -w $REPOROOT --user $(id -u $(whoami)) -i -t -d -v $REPOROOT:$REPOROOT --name=$CONTAINER_NAME $DOCKERTAG > /dev/null
fi

docker exec -t $CONTAINER_NAME bash -c "$COMMAND"
