{ config, pkgs, ... }:
{
  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = config.dots + "/eww_bar";
  };
  home.packages = [
    pkgs.eww-wayland
    pkgs.jq
    pkgs.pamixer
    pkgs.playerctl
  ];
}
