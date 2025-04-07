{ config, ... }:
let
  inherit (config) dots;
in
{
  xdg.configFile."elvish".source = ''${dots}/elvish'';
  programs.fish = {
    enable = true;
    shellInit = ''
      set SSH_AUTH_LOCK /run/user/1000/ssh-agent
    '';
    interactiveShellInit = ''
      starship init fish | source
    '';
    shellAliases = {
      ls = "eza -a";
      lsl = "eza -al";
      sudo = "sudo -E";
      sodu = "sudo --preserve-env=PATH -E";
      fucking = "sudo --preserve-env=PATH -E (string split ' ' $history[1])";
      nixd = "nix develop --command fish";
      lg = "lazygit";
    };
  };
}
