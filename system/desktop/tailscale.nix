{
  config,
  pkgs,
  ...
}: {
  age.secrets."desktop/tailscale/key".file = ../../secrets/desktop/tailscale/key;
  services.tailscale = {
    enable = true;
    port = 50;
    interfaceName = "lab-tailnet";
    permitCertUid = "bender";
  };
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status=\"$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)\"
      if [ $status = \"Running\" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${pkgs.tailscale}/bin/tailscale up -authkey $(cat ${config.age.secrets."desktop/tailscale/key".path}) --login-server 'https://headscale.arvinderd.com' --hostname=bender-desktop
    '';
  };
}
