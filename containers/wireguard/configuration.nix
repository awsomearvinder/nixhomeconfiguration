({ pkgs, flake, ... }: {
  boot.isContainer = true;

  # Let 'nixos-version --json' know about the Git revision
  # of this flake.
  system.configurationRevision = pkgs.lib.mkIf (flake ? rev) flake.rev;

  environment.systemPackages = with pkgs; [
    wireguard
  ];

  # Network configuration.
  networking.useDHCP = false;
  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.nat.enable = true;
  networking.nat.externalInterface = "wlan0";
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.0.0.1/24" ];
      listenPort = 51820;
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';
      privateKeyFile = ".private";
      peers = [{
        publicKey = "mkH6f0LZM8oiMw6bRVkzhcw/OibwtENkR0WnQZYz1nQ=";
        allowedIPs = [ "10.1.0.0/32" ];
      }];
    };
  };
})
