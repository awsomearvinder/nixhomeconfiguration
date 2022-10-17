{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./applications/vscode.nix
    ./applications/sway.nix
    ./applications/mako.nix
    ./applications/alacritty.nix
    ./applications/foot.nix
    ./applications/gtk.nix
    ./applications/eww.nix
  ];


  home.packages = with pkgs; [
    firefox-wayland
    #Sway.
    notify-desktop
    dolphin
    breeze-icons
    mako # notification daemon.
    grim
    slurp
    wl-clipboard

    konsole

    #pdf viewer
    zathura

    #fonts
    font-awesome
    fira-code
    (nerdfonts.override {fonts = ["FiraCode"];})
    font-awesome_5

  ] ++ (if !config.work_account then [
    #osu - need I say more?
    osu-lazer

    #until I setup something with pactl.
    pavucontrol
    pamixer

    #Video editing
    kdenlive

    #chat clients
    webcord
    element-desktop

    #stuff.
    obs-studio

    #Video Viewer
    vlc

    #art
    krita

    #general
    xournalpp
    calibre

    #Audio
    easyeffects
    tidal-hifi

    dbeaver

    freecad
    #kicad

    #CLI stuff.
    alacritty
  ] else [
    pkgs.wayvnc
    pkgs.remmina
    pkgs.foot
  ]);
  fonts.fontconfig = {enable = true;};
}
