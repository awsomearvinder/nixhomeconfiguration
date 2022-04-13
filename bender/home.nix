system_config: { config, lib, pkgs, ... }:
with lib;
let
  user_configuration = import ./configuration.nix;
  custom_packages = [
    (pkgs.callPackage ./custom_pkgs/base16-shell.nix {})
  ];
in {
  imports = [
    ./applications/git.nix
    ./applications/ion.nix
    ./applications/starship.nix
    ./applications/neovim.nix
    ./applications/tmux.nix
    ./applications/kakoune.nix
  ] ++ (if system_config.gui_supported then
    [ ./gui_supported.nix ]
  else
    [ ]);

  options = {
    dots = mkOption { type = types.path; };
    modifier = mkOption { type = types.str; };
    scripts = mkOption { type = types.path; };
  };

  config = {
    inherit (user_configuration) dots modifier scripts;

    home.packages = with pkgs;
      [
        #this is making me want to cry, I can't make an overlay with a new version
        #without a stack overflow for some reason.
        ion
        pkgs.nixpkgs-master.nushell
        exa
        git
        pijul
        ripgrep
        bat
        bottom # top sucks.

        #development stuff
        mutt
        lynx
        nixfmt
        nodejs
        deno
        python39
        gdb
        nodePackages.pyright

        starship
      ] ++ custom_packages;

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
