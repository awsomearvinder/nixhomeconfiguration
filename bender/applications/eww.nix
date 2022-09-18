{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.eww-wayland
    pkgs.jq
    pkgs.pamixer
    pkgs.playerctl
  ];
}
