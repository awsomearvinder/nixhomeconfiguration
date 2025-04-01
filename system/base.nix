# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
{
  imports = [ ./options.nix ];
  config = {
    nix.settings.trusted-users = [
      "@wheel"
      "root"
    ];
    nix = {
      package = pkgs.nixVersions.latest;
      extraOptions = ''
        experimental-features  = nix-command flakes
        keep-outputs = true
        keep-derivations = true
      '';
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 10d";
      };
    };
    nixpkgs.config.permittedInsecurePackages = [
      "electron-31.7.7" # feishin reeee
    ];
    nixpkgs.config.allowUnfree = true;
    boot.loader.systemd-boot.enable = true;

    networking.hostName = config.machine_name;
    # Set your time zone.
    time.timeZone = "America/Chicago";

    users.users.bender = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    networking.useDHCP = false;

    # List services that you want to enable:
    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
    services.openssh.settings.PermitRootLogin = "yes";
    services.journald.extraConfig = ''
      SystemMaxUse = 1G
    '';

    systemd.oomd = {
      enable = true;
      enableSystemSlice = true;
      enableRootSlice = true;
      enableUserSlices = true;
      extraConfig = {
        DefaultMemoryPressureDurationSec = "5s";
      };
    };
    systemd.extraConfig = ''
      DefaultMemoryAccounting=yes
      DefaultTasksAccounting=yes
    '';
    systemd.slices.user.sliceConfig = {
      ManagedOOMSwap = "kill";
    };

    networking.firewall.allowedTCPPorts = [
      22 # ssh
    ];
  };
}
