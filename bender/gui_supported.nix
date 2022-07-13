{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./applications/waybar.nix
    ./applications/vscode.nix
    ./applications/sway.nix
    ./applications/mako.nix
    ./applications/alacritty.nix
    ./applications/foot.nix
    ./applications/gtk.nix
  ];

  #enable these
  programs.firefox.enable = true;

  home.packages = with pkgs; [
    #Sway.
    notify-desktop
    waybar
    dolphin
    breeze-icons
    mako # notification daemon.
    grim
    slurp
    wl-clipboard

    #Gnome
    gnome3.gnome-tweaks

    konsole

    #pdf viewer
    zathura

    #fonts
    font-awesome
    fira-code
    (nerdfonts.override {fonts = ["FiraCode"];})
    font-awesome_5

    #latex
    texlive.combined.scheme-full

  ] ++ (if !config.work_account then [
    #osu - need I say more?
    nixpkgs-master.osu-lazer

    #until I setup something with pactl.
    pavucontrol
    spotify

    #Video editing
    kdenlive

    #chat clients
    discord
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
    nixpkgs-master.easyeffects

    dbeaver

    freecad
    kicad
  ] else []) ++ (if config.work_account then [
    pkgs.wayvnc
    pkgs.foot
  ] else [
    #CLI stuff.
    alacritty
  ]);
  fonts.fontconfig = {enable = true;};
}
