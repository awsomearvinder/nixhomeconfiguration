{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./home.nix
    ./applications/alacritty.nix
    ./gui_supported.nix
    ./applications/kicad.nix
  ];
  home.packages = with pkgs; [
    lynx
    nodejs
    deno
    nodePackages.pyright
    osu-lazer-bin
    pavucontrol
    pamixer
    kdenlive
    webcord
    element-desktop
    obs-studio
    vlc
    krita
    xournalpp
    calibre
    tidal-hifi
    dbeaver
    freecad
    alacritty
  ];

  custom.sway.enable = true;
  custom.hyprland.enable = true;

  # legacy.
  work_account = false;
  gui_supported = true;
}
