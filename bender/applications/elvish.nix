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
      set fish_color_autosuggestion 707A8C
      set fish_color_cancel --reverse
      set fish_color_command blue
      set fish_color_comment 5C6773
      set fish_color_cwd 73D0FF
      set fish_color_cwd_root red
      set fish_color_end F29E74
      set fish_color_error FF3333
      set fish_color_escape 95E6CB
      set fish_color_history_current --bold
      set fish_color_host normal
      set fish_color_host_remote yellow
      set fish_color_keyword 5CCFE6
      set fish_color_normal CBCCC6
      set fish_color_operator FFCC66
      set fish_color_option CBCCC6
      set fish_color_param CBCCC6
      set fish_color_quote BAE67E
      set fish_color_redirection D4BFFF
      set fish_color_search_match '--bold'  '--background=FFCC66'
      set fish_color_selection '--bold'  '--background=FFCC66'
      set fish_color_status red
      set fish_color_user brgreen
      set fish_color_valid_path --underline=single
      set fish_pager_color_background
      set fish_pager_color_completion normal
      set fish_pager_color_description B3A06D
      set fish_pager_color_prefix 'normal'  '--bold'  '--underline=single'
      set fish_pager_color_progress 'brwhite'  '--bold'  '--background=cyan'
      set fish_pager_color_secondary_background
      set fish_pager_color_secondary_completion
      set fish_pager_color_secondary_description
      set fish_pager_color_secondary_prefix
      set fish_pager_color_selected_background --background=FFCC66
      set fish_pager_color_selected_completion
      set fish_pager_color_selected_description
      set fish_pager_color_selected_prefix
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
