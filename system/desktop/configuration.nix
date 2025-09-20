# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../base.nix
  ];

  machine_name = "desktop";

  virtualisation.podman.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu.ovmf.enable = true;
    qemu.ovmf.packages = [ pkgs.OVMFFull ];
    qemu.swtpm.enable = true;
  };

  home-manager.users.bender = import ../../bender/desktop.nix;
  home-manager.useGlobalPkgs = true;
  home-manager.users.rose = import ../../rose/desktop.nix;
  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages =
    let
      drm-tip-kernel-pkg =
        { fetchFromGitLab, buildLinux, ... }@args:
        buildLinux (
          args
          // {
            version = "6.18.0-rc+drm-tip";
            modDirVersion = "6.17.0-rc7";
            src = pkgs.fetchFromGitLab {
              owner = "drm";
              domain = "gitlab.freedesktop.org";
              repo = "tip";
              rev = "547682ff49fc0459e80b1dca71dcbfec7082b43b";
              hash = "sha256-Wxw2YZleXRD4WACPXdto/iaQ+0/4dstA0JYf8DiRTWo=";
            };
          }
          // (args.argsOverride or { })
        );
      drm-tip = pkgs.callPackage drm-tip-kernel-pkg { };

    in
    pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor drm-tip);

  # Enable the COSMIC login manager
  services.xserver.displayManager.gdm.enable = true;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;

  networking.firewall.allowPing = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  # networking.interfaces.enp0s3.useDHCP = true;
  networking.interfaces.enp35s0.useDHCP = true;

  services.flatpak.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "";
    keyMap = "us";
  };

  fonts = {
    packages = with pkgs; [
      liberation_ttf
      # normal fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji

      # nerd-fonts
      nerd-fonts.fira-code
    ];

    # use fonts specified by user rather than default ones
    enableDefaultPackages = false;

    fontconfig.defaultFonts = {
      serif = [
        "Noto Serif"
        "Noto Color Emoji"
      ];
      sansSerif = [
        "Noto Sans"
        "Noto Color Emoji"
      ];
      monospace = [ "FiraCode" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    vpl-gpu-rt
    intel-media-driver
  ];

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  xdg = {
    portal = {
      config.common.default = "*";
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };

  # rtkit is optional but recommended
  security.rtkit.enable = true;
  programs.dconf.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  services.dbus.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bender = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "libvirtd"
    ]; # Enable ‘sudo’ for the user.
  };

  users.users.rose = {
    isNormalUser = true;
    extraGroups = [
      "video"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bubblewrap
    wget
    neovim
    helix
    git
    wireguard-tools
    podman
    distrobox
    pinentry-curses
    gamescope
  ];

  programs.virt-manager.enable = true;
  security.sudo-rs.enable = true;

  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;

  environment.variables.EDITOR = "hx";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # mariadb for school
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  security.polkit.enable = true;

  services.printing.enable = true;

  programs.steam = {
    enable = true;
  };

  programs.anime-game-launcher.enable = true;
  programs.anime-games-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
  
  hardware.bluetooth.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
