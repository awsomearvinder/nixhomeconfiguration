{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./home.nix
    ./applications/alacritty.nix
    ./gui_supported.nix
    ./applications/kicad.nix
  ];
  home.packages = with pkgs; [
    nodejs
    nodePackages.pyright
    osu-lazer-bin
    pavucontrol
    pamixer
    webcord
    element-desktop
    obs-studio
    vlc
    krita
    (tidal-hifi.overrideAttrs (_old: {
      src = fetchurl {
        url = "https://github.com/Mastermindzh/tidal-hifi/releases/download/5.7.1/tidal-hifi_5.7.1_amd64.deb";
        sha256 = "sha256-7wBQgoglLS67aiQsF9iUeFoJDDqq0fJgu5BSyH+HI7M=";
      };
    }))
    alacritty
  ];

  custom.sway.enable = true;
  custom.hyprland.enable = true;
  custom.terminal = "${pkgs.alacritty}/bin/alacritty msg create-window || systemd-run --no-ask-password --user --scope ${pkgs.alacritty}/bin/alacritty";

  custom.goldwarden.enable = true;
  custom.polkit.enable = true;
  
  custom.version_control = {
    enable_git = true;
    name = "Arvinder Dhanoa";
    email = "ArvinderDhan@gmail.com";
    signing.gpg_key = "687341EC5B73B98BC5E4DC5D4599D30196519D5F";
  };

  # legacy.
  work_account = false;
  gui_supported = true;
  modifier = "Mod4";
}
