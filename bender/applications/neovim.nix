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
      gruvbox-nvim
      yats-vim
      vim-gitgutter
      vimtex
      vim-sensible
      vim-nix
      (nvim-treesitter.withPlugins (p: builtins.attrValues p))
      nvim-lspconfig
      nvim-compe
      telescope-nvim
      nerdtree
    ] ++ [(buildVimPlugin { # I'm guessing this is temporary, so I don't care about
    # making an overlay from the flake.nix.
      pname = "nvim-whichkey";
      version = "2021-06-20";
      src = pkgs.fetchFromGitHub{
        owner = "folke";
        repo = "which-key.nvim";
        rev = "bea079f1eb0574ca9fb4bcceab67c3dc2757c5f8";
        sha256 = "nNBni6I0G6HSI4aV9AUnfJX/LPaRaAOwZUtNhMIYUYM=";
      };
    })];
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
