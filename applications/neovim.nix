{ config, ... }:
let
  pkgs = import <nixos> { };
  unstable = import <unstable> { };
  inherit (config) dots;
in let buildVimPlugin = pkgs.vimUtils.buildVimPlugin;
in {
  home.packages = with pkgs; [
    bat # required by my nixconfig
    fzf # required by my nixconfig
  ];
  home.file.".config/nvim/lua".source = dots + "/nvim/lua";
  programs.neovim = let
    startupPlugins = with pkgs.vimPlugins; [
      unstable.vimPlugins.coc-nvim # coc needs to stay up to date.
      auto-pairs
      vim-highlightedyank
      vim-rooter
      fzf-vim
      base16-vim
      yats-vim
      vim-gitgutter
      vimtex
      vim-airline
      vim-sensible
      vim-nix
      (buildVimPlugin {
        pname = "vimpeccable";
        version = "10-31-2020";
        src = (pkgs.fetchFromGitHub {
          owner = "svermeulen";
          repo = "vimpeccable";
          rev = "00300b311de64d91b3facc1e4a6fe11463735e68";
          sha256 = "0mb8a7ypd6pvbjpa46h9hmc8isvxfmn7dq5gcpdg6h2wmkgrv4c4";
        });
      })
    ];
  in {
    enable = true;
    vimAlias = true;
    viAlias = true;
    withNodeJs = true;
    withRuby = true;
    extraConfig = "lua require('config')";
    plugins = [ ]
      ++ (builtins.map (plugin: { inherit plugin; }) startupPlugins);
  };
}
