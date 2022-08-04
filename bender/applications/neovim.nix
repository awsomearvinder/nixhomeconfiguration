{
  config,
  pkgs,
  ...
}: let
  inherit (config) dots;
in let
  buildVimPlugin = pkgs.vimUtils.buildVimPlugin;
  gh-local = pkgs.stdenv.mkDerivation {
    name = "local-gh";
    buildInputs = [pkgs.makeWrapper];
    buildCommand = ''
      mkdir -p $out/bin
      ln -s ${pkgs.gh}/bin/gh $out/bin/gh
      wrapProgram $out/bin/gh --set GH_CONFIG_DIR '/home/bender/.config/gh'
    '';
  };
  plugins = with pkgs.vimPlugins; [
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
    plenary-nvim
    pkgs.nixpkgs-master.vimPlugins.telescope-ui-select-nvim
    nerdtree
    neoformat
    orgmode
    luasnip
    pkgs.nixpkgs-master.vimPlugins.which-key-nvim
    nvim-cmp
    cmp-nvim-lsp
    cmp-buffer
    octo-nvim
  ];
  plugins-folder = pkgs.stdenv.mkDerivation {
    name = "neovim-plugins";
    buildCommand = ''
      mkdir -p $out/nvim/site/pack/plugins/start/
      ${pkgs.lib.concatMapStringsSep "\n" (path: "ln -s ${path} $out/nvim/site/pack/plugins/start/")  plugins }
      '';
  };
  custom-neovim = pkgs.stdenv.mkDerivation {
    name = "custom-neovim";
    unpackPhase = "true";
    buildInputs = [pkgs.makeWrapper pkgs.fzf gh-local];
    buildPhase = "";
    installPhase = ''
      mkdir -p $out/bin
      ln -s ${pkgs.neovim}/bin/nvim $out/bin/nvim
      wrapProgram $out/bin/nvim --set XDG_CONFIG_HOME ${dots} \
        --set XDG_DATA_DIRS ${plugins-folder}
    '';
  };

in {
  home.packages = with pkgs; [
    custom-neovim
    pkgs.fzf pkgs.bat gh-local
  ];
}
