{
  config,
  pkgs,
  ...
}: {
  services.ddclient = {
    enable = true;
    protocol = "namecheap";
    domains = ["internal"];
    passwordFile = config.age.secrets."dyndns/password.priv".path;
    username = "arvinderd.com";
  };
  age.secrets."dyndns/password.priv".file = ../../secrets/dyndns/password.priv;
}
