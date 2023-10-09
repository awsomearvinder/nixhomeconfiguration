{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./home.nix
    ./applications/foot.nix
    ./gui_supported.nix
  ];
  home.packages = with pkgs; [
    pkgs.wayvnc
    pkgs.remmina
    pkgs.foot
  ];

  custom.sway.enable = true;

  # legacy.
  work_account = true;
  gui_supported = true;
}
