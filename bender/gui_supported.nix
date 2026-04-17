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
    ./applications/easyeffects.nix
  ];

  home.packages = lib.mkIf config.gui_supported (
    with pkgs;
    [
      #Sway.
      notify-desktop
      kdePackages.dolphin
      kdePackages.breeze-icons
      mako # notification daemon.
      grim
      slurp
      wl-clipboard

      kdePackages.konsole

      #pdf viewer
      zathura

      # password management.
      bitwarden-desktop

      #fonts
      font-awesome
      fira-code
      nerd-fonts.fira-code
      font-awesome_5

      protonplus
    ]
  );

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
  };

  fonts.fontconfig = {
    enable = true;
  };
}
