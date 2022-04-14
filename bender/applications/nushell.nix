{ config, pkgs, ... }:
{
  programs.nushell.enable = true;
  programs.nushell.package = pkgs.nixpkgs-master.nushell;
  xdg.configFile."nushell".source = (config.dots + "/nushell");
}
