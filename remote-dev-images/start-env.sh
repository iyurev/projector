#!/usr/bin/env bash

IDE_IMAGE=ide:main
IDE_NET_PORT=$(shuf -i 5990-65000 -n 1)

EXTERNAL_HOSTNAME=10.10.10.20

VERB=$1
PROJECT_PATH=$2

PROJECT_NAME=$(basename ${PROJECT_PATH})
CON_PROJECT_PATH=/workspace/$PROJECT_NAME

if [[ ${VERB} == "kill" ]]; then
    podman ps -a -q  -f "label=project_name=${PROJECT_NAME}" | xargs podman rm -f
    exit 0
fi

if [[ ${VERB} == "start" ]]; then

printf "Starting IDE container, project name: %s, project directory path in the container: %s\n" $PROJECT_NAME $CON_PROJECT_PATH

IDE_CONTAINER_ID=$(podman run -d -e "GITHUB_TOKEN=${GITHUB_TOKEN}" -l "project_name=${PROJECT_NAME}" -v $PROJECT_PATH:${CON_PROJECT_PATH}  -p ${IDE_NET_PORT}:5990 ${IDE_IMAGE} ${CON_PROJECT_PATH})

printf "Container ID: %s\n" $IDE_CONTAINER_ID

sleep 5

while true
    do
        JOIN_URL=$(podman exec -ti ${IDE_CONTAINER_ID} remote-dev-server.sh status  ${CON_PROJECT_PATH} | grep joinLink | awk -F '#' '{print $2}')
        if [[ -z ${JOIN_URL} ]]; then
        printf "status command output: %s\n" ${JOIN_URL}
        printf "IDE isn't ready yet, wait 5 sec, and try again...\n"
        sleep 5
        else 
        printf "Join link: %s\n" tcp://${EXTERNAL_HOSTNAME}:${IDE_NET_PORT}\#${JOIN_URL}
        exit 0
        fi
    done
fi
printf "Wrong verb argument: %s\n"  $VERB
exit 1