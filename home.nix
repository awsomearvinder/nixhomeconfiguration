{ config, lib, pkgs, ... }:
  with lib;
  let unstable = import <unstable> { configuration = { allowUnfree = true; }; };
  has_gui = true;
in {
  imports = [
    ./applications/git.nix
    ./applications/ion.nix
    ./applications/starship.nix
  ] ++ (if has_gui then [
    ./applications/waybar.nix
    ./applications/vscode.nix
    ./applications/sway.nix
    ./applications/mako.nix
    ./applications/alacritty.nix
  ] else []);

  options = {
    dots = mkOption { type = types.path; };
    modifier = mkOption { type = types.str; };
    scripts = mkOption { type = types.path; };
    gui_support = mkOption { type = types.boolean; };
  };

  config = {
    nixpkgs.config = { allowUnfree = true; };

    dots = ./dotfiles;
    modifier = "Mod4";
    scripts = /home/bender/.config/scripts;

    gui_support = has_gui;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    #This is kinda gross, I know.
    programs.neovim = import ./applications/neovim.nix pkgs;

    #enable these
    programs.firefox.enable = (if has_gui then true else false);

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = builtins.getEnv "USER";
    home.homeDirectory = builtins.getEnv "HOME";

    home.packages = with pkgs; [
      #this is making me want to cry, I can't make an overlay with a new version
      #without a stack overflow for some reason.
      ion
      exa
      git
      ripgrep
      bottom # top sucks.

      fzf # this is required for nvim's coc-fzf. not detected as a dep but /shrug

      #development stuff
      nixfmt
      nodejs
      unstable.deno
      python3
      (latest.rustChannels.stable.rust.override { extensions = ["rust-src"]; })
      texlive.combined.scheme-full
      gdb

      starship
    ] ++ (if has_gui then [
      #Sway.
      waybar
      dolphin
      breeze-icons
      mako # notification daemon.
      grim
      slurp
      wl-clipboard

      #CLI stuff.
      alacritty
      konsole

      #pdf viewer
      zathura

      #chat clients
      discord
      element-desktop

      #osu - need I say more?
      osu-lazer

      #general
      xournalpp

      #Audio
      pulseeffects

      #until I setup something with pactl.
      pavucontrol
      spotify

      #fonts
      font-awesome
      fira-code
      (nerdfonts.override { fonts = ["FiraCode"]; })

    ] else [
    ]);

    fonts.fontconfig = { enable = true; };

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
