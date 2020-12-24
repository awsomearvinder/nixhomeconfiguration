{ config, lib, pkgs, ... }:
  with lib;
  let unstable = import <unstable> { configuration = { allowUnfree = true; }; };
in {
  imports = [
    ./applications/git.nix
    ./applications/vscode.nix
    ./applications/sway.nix
    ./applications/mako.nix
    ./applications/alacritty.nix
    ./applications/ion.nix
    ./applications/waybar.nix
    ./applications/starship.nix
  ];

  options = {
    dots = mkOption { type = types.path; };
    modifier = mkOption { type = types.str; };
    scripts = mkOption { type = types.path; };
  };

  config = {
    nixpkgs.config = { allowUnfree = true; };

    dots = ./dotfiles;
    modifier = "Mod4";
    scripts = /home/bender/.config/scripts;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    #This is kinda gross, I know.
    programs.neovim = import ./applications/neovim.nix pkgs;

    #enable these
    programs.firefox.enable = true;

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = builtins.getEnv "USER";
    home.homeDirectory = builtins.getEnv "HOME";

    home.packages = with pkgs; [
      #general
      xournalpp

      #Audio
      pulseeffects

      #until I setup something with pactl.
      pavucontrol
      spotify

      #chat clients
      discord
      element-desktop

      #CLI stuff.
      alacritty
      konsole
      #this is making me want to cry, I can't make an overlay with a new version
      #without a stack overflow for some reason.
      ion
      exa
      git
      ripgrep
      zathura
      ytop # top sucks.

      #Sway stuff. (Should place sway here when sway supports null package)
      waybar
      dolphin
      breeze-icons
      mako # notification daemon.
      grim
      slurp
      wl-clipboard

      fzf # this is required for nvim's coc-fzf. not detected as a dep but /shrug

      #development stuff
      nixfmt
      nodejs
      unstable.deno
      python3
      (latest.rustChannels.stable.rust.override { extensions = ["rust-src"]; })
      texlive.combined.scheme-full
      gdb

      #fonts
      font-awesome
      fira-code
      (nerdfonts.override { fonts = ["FiraCode"]; })

      starship
      #osu - need I say more?
      osu-lazer
    ];

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
