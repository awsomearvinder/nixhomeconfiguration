#!/usr/bin/env bash
PLAYER="tidal-hifi"
case $1 in
    "current-song")
        while true; do
            sleep 0.05
            playerctl -p $PLAYER metadata title
        done
        ;;
    "image")
        temp_dir=$(mktemp -d)
        current_song=""
        while true; do
            sleep 0.05
            if [ "$current_song" != "$(playerctl -p $PLAYER metadata title)" ]; then
                current_song=$(playerctl -p $PLAYER metadata title)
                image_url=$(playerctl -p $PLAYER metadata mpris:artUrl)
                curl $image_url 2> /dev/null > $temp_dir/pic.jpg
                echo "$temp_dir/pic.jpg"
            fi
        done
        ;;
esac
