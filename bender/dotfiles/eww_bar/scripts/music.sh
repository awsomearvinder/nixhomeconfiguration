#!/usr/bin/env bash
case $1 in
    "current-song")
        playerctl --follow metadata title
        ;;

    "progress")
        while true; do
            playerctl metadata --format "{{ position * 100 / mpris:length }}"
        done
        ;;

    "set-progress")
        offset=$(playerctl metadata --format "{{ ($2 * mpris:length) / 100000000 }}")
        playerctl position "$offset" +
        # fi
        ;;

    "image")
        # stack overflow go brrrt
        image_folder=${XDG_RUNTIME_DIR:-${TMPDIR:-${TMP:-${TEMP:-/tmp}}}}/artUrls
        mkdir -p $image_folder 2> /dev/null

        playerctl --follow metadata mpris:artUrl | while read url; do
          file_name=$(echo "$url" | sed -s 's/\//_/g')
          if [ ! -f "$image_folder/$file_name" ]; then
              curl "$url" > "$image_folder/$file_name" 2> /dev/null
          fi
          echo "$image_folder/$file_name"
        done
esac
