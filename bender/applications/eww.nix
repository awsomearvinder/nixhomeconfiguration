{ config, pkgs, ... }:
{
  programs.eww.enable = true;
  programs.eww.package = pkgs.eww-wayland;
  programs.eww.configDir = config.dots + "/eww";
}
