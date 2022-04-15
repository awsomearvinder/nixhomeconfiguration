{ config, lib, pkgs, ... }:
{
  imports = [
    ./applications/waybar.nix
    ./applications/vscode.nix
    ./applications/sway.nix
    ./applications/mako.nix
    ./applications/alacritty.nix
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

    #CLI stuff.
    alacritty
    konsole

    #pdf viewer
    zathura

    #chat clients
    discord
    element-desktop

    #osu - need I say more?
    nixpkgs-master.osu-lazer

    #general
    xournalpp
    calibre

    #Audio
    nixpkgs-master.easyeffects

    #until I setup something with pactl.
    pavucontrol
    spotify

    #stuff.
    obs-studio

    #fonts
    font-awesome
    fira-code
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    font-awesome_5

    #latex
    texlive.combined.scheme-full

    dbeaver

    #Video editing
    kdenlive

    #Video Viewer
    vlc

    #art
    krita
  ];
  fonts.fontconfig = { enable = true; };
}
