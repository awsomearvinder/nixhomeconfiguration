#!/usr/bin/env bash

function sway_workspaces {
    swaymsg -r -t get_workspaces | jq -r 'map({name: .name, focused: .focused})'
}

function hyprland_workspaces {
    active_workspace=$(hyprctl activewindow -j | jq -r '.workspace.id')
    hyprctl workspaces -j | jq -r  "map({name: .name, focused: (.name == \"$active_workspace\")}) | sort_by(.name | tonumber)"
}

swaymsg 2&> /dev/null
is_sway=$?

if [ "$is_sway" -eq "2" ]; then
    sway_workspaces
else
    hyprland_workspaces
fi
