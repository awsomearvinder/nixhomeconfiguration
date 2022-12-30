{config, pkgs, ...}: {
  environment.systemPackages = [
    pkgs.vault-bin
  ];
  age.secrets.vault_token.file = ../../secrets/desktop/vault/token.age;
  services.nomad = {
    enable = true;
    dropPrivileges = false;
    extraSettingsPaths = [ "${config.age.secrets.vault_token.path}" ];
    settings = {
      ui = {
        enabled = true;
      };
      server = {
        enabled = true;
        bootstrap_expect = "1";
      };
      client = {
        enabled = true;
        host_volume = [{
          nomad = { path = "/nomad"; read_only = false; };
        }];
      };
      plugin = [{docker = {
        config = {allow_privileged = true;};
      };}];
      vault = {
        enabled = true;
        address = "http://127.0.0.1:8200";
        create_from_role = "nomad_cluster";
        allow_unauthenticated = true;
      };
    };
  };
  services.vault = {
    enable = true;
    package = pkgs.vault-bin;
    address = "0.0.0.0:8200";
    storageBackend = "consul";
    extraConfig = ''
      ui = true
    '';
  };
  services.consul = {
    enable = true;
    webUi = true;
    interface.bind = "enp35s0";
    extraConfig = {
      server = true;
      bootstrap_expect = 1;
    };
  };
  services.nfs.server = {
    enable = true;
    # fixed rpc.statd port; for firewall
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
    extraNfsdConfig = '''';
  };
  services.nfs.server.exports = ''
    /nomad         172.17.0.0/16(rw,no_root_squash,insecure)
  '';
}
