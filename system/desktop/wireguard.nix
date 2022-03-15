{ config, pkgs, ... }:
{
  age.secrets."wireguard_desktop/private.key".file = ../../secrets/wireguard_desktop/private.key;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = ["10.100.1.2/24"];
      listenPort = 51820;
      privateKeyFile = config.age.secrets."wireguard_desktop/private.key".path;
      peers = [
        {
          publicKey = "OdVMF/vEnyFYAOYU8Rfl+0ubW14TVfZUU5HGUV8sGzY=";
          allowedIPs = ["10.100.0.0/16" "192.168.0.0/16"];
          endpoint = "internal.arvinderd.com:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
