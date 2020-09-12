{config, pkgs, ...}: {
  home.packages = with pkgs; [
    sway
    mako
    waybar
    xwayland
    pavucontrol
  ];
}
