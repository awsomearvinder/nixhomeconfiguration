{ config, lib, pkgs, ... }:
let unstable = import <unstable> { configuration = { allowUnfree = true; }; };
in {
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
    osu-lazer

    #general
    xournalpp

    #Audio
    pulseeffects-legacy

    #until I setup something with pactl.
    pavucontrol
    spotify

    #fonts
    font-awesome
    fira-code
    (nerdfonts.override { fonts = [ "FiraCode" ]; })

    #Video editing
    kdenlive

    #art
    krita
  ];
  fonts.fontconfig = { enable = true; };
}
