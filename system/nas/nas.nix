{ config, pkgs, ... }:
{
  services.samba = {
    enable = true;
    securityType = "ADS";
    extraConfig = ''
      workgroup = INTERNAL
      realm = INTERNAL.ARVINDERD.COM
      encrypt passwords = yes
      kerberos method = secrets and keytab
      password server = *
      #idmap config * : backend = tdb
      #idmap config * : range = 10000-9999999
      #idmap config INTERNAL:backend = ad
      #idmap config INTERNAL:schema_mode = rfc2307
      #idmap config INTERNAL:range = 10000-9999999


      [homes]
      read only = no
      browseable = no
      create mask = 0755
      directory mask = 0755
      '';
  };
}
