{
  pkgs,
  ...
}:
{
  imports = [

  ];
  home.packages = [
    pkgs.krita
    pkgs.firefox
  ];
  home.stateVersion = "25.11";
}
