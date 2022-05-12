let 
  wireguard_server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIuYCV7NwqlACA5rp8WH4lerKB8M9Ci3jucyW0hhQLfD"; 
  desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINEsyr9uX4OFH3vsoiIxeW5D9ZEam2tbg/mQRZ6Ov2aL"; 
  hydra = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJOGdxM+MWYh+w57KX6Jhby2eK5VEyua65iaxTSCsunv"; 
  nas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID1VIpEZ+5+4Os3WQ5X8g+65uw/X12EMFQJtKq6Jsg4s root@nixos";
in {
  "wireguard/private.key".publicKeys = [wireguard_server];
  "dyndns/password.priv".publicKeys = [wireguard_server];
  "desktop/wireguard/private.key".publicKeys = [desktop];
  "hydra/wireguard/private.key".publicKeys = [hydra];
  "hydra/cluster-join-token.key".publicKeys = [hydra];
  "hydra/binary-caches.json".publicKeys = [hydra];
  "hydra/pcparadise-cluster-join-token.key".publicKeys = [hydra];
  "nas/wireguard/private.key".publicKeys = [nas];
}
