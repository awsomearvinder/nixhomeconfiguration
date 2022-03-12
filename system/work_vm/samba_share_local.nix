{ ... }: {
  services.samba = {
    enable = true;
    extraConfig = ''
      # 192.168.111 host's my local VM network - nothing off
      # that should get access.
      workgroup = WORKGROUP
      hosts allow = localhost  192.168.111.0/255.255.255.0
      server min protocol = SMB2
      server string = local_file_share
      netbios name = nixos
      use sendfile = yes
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      bender = {
        path = "/mnt/share/bender";
        browseable = "yes";
        "read only" = "no";
        "valid users" = "bender";
        "directory mask" = "0750";
      };
    };
  };
}
