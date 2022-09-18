#!/usr/bin/env bash
case $1 in
    "current-song")
        while true; do
            sleep 0.05
            playerctl metadata title
        done
esac
