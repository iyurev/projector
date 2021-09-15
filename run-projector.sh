#!/bin/sh
#https://jetbrains.github.io/projector-client/mkdocs/latest/ij_user_guide/server_customization/

set -e # Any command which returns non-zero exit code will cause this shell script to exit immediately
set -x # Activate debugging to show execution details: all commands will be printed before execution

ORG_JETBRAINS_PROJECTOR_SERVER_MAC_KEYBOARD=True
ORG_JETBRAINS_PROJECTOR_SERVER_SSL_PROPERTIES_PATH=/ssl/ssl.properties

containerName=ghcr.io/iyurev/projector-goland:2020.3.0.1

podman run --rm -p 8887:8887 	-v $HOME/projector:/home/projector-user \
				-v $HOME/projector-ssl.properties:/ssl/ssl.properties \
				-v $HOME/keystore.jks:/ssl/keystore.jks \
				-e ORG_JETBRAINS_PROJECTOR_SERVER_SSL_PROPERTIES_PATH=/ssl/ssl.properties \
				-e ORG_JETBRAINS_PROJECTOR_SERVER_MAC_KEYBOARD=True \
				--userns=keep-id  -it "$containerName"
