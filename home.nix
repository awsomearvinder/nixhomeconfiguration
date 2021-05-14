{ config, lib, pkgs, ... }:
with lib;
let
  unstable = import <unstable> { configuration = { allowUnfree = true; }; };
  user_configuration = import ./configuration.nix;
  custom_packages = [
    (import ./custom_pkgs/buzz.nix pkgs) # buzz for email notifiactions...
    # note: this dosen't actually work. Compiles though, the package is just borked.
  ];
in {
  imports = [
    ./applications/git.nix
    ./applications/ion.nix
    ./applications/starship.nix
    ./applications/neovim.nix
  ] ++ (if user_configuration.gui_support then
    [ ./gui_supported.nix ]
  else
    [ ]);

  options = {
    dots = mkOption { type = types.path; };
    modifier = mkOption { type = types.str; };
    scripts = mkOption { type = types.path; };
    gui_support = mkOption { type = types.boolean; };
  };

  config = {
    nixpkgs.config = { allowUnfree = true; };

    inherit (user_configuration) dots modifier scripts gui_support;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = builtins.getEnv "USER";
    home.homeDirectory = builtins.getEnv "HOME";

    home.sessionVariables = {
      RUST_SRC_PATH =
        "${unstable.rust.packages.stable.rustPlatform.rustLibSrc}";
    };

    home.packages = with pkgs;
      [
        #this is making me want to cry, I can't make an overlay with a new version
        #without a stack overflow for some reason.
        ion
        exa
        git
        ripgrep
        bat
        unstable.bottom # top sucks.

        #development stuff
        mutt
        lynx
        nixfmt
        nodejs
        unstable.deno
        python39
        unstable.black
        python3.pkgs.pylint
        unstable.cargo
        unstable.rustc
        texlive.combined.scheme-full
        gdb
        notify-desktop

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
