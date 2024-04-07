{ ...}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "FiraCode:size=11";
        dpi-aware = "yes";
        shell = "elvish";
      };
    };
  };
}
