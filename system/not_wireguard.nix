{config, pkgs, lib, ...}:
lib.mkIf (config.machine_name != "wireguard") {
  age.secrets."${config.machine_name}/wireguard/private.key".file = ../secrets/${config.machine_name}/wireguard/private.key;

  networking.wireguard.interfaces = {
      wg0 = {
        ips = [ "${config.wireguard_ip_and_mask}" ];
        listenPort = 51820;
        privateKeyFile =
          config.age.secrets."${config.machine_name}/wireguard/private.key".path;
        peers = [{
          publicKey = "OdVMF/vEnyFYAOYU8Rfl+0ubW14TVfZUU5HGUV8sGzY=";
          allowedIPs = [ "10.100.0.0/16" ];
          endpoint = "internal.arvinderd.com:51820";
          persistentKeepalive = 25;
        }];
      };
    };

  networking.nameservers = [
    "10.100.0.1"
    "1.1.1.1"
    "8.8.8.8"
  ];
}
