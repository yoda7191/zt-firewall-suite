#!/bin/bash

if command -v x11vnc > /dev/null; then
    echo "[INFO] Starting x11vnc..."
    x11vnc -storepasswd /etc/x11vnc.pass
    x11vnc -forever -usepw -create &
elif command -v tightvncserver > /dev/null; then
    echo "[INFO] Starting tightvncserver..."
    mkdir -p ~/.vnc
    vncserver :1 -geometry 1024x768 -depth 24
else
    echo "[ERROR] No VNC server found. Install x11vnc or tightvncserver."
    exit 1
fi