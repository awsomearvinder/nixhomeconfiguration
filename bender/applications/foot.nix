{config, ...}: {
  programs.foot = if config.work_account then {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "FiraCode:size=11";
      };
    };
  } else {};
}
