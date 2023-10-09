{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./applications/vscode.nix
    ./applications/mako.nix
    ./applications/alacritty.nix
    ./applications/foot.nix
    ./applications/gtk.nix
    ./applications/eww.nix
    ./applications/easyeffects.nix
  ];

  home.packages = lib.mkIf config.gui_supported (with pkgs;
    [
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
    ]);
  fonts.fontconfig = {enable = true;};
}
