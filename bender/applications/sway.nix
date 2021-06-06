# A lot of this is gotten from https://github.com/alexarice/dotfiles/blob/18557c8e0bdd1c564ea68f8bb25a1894973d254d/dotfiles/sway.nix
{ config, pkgs, lib, ... }:
let inherit (config) dots scripts modifier;
in {
  wayland.windowManager.sway = {
    enable = true;

    config = {
      bars = [ ];
      colors = {
        focused = {
          border = "#81c1e4";
          background = "#81c1e4";
          text = "#FFFFFF";
          indicator = "#2e9ef4";
          childBorder = "#81c1e4";
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
      output = {
        "*" = { bg = ''"${dots + "/wallpaper.png"}" fill''; };
        "eDP-1" = {
          pos = "0 0";
          res = "1920x1080";
        };
        "HDMI-A-1" = {
          pos = "1920 0";
          res = "1920x1080";
        };
      };
      input = {
        "1133:16489:Logitech_MX_Master_2S" = {
          #disable mouse acceleration
          pointer_accel = "-1";
        };
      };
      gaps = {
        inner = 5;
        outer = 10;
        bottom = 0;
        smartBorders = "on";
      };
      inherit modifier;
      terminal = "alacritty";
      workspaceAutoBackAndForth = true;
      keybindings = lib.mkOptionDefault {
        "${modifier}+p" = "exec grim -g $(slurp) - | wl-copy";
        "${modifier}+Shift+p" =
          "exec grim -o $(swaymsg --pretty -t get_outputs | awk '/focused/ {print $2}') - | wl-copy";
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
      ];
    };
  };
}
