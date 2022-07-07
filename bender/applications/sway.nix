# A lot of this is gotten from https://github.com/alexarice/dotfiles/blob/18557c8e0bdd1c564ea68f8bb25a1894973d254d/dotfiles/sway.nix
{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config) dots scripts modifier;
in {
  wayland.windowManager.sway = {
    enable = true;

    package = pkgs.nixpkgs-unstable.sway;
    config = {
      bars = [];
      colors = {
        focused = {
          border = "#2b2b2b";
          background = "#2b2b2b";
          text = "#FFFFFF";
          indicator = "#2b2b2b";
          childBorder = "#e8e8e8";
        };
        focusedInactive = {
          border = "#282a36";
          background = "#282a36";
          text = "#999999";
          indicator = "#484e50";
          childBorder = "#282a36";
        };
        unfocused = {
          border = "#282a36";
          background = "#282a36";
          text = "#999999";
          indicator = "#282a36";
          childBorder = "#282a36";
        };
        urgent = {
          border = "#FF0000";
          background = "#8C5665";
          text = "#FF0000";
          indicator = "#900000";
          childBorder = "#FF0000";
        };
      };
      input = {
        "1133:16489:Logitech_MX_Master_2S" = {
          #disable mouse acceleration
          pointer_accel = "-1";
        };
      };
      output = {
        "DP-1" = {
          mode = "1920x1080@143Hz";
          background = "${dots}/wallpaper.png fill";
        };
        "HEADLESS-1" = {
          mode = "1680x1050";
          background = "${dots}/wallpaper.png fill";
        };
      };
      inherit modifier;
      terminal = if !config.work_account then "alacritty msg create-window || alacritty" else "footclient";
      workspaceAutoBackAndForth = true;
      keybindings = lib.mkOptionDefault {
        "${modifier}+p" = "exec grim -g \"$(slurp)\" - | wl-copy";
        "${modifier}+Shift+p" = "exec grim -o $(swaymsg --pretty -t get_outputs | awk '/focused/ {print $2}') - | wl-copy";
        "${modifier}+Ctrl+d" = ''exec "shutdown -h now"'';
      };
      window = {
        border = 1;
        titlebar = false;
      };
      startup = [
        #{ command = "dropbox start"; always = true; }
        {
          command = "mako";
          always = true;
        }
        {
          command = "waybar";
          always = true;
        }
        {
          command = "foot --server";
          always = false;
        }
      ];
    };
  };
}
