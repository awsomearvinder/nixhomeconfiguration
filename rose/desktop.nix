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
  services.easyeffects = {
    enable = true;
  };
  home.stateVersion = "25.11";
}
