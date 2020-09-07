{config, pkgs, ...}: {
  home.packages = with pkgs; [
    git
  ];
  programs.git = {
    enable = true;
	userName = "awesomearvinder";
	userEmail = "ArvinderDhan@gmail.com";
  };
 }
