#!/bin/bash

usage() {
    echo "Usage: swarm-init.sh [init|join]"
    echo "Commands:"
    echo "  init   Initialize a new Docker Swarm manager"
    echo "  join   Join an existing Docker Swarm"
    exit 1
}

if ! command -v docker > /dev/null; then
    echo "[ERROR] Docker not found. Please install Docker first."
    exit 1
fi

case "$1" in
    init)
        echo "[INFO] Initializing new Docker Swarm..."
        docker swarm init
        ;;

    join)
        if [ -z "$2" ]; then
            echo "[ERROR] Missing manager node address."
            echo "Usage: $0 join <manager-node-ip>:<port>"
            exit 1
        fi

        echo "[INFO] Joining Docker Swarm at $2..."
        docker swarm join --token SWMTKN-1-xxxxxx $2
        ;;

    *)
        usage
        ;;
esac