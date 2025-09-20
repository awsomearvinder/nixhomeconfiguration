{
  pkgs,
  ...
}:
{
  imports = [

  ];
  home.packages = [
    pkgs.krita
  ];
  home.stateVersion = "25.11";
}
