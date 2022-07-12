{gui_supported ? false, work_account ? false}: {
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  user_configuration = import ./configuration.nix {inherit work_account;};
  custom_packages = [
    (pkgs.callPackage ./custom_pkgs/base16-shell.nix {})
  ];
in {
  imports =
    [
      ./applications/nushell.nix
      ./applications/git.nix
      ./applications/gnupg.nix
      ./applications/ion.nix
      ./applications/starship.nix
      ./applications/neovim.nix
      ./applications/tmux.nix
      ./applications/kakoune.nix
      ./applications/zellij.nix
    ]
    ++ (
      if gui_supported
      then [./gui_supported.nix]
      else []
    );

  options = {
    dots = mkOption {type = types.path;};
    modifier = mkOption {type = types.str;};
    scripts = mkOption {type = types.path;};
    gui_supported = mkOption {type = types.bool;};
    work_account = mkOption {type = types.bool;};
  };

  config = {
    inherit (user_configuration) dots modifier scripts;
    inherit gui_supported;
    inherit work_account;

    home.packages = with pkgs;
      [
        #this is making me want to cry, I can't make an overlay with a new version
        #without a stack overflow for some reason.
        ion
        exa
        git
        pijul
        ripgrep
        bat
        bottom # top sucks.

        #development stuff
        mutt
        nixfmt
        python39
        gdb
        rnix-lsp
        insomnia
        pandoc
        kicad

        starship
      ]
      ++ custom_packages
      ++ (if !work_account then [
        lynx
        nodejs
        deno
        nodePackages.pyright
      ] else [
        home-manager
      ]);

    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    # optional for nix flakes support in home-manager 21.11, not required in home-manager unstable or 22.05

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "20.09";
  };
}
