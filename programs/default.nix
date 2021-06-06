{ config, pkgs, ... }: {
  enviorment = {
    systemPackages = [ sway ];
  }

  #Make available to display manager if exists.
  services.xserver.displayManager.sessionPackages = [ sway ];
}
