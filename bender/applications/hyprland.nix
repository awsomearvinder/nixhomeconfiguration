{
  config,
  pkgs,
  lib,
  ...
}: let
  colors = {
    dark-grey = "rgb(1d2021)";
    red = "rgb(cc241d)";
    accent = "rgb(ebdbb2)";
  };
  inherit (config) dots scripts modifier;
in {
  home.packages = [
    pkgs.bemenu
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
    extraConfig = ''
      #variables
      $term=${
        if !config.work_account
        then "alacritty msg create-window || systemd-run --no-ask-password --user --scope alacritty"
        else "systemd-run --no-ask-password --user --scope footclient"
      }
      $mod=SUPER
      $launcher=systemd-run --no-ask-password --user --scope $(${pkgs.bemenu}/bin/bemenu-run -l 10 --prompt ">" -P "" -H 10 -n -W 0.5 -c --nb "##1d2021" --fb "##1d2021" --hb "##1d2021" --ab "##1d2021" --tb "##1d2021" --no-exec)

      exec-once=eww open bar
      exec-once=mako
      exec-once=${pkgs.swaybg}/bin/swaybg -i ${dots}/home_wallpaper.jpg
      ${
        if config.work_account
        then "exec-once=foot --server"
        else ""
      }

      monitor=,highrr,auto,1
      workspace=,

      # SCREENSHOTS
      bind=$mod,p,exec,slurp -d | xargs -Idimensions grim -g dimensions - | wl-copy -t 'image/png'
      bind=$mod SHIFT,p,exec,hyprctl monitors -j | jq -c ".[] | select (.focused) | .name" | xargs -Ioutput grim -o output - | wl-copy -t 'image/png'
      bind=$mod SHIFT,Q,killactive

      # MOVE WINDOW FOCUS
      bind=$mod,h,movefocus,l
      bind=$mod,j,movefocus,d
      bind=$mod,k,movefocus,u
      bind=$mod,l,movefocus,r

      # MOVE WINDOWS
      bind=$mod SHIFT,h,movewindow,l
      bind=$mod SHIFT,j,movewindow,d
      bind=$mod SHIFT,k,movewindow,u
      bind=$mod SHIFT,l,movewindow,r

      # MISC KEYBINDINGS FOR COMPOSITOR
      bind=$mod,F,fullscreen
      bind=$mod,return,exec,$term
      bind=$mod,d,exec,$launcher

      general {
        border_size=2
        col.active_border=${colors.accent} ${colors.accent} 45deg
        col.inactive_border=${colors.dark-grey}
      }

      decoration {
        rounding=3
      }

      animations {
        enabled=false
      }

      # WORKSPACES
      ${
        builtins.concatStringsSep "\n"
        (builtins.map (i: let
          s_i = builtins.toString i;
        in ''
          bind=$mod,${s_i}, workspace, ${s_i}
          bind=$mod SHIFT,${s_i}, movetoworkspace, ${s_i}
        '') (lib.range 1 9))
      }

      input {
        accel_profile=flat
        sensitivity=-0.7
      }
    '';
  };
}
