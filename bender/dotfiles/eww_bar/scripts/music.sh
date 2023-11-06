#!/usr/bin/env bash
case $1 in
    "current-song")
        playerctl -p tidal-hifi --follow metadata title
        ;;
    "image")
        # stack overflow go brrrt
        image_folder=${XDG_RUNTIME_DIR:-${TMPDIR:-${TMP:-${TEMP:-/tmp}}}}/artUrls
        mkdir -p $image_folder 2> /dev/null

        playerctl -p tidal-hifi --follow metadata mpris:artUrl | while read url; do
          file_name=$(echo "$url" | sed -s 's/\//_/g')
          if [ ! -f "$image_folder/$file_name" ]; then
              curl "$url" > "$image_folder/$file_name" 2> /dev/null
          fi
          echo "$image_folder/$file_name"
        done
esac
