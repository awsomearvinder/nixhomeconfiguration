# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../base.nix
  ];

  machine_name = "desktop";
  wireguard_ip_and_mask = "10.100.1.2/16";

  virtualisation.podman.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu.ovmf.enable = true;
    qemu.ovmf.packages = [pkgs.OVMFFull];
    qemu.swtpm.enable = true;
  };

  age.secrets."desktop/nebula/desktop.key".file = ../../secrets/desktop/nebula/desktop.key;
  services.nebula.networks.main = {
    enable = true;
    key = config.age.secrets."desktop/nebula/desktop.key".path;
    cert = pkgs.writeTextFile 
      {name = "desktop.crt"; text = (builtins.readFile ../../public/desktop/desktop.crt);};
    ca = pkgs.writeTextFile 
      {name = "lighthouse_ca.crt"; text = (builtins.readFile ../../public/lighthouse/ca.crt);};
    staticHostMap = {
      "192.168.100.1" = [
        "152.67.248.214:4242"
      ];
    };
    lighthouses = [
      "192.168.100.1"
    ];
    firewall = {
      inbound = [{
        port = "any";
        proto = "any";
        host = "any";
      }];
      outbound = [{
        port = "any";
        proto = "any";
        host = "any";
      }];
    };
  };

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.loader.systemd-boot.enable = true;

  networking.firewall.allowPing = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.nameservers = ["10.100.0.1" "1.1.1.1" "8.8.8.8"];

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  # networking.interfaces.enp0s3.useDHCP = true;
  networking.interfaces.enp35s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };
  fonts.fontconfig.defaultFonts = {
    serif = [
      "Dajavu Serif"
    ];
    monospace = [
      "FiraCode"
    ];
  };

  # services.xserver.videoDrivers = ["nvidia"];
  hardware.opengl.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.foldingathome.enable = true;

  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
      ];
    };
  };

  # Enable sound.
  hardware.pulseaudio.enable = false;
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  programs.dconf.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bender = {
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd"]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    neovim
    git
    linuxPackages.v4l2loopback
    wireguard-tools
    fahviewer
    fahcontrol
    podman
    virt-manager
    distrobox
    pinentry-curses
  ];

  hardware.opentabletdriver.enable = true;
  hardware.opentabletdriver.daemon.enable = true;

  environment.variables.EDITOR = "nvim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  # some development thing I made on the spot.
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_10;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all ::1/128 trust
      host all all 127.0.0.1/32 trust
    '';
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  system.stateVersion = "20.09"; # Did you read the comment?
}
