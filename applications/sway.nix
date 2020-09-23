# A lot of this is gotten from https://github.com/alexarice/dotfiles/blob/18557c8e0bdd1c564ea68f8bb25a1894973d254d/dotfiles/sway.nix
{config, pkgs, lib, ...}: 
  let
    inherit (config) dots scripts modifier;
  in
  {
    wayland.windowManager.sway = {
      enable = true;
      package = null;

      config = {
        bars = [];
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
        fonts = [ "Source Code Pro 9" ];
        output = {
          "*" = {
            bg = "\"${dots + "/wallpaper.png"}\" fill";
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
          "${modifier}+n" = "exec caja";
          "${modifier}+m" = "exec \"GDK_BACKEND=x11 thunderbird\"";
          "${modifier}+c" = "exec firefox";
          #"${modifier}+p" = "exec ${scripts + "/take_screenshot"}";
          #"${modifier}+Shift+p" = "exec ${scripts + "/take_screenshot"} full";
          #"XF86MonBrightnessUp" = "exec \"brillo -A 1\"";
          #"XF86MonBrightnessDown" = "exec \"brillo -U 1\"";
          #"XF86AudioLowerVolume" = "exec \"pactl set-sink-volume 0 -5%\"";
          #"XF86AudioRaiseVolume" = "exec \"pactl set-sink-volume 0 +5%\"";
          #"XF86AudioPlay" = "exec \"playerctl play\"";
          #"XF86AudioPause" = "exec \"playerctl pause\"";
          #"XF86AudioNext" = "exec \"playerctl next\"";
          #"XF86AudioPrev" = "exec \"playerctl previous\"";
          #"${modifier}+x" = "exec networkmanager_dmenu";
          #"${modifier}+Ctrl+r" = "exec reboot";
          "${modifier}+Ctrl+d" = "exec \"shutdown -h now\"";
        };
        window = {
          border = 1;
          titlebar = false;
        };
        startup = [
          #{ command = "dropbox start"; always = true; }
          { command = "mako"; always = true; }
          { command = "waybar"; always = true; }
        ];
      };
    };
  }
