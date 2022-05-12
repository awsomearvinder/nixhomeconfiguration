# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  imports = [./hardware-configuration.nix];
  nixpkgs.config.allowUnfree = true;

  #autoupdates
  system.autoUpgrade.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  #networking.wireless.enable = true;

  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  #networking.supplicant.wlp2s0.configFile.path = "/etc/wpa_supplicant.conf";

  # All networking devices should use DHCP
  # Can we get this to be automated?
  #networking.interfaces.enp1s0.useDHCP = true;
  #networking.interfaces.wlp2s0.useDHCP = true;
  ##networking.useDHCP = true;

  ##for rkvm
  #networking.firewall.allowedTCPPorts = [
  #  5000
  #];
  networking.firewall.allowedUDPPorts = [5000];
  services.avahi = {
    enable = true;
    nssmdns = true;
    reflector = true;
  };
  networking.firewall.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "US/Central";

  ############## List of Packages Without much configuration ###############
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    mkpasswd
    gnome3.gnome-tweaks
  ];

  ############### DEFAULT ENVIORNMENT VARIABLES ###############
  environment.variables = {EDITOR = "nvim";};

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.layout = "us";

  #printing
  services.printing.enable = true;
  services.printing.drivers = [pkgs.brlaser];
  #scanning
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.sane-airscan];
  };

  programs.dconf.enable = true;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bender = rec {
    home = "/home/bender";
    description = "Arvinder Dhanoa";
    isNormalUser = true;
    extraGroups = ["wheel" "scanner" "lp"];
    passwordFile = home + "/.secrets/passwordfile";
  };
  users.mutableUsers = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
