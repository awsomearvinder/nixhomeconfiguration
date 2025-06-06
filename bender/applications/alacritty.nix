{ ... }:
{
  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "fish";
      copy_command = "wl-copy";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell = "fish";
      font = {
        size = 12;
        normal = {
          family = "Fira Code Nerd Font";
          style = "Mono";
        };
      };
      colors = {
        primary = {
          background = "0x1b2b34";
          foreground = "0xc0c5ce";
        };
        cursor = {
          text = "0x1b2b34";
          cursor = "0xc0c5ce";
        };
        normal = {
          black = "0x1b2b34";
          red = "0xec5f67";
          green = "0x99c794";
          yellow = "0xfac863";
          blue = "0x6699cc";
          magenta = "0xc594c5";
          cyan = "0x5fb3b3";
          white = "0xc0c5ce";
        };
        bright = {
          black = "0x65737e";
          red = "0xec5f67";
          green = "0x99c794";
          yellow = "0xfac863";
          blue = "0x6699cc";
          magenta = "0xc594c5";
          cyan = "0x5fb3b3";
          white = "0xd8dee9";
        };
      };
    };
  };
}
