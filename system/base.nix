# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:
let
  caFile = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/awsomearvinder/lab/refs/heads/master/secrets/intermediate_ca.crt";
    hash = "sha256-FtGqVUTekpNOb2h+YmG98HZjE/wRxXP6/53QGOG5ulE=";
  };
in
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
      "electron-39.8.10"
    ];
    nixpkgs.config.allowUnfree = true;
    boot.loader.systemd-boot.enable = true;

    security.pki.certificateFiles = [
      "${caFile}"
    ];

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

    services.resolved.enable = true;

    systemd.oomd = {
      enable = true;
      enableSystemSlice = true;
      enableRootSlice = true;
      enableUserSlices = true;
      settings.OOM = {
        DefaultMemoryPressureDurationSec = "5s";
      };
    };
    systemd.settings.Manager = {
      DefaultMemoryAccounting = "yes";
      DefaultTasksAccounting = "yes";
    };
    systemd.slices.user.sliceConfig = {
      ManagedOOMSwap = "kill";
    };

    networking.firewall.allowedTCPPorts = [
      22 # ssh
    ];
  };
}
