{ pkgs, ... }:
{
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
  custom.terminal = "systemd-run --no-ask-password --user --scope ${pkgs.foot}/bin/footclient || foot --server";
  custom.wallpaper = "${./dotfiles/work_wallpaper.png}";
  custom.version_control = {
    enable_git = true;
    name = "Arvinder Dhanoa";
    email = "arvinder.dhanoa@winona.edu";
    signing.gpg_key = "D938E040245154F8";
  };

  # legacy.
  work_account = true;
  gui_supported = true;
  modifier = "Mod1";
}
