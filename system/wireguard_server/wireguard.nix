{ config, pkgs, lib, ... }:
let server_bindings = [
  {name = "fedora"; pubKey = "5oqbinscH3o9mWBFNYOPdHrMB5NOw1P/AGK4I5exAmY="; ip  = "10.100.0.2";}
  {name = "hydra"; pubKey = "Ez7hVOSfXK29n7D2LT27XQj3xEA26hlyn7OiHjMxqHU="; ip  = "10.100.0.3";}
];
in {
  services.bind = {
    enable = true;
    forwarders = ["192.168.1.1"];
    cacheNetworks = ["10.100.0.0/16" "127.0.0.0/24"];
      zones = {
      "internal.arvinderd.com" = {
        master = true;
        file = pkgs.writeText "server-zone-conf" ''
              $TTL 1h
              @        IN  SOA internal.arvinderd.com. admin.internal.arvinderd.com. (
                              21121201       ; Serial
                              1H    ; Refresh
                              1H    ; Retry
                              1W      ; Expire
                              3H      ); Negative Cache TTL 
                              
               IN       NS   wireguard
              wireguard IN A 10.100.0.1
              ${builtins.concatStringsSep "\n" (builtins.map ({name, ip, ...}: "${name} IN A ${ip}" ) server_bindings)}

              ;fedora   IN A 10.100.0.2
        '';
      };
    };
  };
  networking.nat = {
    enable = true;
    externalInterface = "ens18";
    internalInterfaces = ["wg0"];
  };
  networking.nameservers = ["192.168.1.1" "127.0.0.1"];
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
      peers = [
        { # Windows desktop
          publicKey = "cuPku4mcym5S7KR1/NJMwAFnw7+yUeCq8KmJv52dqEk=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = [ "10.100.1.1/32" ];
        }
        { #NixOS desktop
          publicKey = "CS9YFC+ZMBHt9h/N7p3bpNiOoS0AnZnBXasvogfyIEg=";
          allowedIPs = [ "10.100.1.2/32" ];
        }
      ] ++ (builtins.map ({pubKey, ip, ...}: {publicKey = pubKey; allowedIPs = ["${ip}/32"];}) server_bindings);
    };
  };
  age.secrets."wireguard/private.key".file = ../../secrets/wireguard/private.key;
  networking.firewall.allowedUDPPorts = [ 51820 ];
}
