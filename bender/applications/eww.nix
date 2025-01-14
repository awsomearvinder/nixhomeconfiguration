{ config, pkgs, ... }:
{
  programs.eww = {
    enable = true;
    package = pkgs.eww;
    configDir = config.dots + "/eww_bar";
  };
  home.packages = [
    pkgs.jq
    pkgs.pamixer
    pkgs.playerctl
  ];
  services.playerctld.enable = true;
}
