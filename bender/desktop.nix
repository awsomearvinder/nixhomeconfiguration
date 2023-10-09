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

  custom.version_control = {
    enable_git = true;
    name = "Arvinder Dhanoa";
    email = "ArvinderDhan@gmail.com";
    signing.gpg_key = "687341EC5B73B98BC5E4DC5D4599D30196519D5F";
  };

  # legacy.
  work_account = false;
  gui_supported = true;
}
