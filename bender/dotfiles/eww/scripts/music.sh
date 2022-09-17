#!/usr/bin/env bash
case $1 in
    "current-song")
        while true; do
            playerctl metadata title
        done
esac
