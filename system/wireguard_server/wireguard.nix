{
  config,
  pkgs,
  lib,
  ...
}: let
  server_bindings = [
    {
      name = "fedora";
      pubKey = "5oqbinscH3o9mWBFNYOPdHrMB5NOw1P/AGK4I5exAmY=";
      ip = "10.100.0.2";
    }
    {
      name = "hercules";
      pubKey = "jJkyhgzMtEfEMVRa7XSRn7FuKZKZ6PppT4iuSkX9JzY=";
      ip = "10.100.0.3";
    }
    {
      name = "nas";
      pubKey = "Pt+7dLlAMeTJbkrYmp7ez1KJK6vmwM4sdGPhHHks1xQ=";
      ip = "10.100.0.4";
    }
  ];
in {
  imports = [];
  services.bind = {
    enable = true;
    forwarders = ["192.168.1.1"];
    cacheNetworks = ["10.100.0.0/16" "127.0.0.0/24"];
    zones = {
      "localhost" = {
        master = true;
        file = pkgs.writeText "localhost.zone" ''
          $TTL 1h
          @ORIGIN localhost.
          @  1D     IN  SOA                    @                          root (
                        2022031501 ; Serial
                        8H ; Refresh
                        2H ; Retry
                        4W ; Expiry
                        1D ; Minimum
                        )
          ;@        IN  SOA internal.arvinderd.com. admin.internal.arvinderd.com. (
          ;                21121201       ; Serial
          ;                1H    ; Refresh
          ;                1H    ; Retry
          ;                1W      ; Expire
          ;                3H      ); Negative Cache TTL
          ;
          ; IN       NS   wireguard
          ;wireguard IN A 10.100.0.1
          ;${builtins.concatStringsSep "\n" (builtins.map ({
            name,
            ip,
            ...
          }: "${name} IN A ${ip}")
          server_bindings)}
        '';
      };
      "0.0.127.in-addr.arpa" = {
        master = true;
        file = pkgs.writeText "0.0.127.zone" ''
           $TTL 3D
           @       IN      SOA     localhost. root.localhost. (
                           2013050101      ; Serial
                           8H              ; Refresh
                           2H              ; Retry
                           4W              ; Expire
                           1D              ; Minimum TTL
                           )

          IN      NS      localhost.

          1      IN      PTR     localhost.
        '';
      };
    };
    extraOptions = ''
      auth-nxdomain yes;
      notify no;
      empty-zones-enable no;

      allow-recursion {
        10.100.0.0/16;
        127.0.0.1;
      };

      allow-transfer {
        none;
      };
      minimal-responses yes;
    '';
  };
  networking.nat = {
    enable = true;
    externalInterface = "ens18";
    internalInterfaces = ["wg0"];
  };
  networking.nameservers = ["192.168.1.1" "127.0.0.1" "1.1.1.1"];
  networking.wireguard.interfaces = {
    wg0 = {
      ips = ["10.100.0.1/24"];
      listenPort = 51820;
      privateKeyFile = config.age.secrets."wireguard/private.key".path;
      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/16 -o eth0 -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';
      peers =
        [
          {
            # Windows desktop
            publicKey = "cuPku4mcym5S7KR1/NJMwAFnw7+yUeCq8KmJv52dqEk=";
            # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
            allowedIPs = ["10.100.1.1/32"];
          }
          {
            #NixOS desktop
            publicKey = "CS9YFC+ZMBHt9h/N7p3bpNiOoS0AnZnBXasvogfyIEg=";
            allowedIPs = ["10.100.1.2/32"];
          }
        ]
        ++ (builtins.map ({
            pubKey,
            ip,
            ...
          }: {
            publicKey = pubKey;
            allowedIPs = ["${ip}/32"];
          })
          server_bindings);
    };
  };
  age.secrets."wireguard/private.key".file = ../../secrets/wireguard/private.key;
  networking.firewall.allowedUDPPorts = [51820 389 464 53 88 137 138 139];
  networking.firewall.allowedTCPPorts = [53 88 135 139 389 464];
}
