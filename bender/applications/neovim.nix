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
      telescope-nvim
      nerdtree
      neoformat
      neorg
      luasnip
      which-key-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
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
