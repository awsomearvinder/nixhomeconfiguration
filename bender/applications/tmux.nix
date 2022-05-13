{
  pkgs,
  config,
  ...
}: {
  config = {
    programs.tmux = {
      enable = true;
      disableConfirmationPrompt = true;
      terminal = "screen-256color";
      shell = "${pkgs.ion}/bin/ion";
      prefix = "C-a";
      keyMode = "vi";
      reverseSplit = true;
      extraConfig = builtins.readFile (config.dots + "/tmux.conf");
    };
  };
}
