{ pkgs, ... }:
{
  imports = [
    ./home.nix
    ./applications/alacritty.nix
    ./gui_supported.nix
  ];
  home.packages = with pkgs; [
    vlc
    pavucontrol
    webcord
    alacritty
    vesktop
    feishin
  ];
  custom.sway.enable = true;
  custom.wallpaper = "${./dotfiles/home_wallpaper.png}";
  custom.pfp = "${./dotfiles/profile.png}";
  custom.hyprland.enable = true;
  custom.terminal = "${pkgs.alacritty}/bin/alacritty msg create-window || systemd-run --no-ask-password --user --scope ${pkgs.alacritty}/bin/alacritty";
  custom.polkit.enable = true;

  custom.version_control = {
    enable_git = true;
    enable_jujutsu = true;
    name = "Arvinder Dhanoa";
    email = "ArvinderDhan@gmail.com";
    signing.gpg_key = "687341EC5B73B98BC5E4DC5D4599D30196519D5F";
  };

  # legacy
  work_account = false;
  gui_supported = true;
  modifier = "Mod4";
}
