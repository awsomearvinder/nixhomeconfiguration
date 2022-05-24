let
  wireguard_server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIuYCV7NwqlACA5rp8WH4lerKB8M9Ci3jucyW0hhQLfD";
  desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINEsyr9uX4OFH3vsoiIxeW5D9ZEam2tbg/mQRZ6Ov2aL";
  hercules = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJOGdxM+MWYh+w57KX6Jhby2eK5VEyua65iaxTSCsunv";
  nas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID1VIpEZ+5+4Os3WQ5X8g+65uw/X12EMFQJtKq6Jsg4s root@nixos";
  lighthouse = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINyGyYhz3cXuc1V0GMu0U1vlJnzJfhkmYhLMNMHe6xJq";
in {
  "wireguard/private.key".publicKeys = [wireguard_server];
  "dyndns/password.priv".publicKeys = [wireguard_server];
  "desktop/wireguard/private.key".publicKeys = [desktop];
  "desktop/nebula/desktop.key".publicKeys = [desktop];
  "hercules/wireguard/private.key".publicKeys = [hercules];
  "hercules/cluster-join-token.key".publicKeys = [hercules];
  "hercules/binary-caches.json".publicKeys = [hercules];
  "hercules/pcparadise-cluster-join-token.key".publicKeys = [hercules];
  "nas/wireguard/private.key".publicKeys = [nas];
  "lighthouse/ca.key".publicKeys = [lighthouse];
  "lighthouse/lighthouse.key".publicKeys = [lighthouse];
}
