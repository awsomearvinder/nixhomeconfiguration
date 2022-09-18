#!/usr/bin/env bash

while true; do
    output="(box "
    IFS="
"
    for i in $(swaymsg -r -t get_workspaces | jq -r '.[] | " (button :class " + (if .focused then "\"active-workspace\"" else "\"inactive-workspace\"" end) + " :onclick \" swaymsg workspace " + .name + "\" \"" + .name + "\")"')
    do
        output+="$i"
    done
    output+=")"
    echo $output
done
