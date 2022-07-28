{config, ...}: {
  programs.foot = if config.work_account then {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "FiraCode:size=11";
        dpi-aware = "yes";
        shell = "elvish";
      };
    };
  } else {};
}
