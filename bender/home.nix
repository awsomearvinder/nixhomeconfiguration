{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  user_configuration = import ./configuration.nix {inherit (config) work_account;};
  custom_packages = [
    (pkgs.callPackage ./custom_pkgs/base16-shell.nix {})
  ];
in {
  imports =
    [
      ./applications/helix.nix
      ./applications/git.nix
      ./applications/gnupg.nix
      ./applications/elvish.nix
      ./applications/starship.nix
      ./applications/kicad.nix
      ./applications/systemd.nix
      ./options/lib.nix
      ./gui_supported.nix
    ];

  options = {
    dots = mkOption {type = types.path;};
    modifier = mkOption {type = types.str;};
    scripts = mkOption {type = types.path;};
    gui_supported = mkOption {type = types.bool;};
    work_account = mkOption {type = types.bool;};
  };

  config = {
    inherit (user_configuration) dots modifier scripts;

    home.packages = with pkgs;
      [
        #this is making me want to cry, I can't make an overlay with a new version
        #without a stack overflow for some reason.
        ion
        elvish
        eza
        git
        pijul
        ripgrep
        bat
        bottom # top sucks.
        custom-neovim
        xdg-utils
        sqls
        nil

        #development stuff
        mutt
        nixfmt
        python39
        gdb
        rnix-lsp
        insomnia
        pandoc
        podman-compose

        starship
      ]
      ++ custom_packages;
      # ++ (
        # lib.mkIf config.work_account [ home-manager ]
      # );

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
