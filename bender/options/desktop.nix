{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom;
in {
  imports = [
    ./desktop/sway.nix
    ./desktop/hyprland.nix
  ];

  options = {
    custom = {
      sway = {
        enable = lib.mkOption {
          default = false;
          description = ''
            Uses sway for the desktop.
          '';
        };
      };

      hyprland = {
        enable = lib.mkOption {
          default = false;
          description = ''
            Uses hyprland for the desktop.
          '';
        };
      };
    };
  };
  config = lib.mkIf ((cfg.sway.enable) || (cfg.hyprland.enable)) {
    home.packages = [
      pkgs.bemenu
      pkgs.swaybg
    ];
  };
}
