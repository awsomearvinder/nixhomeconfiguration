{ config, lib, pkgs, ... } : 
with lib;
{
  imports = [
	./applications/git.nix
    ./applications/vscode.nix
    ./applications/sway.nix
    ./applications/mako.nix
    ./applications/alacritty.nix
  ];


  options = {
    dots = mkOption {
      type = types.path;
    };
    modifier = mkOption {
      type = types.str;
    };
    scripts = mkOption {
      type = types.path;
    };
  };

  config = {
    nixpkgs.config = {
      allowUnfree=true;
    };

    dots = ./dotfiles;
    modifier = "Mod4";
    scripts = /home/bender/.config/scripts;

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    #This is kinda gross, I know.
    programs.neovim = import ./applications/neovim.nix pkgs;

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = builtins.getEnv "USER";
    home.homeDirectory = builtins.getEnv "HOME";

    home.packages = with pkgs; [
      xournalpp
      pulseeffects
      spotify
      discord
      element-desktop
      alacritty
      ion
      git
      firefox-wayland
      sway 
      fzf # this is required for nvim's coc-fzf. not detected as a dep but /shrug
      ytop # top sucks.
      mako #notification daemon.
    ];

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
