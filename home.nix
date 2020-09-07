{ config, pkgs, ... } : {
  imports = [
    ./firefox.nix
    ./alacritty.nix
    ./discord.nix
	./git.nix
    ./vscode.nix
  ];

  programs.neovim = import ./neovim.nix pkgs;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";

  home.packages = with pkgs; [
    fzf #this is required for nvim. not detected as a dep but /shrug
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
}
