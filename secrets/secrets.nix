let
  wireguard_server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIuYCV7NwqlACA5rp8WH4lerKB8M9Ci3jucyW0hhQLfD";
  desktop = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDC+2blpnmzg0+8DgQI0yGSpRuY3lMxNQbIWLQ6iLcetWpn9/1xlR8m0KSu7alOh+lJObzDJwapoms+eM+EdWLSQs0244A4Nu+tYEuTSzA/B1/Z21bhF3R1prWQPT16SIgkDGRzNhfZVZoa+NJ83r1r1Em9JJEIS7c4+RfyD3gXKdbOdiDJkZlU1zHXkHacsMUjlMwQ6PPyoIcmOHpGiCH/lv4NQNpnbGyZAtm6DRV/yuox8/FvJIvVGGkMfAk2J6mT77ypVpmsmYWsOZm9r7x/rpQL9iHeQzw+7sFeKuPVjteOTXdEvr0nifFetqkRh3hKzzqHkxXzwK1VSctu5fiDDKQbJtf8AUzmfnCbHg0Xmndu2kkRxNZWwT+wHJzC4QvnPUd0x9of+fgP3+jcRDB03iB8EJPRaplwtjdQrq4JAbPK5qPiP25G6Cq09tpNHxSyovIN9jEORnXwb4oj7Rg6CRDi2DNHesT1yHFSMbBLcM8WMAVhRZgAl1+dSoktyeg2NVeb6RPzE5P7eHjKzUYrdP1PeCUgx8RpFQM3SXhb5/iUP5/aaHN3gs05NRJhhTRbXlC2cy86pe/gncfolW2Fgaud+SYUaZ+8JaUz8SAxJ7HPaDaXlaiYgJXl4uwNgpGy8P0NsNtIlkzfbvWCfCdGH5T+5XUwQGc5uM3tc/uGDQ== root@desktop";
  hercules = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJOGdxM+MWYh+w57KX6Jhby2eK5VEyua65iaxTSCsunv";
  nas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID1VIpEZ+5+4Os3WQ5X8g+65uw/X12EMFQJtKq6Jsg4s root@nixos";
  lighthouse = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINyGyYhz3cXuc1V0GMu0U1vlJnzJfhkmYhLMNMHe6xJq";
in {
  "wireguard/private.key".publicKeys = [wireguard_server];
  "dyndns/password.priv".publicKeys = [wireguard_server];
  "desktop/tailscale/key".publicKeys = [desktop];
  "hercules/wireguard/private.key".publicKeys = [hercules];
  "hercules/cluster-join-token.key".publicKeys = [hercules];
  "hercules/binary-caches.json".publicKeys = [hercules];
  "hercules/pcparadise-cluster-join-token.key".publicKeys = [hercules];
  "nas/wireguard/private.key".publicKeys = [nas];
  "lighthouse/ca.key".publicKeys = [lighthouse];
  "lighthouse/lighthouse.key".publicKeys = [lighthouse];
}
