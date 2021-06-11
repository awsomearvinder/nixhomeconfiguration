{ config, pkgs, ... }:
let inherit (config) dots;
in let
  buildVimPlugin = pkgs.vimUtils.buildVimPlugin;
  configFiles = (builtins.readDir (dots + "/nvim"));
  configFileNames =
    (pkgs.lib.attrsets.mapAttrsToList (key: value: key) configFiles);
in {
  home.packages = with pkgs; [
    bat # required by my nixconfig
    fzf # required by my nixconfig
  ];
  xdg.configFile = builtins.listToAttrs (builtins.map (name: {
    name = "nvim/" + name;
    value = { source = "${dots}/nvim/${name}"; };
  }) configFileNames);
  programs.neovim = let
    startupPlugins = with pkgs.vimPlugins; [
      auto-pairs
      vim-highlightedyank
      vim-rooter
      fzf-vim
      gruvbox-nvim
      yats-vim
      vim-gitgutter
      vimtex
      vim-sensible
      vim-nix
      (nvim-treesitter.withPlugins(p: builtins.attrValues p))
      nvim-lspconfig
      nvim-compe
      telescope-nvim
      rust-tools-nvim
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
