{
  config,
  pkgs,
  ...
}: let
  inherit (config) dots;
in let
  buildVimPlugin = pkgs.vimUtils.buildVimPlugin;
  configFiles = builtins.readDir (dots + "/nvim");
  configFileNames =
    pkgs.lib.attrsets.mapAttrsToList (key: value: key) configFiles;
  configured-neovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
    vimAlias = true;
    viAlias = true;
    withNodeJs = true;
    withRuby = false;
    withPython3 = true;
    configure = {
      customRC = "lua require('config')";
      packages.myVimPackage.start = with pkgs.vimPlugins; [
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
        pkgs.nixpkgs-master.vimPlugins.telescope-ui-select-nvim
        nerdtree
        neoformat
        orgmode
        luasnip
        pkgs.nixpkgs-master.vimPlugins.which-key-nvim
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
      ];
    };
  };
  custom-neovim = pkgs.stdenv.mkDerivation {
    name = "custom-neovim";
    unpackPhase = "true";
    buildInputs = [configured-neovim pkgs.makeWrapper];
    buildPhase = "";
    installPhase = ''
      mkdir -p $out/bin
      ln -s ${configured-neovim}/bin/nvim $out/bin/nvim
      wrapProgram $out/bin/nvim --set XDG_CONFIG_HOME ${dots} \
        --prefix PATH ${pkgs.lib.makeBinPath [pkgs.fzf pkgs.bat]}
    '';
  };

in {
  home.packages = with pkgs; [
    custom-neovim
  ];
}
