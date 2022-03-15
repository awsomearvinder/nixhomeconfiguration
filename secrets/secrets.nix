let 
  coding_server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIuYCV7NwqlACA5rp8WH4lerKB8M9Ci3jucyW0hhQLfD"; 
  desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINEsyr9uX4OFH3vsoiIxeW5D9ZEam2tbg/mQRZ6Ov2aL"; 
  hydra = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB7LDZYEGm2aO4AGsiPqrXWpwN4ZulyhC2Ip3CbE2SaR"; 
  nas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID1VIpEZ+5+4Os3WQ5X8g+65uw/X12EMFQJtKq6Jsg4s root@nixos";
in {
  "wireguard/private.key".publicKeys = [coding_server];
  "dyndns/password.priv".publicKeys = [coding_server];
  "wireguard_desktop/private.key".publicKeys = [desktop];
  "hydra/wireguard/private.key".publicKeys = [hydra];
  "hydra/cluster-join-token.key".publicKeys = [hydra];
  "hydra/binary-caches.json".publicKeys = [hydra];
  "nas/wireguard/private.key".publicKeys = [nas];
}
