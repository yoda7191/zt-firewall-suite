#!/bin/bash

if ! docker info | grep -q 'Swarm: active'; then
    echo "[INFO] Initializing Docker Swarm..."
    docker swarm init
else
    echo "[INFO] Docker Swarm is already active."
fi