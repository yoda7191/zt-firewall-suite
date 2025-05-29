#!/bin/bash

echo "[INFO] Deploying sample stack..."
docker stack deploy -c ./docker-compose.yml myapp
