# A lot of this is gotten from https://github.com/alexarice/dotfiles/blob/18557c8e0bdd1c564ea68f8bb25a1894973d254d/dotfiles/sway.nix
{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config) dots modifier;
  mkWallpaper = path: path + " fill";
  dark-grey = "#1d2021";
  red = "#cc241d";
  accent = "#ebdbb2";
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      #!/usr/bin/env bash
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user restart pipewire xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };
in
lib.mkIf config.custom.sway.enable {

  programs.hyprlock = {
    enable = true;
    settings = {
      background = [{
        path = "${config.custom.wallpaper}";
        blur_passes = 2;
      }];
      general = [{
        hide_cursor = true;
        no_fade_in = false;
        no_fade_out = false;
        grace = 0;
        disable_loading_bar = true;
      }];
      input-field = [{
        size = "350, 60";
        outline_thickness = 2;
        dots_size = 0.2;
        dots_spacing = 0.35;
        outer_color = "rgb(fbf1c7)";
        inner_color = "rgb(282828)";
        font_color = "rgb(fbf1c7)";
        fade_on_empty = false;
        rounding = -1;
        check_color = "rgb(204, 136, 34)";
        placeholder_text = "<i> Input Password... </i>";
        hide_input = false;
        position = "0, -200";
        halign = "center";
        valign = "center";
      }];
      image = [{
        path = "${config.custom.pfp}";
        size = "250";
        border_size = 2;
        border_color = "rgb(fbf1c7)";
        position = "0, 150";
      }];
    };
  };
  home.packages = [
    dbus-sway-environment
    pkgs.bemenu
    pkgs.swayidle
  ];
  wayland.windowManager.sway = {
    enable = true;

    package = pkgs.nixpkgs-unstable.sway;
    config = {
      menu = ''systemd-run --no-ask-password --user --scope $(${pkgs.bemenu}/bin/bemenu-run -l 10 --prompt ">" -P "" -H 10 -n -W 0.5 -c --nb "##1d2021" --fb "##1d2021" --hb "##1d2021" --ab "##1d2021" --tb "##1d2021" --no-exec)'';
      bars = [ ];
      # stolen from https://github.com/ziap/dotfiles/blob/master/.config/sway/config
      gaps = {
        inner = 8;
      };
      colors = {
        focused = {
          border = accent;
          background = accent;
          text = dark-grey;
          indicator = accent;
          childBorder = accent;
        };
        focusedInactive = {
          border = dark-grey;
          background = dark-grey;
          text = accent;
          indicator = dark-grey;
          childBorder = dark-grey;
        };
        unfocused = {
          border = dark-grey;
          background = dark-grey;
          text = accent;
          indicator = dark-grey;
          childBorder = dark-grey;
        };
        urgent = {
          border = red;
          background = red;
          text = accent;
          indicator = red;
          childBorder = red;
        };
      };
      input = {
        "1133:16489:Logitech_MX_Master_2S" = {
          #disable mouse acceleration
          pointer_accel = "-1";
        };
      };
      output = {
        "ASUSTek COMPUTER INC ASUS VG249 0x00035F38" =
          {
            mode = "1920x1080@143Hz pos 0 0";
          }
          // (
            if config.custom.wallpaper != null then
              { background = mkWallpaper config.custom.wallpaper; }
            else
              { }
          );

        "Dell Inc. DELL IN2030M V18WW2CD2BFM" =
          {
            mode = "1600x900@60Hz pos 0 0";
          }
          // (
            if config.custom.wallpaper != null then
              { background = mkWallpaper config.custom.wallpaper; }
            else
              { }
          );
      };

      workspaceOutputAssign = builtins.map (i: {
        workspace = "${builtins.toString i}";
        output = "ASUSTek COMPUTER INC ASUS VG249 0x00035F38";
      }) (lib.range 1 9);

      inherit modifier;
      terminal = config.custom.terminal;
      workspaceAutoBackAndForth = true;
      keybindings = lib.mkOptionDefault {
        "${modifier}+p" = "exec grim -g \"$(slurp -d)\" - | wl-copy -t 'image/png'";
        "${modifier}+Shift+p" = "exec grim -o \"$(swaymsg --pretty -t get_outputs | awk '/focused/ {print $2}')\" - | wl-copy -t 'image/png'";
        "${modifier}+Shift+d" = ''exec "shutdown -h now"'';
        "${modifier}+Next" = ''exec "hyprlock"'';
      };
      window = {
        border = 3;
        titlebar = false;
      };
      startup = [
        #{ command = "dropbox start"; always = true; }
        {
          command = "mako";
          always = false;
        }
        {
          command = "eww -c ${dots}/eww_bar open bar";
          always = false;
        }
        {
          command = "${dbus-sway-environment}";
          always = false;
        }
        {
          command = "swayidle \\
          timeout 300 'hyprlock' \\
          timeout 600 'swaymsg \"output * dpms off\"' resume 'swaymsg \"output * dpms on\"' \\
          timeout 900 'systemctl suspend' \\
          before-sleep 'hyprlock'";
          always = false;
        }
      ];
    };
  };
}
