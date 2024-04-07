{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./applications/vscode.nix
    ./applications/mako.nix
    ./applications/gtk.nix
    ./applications/eww.nix
    ./applications/easyeffects.nix
  ];

  home.packages = lib.mkIf config.gui_supported (
    with pkgs;
    [
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
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      font-awesome_5
    ]
  );

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
  };

  fonts.fontconfig = {
    enable = true;
  };
}
