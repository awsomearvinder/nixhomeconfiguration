{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.goldwarden;
in
{
  options = {
    custom.goldwarden = {
      enable = lib.mkOption {
        default = false;
        description = ''
          Whether to setup goldwarden
        '';
      };
    };
  };
  config = {
    home.packages = lib.mkIf cfg.enable [ pkgs.goldwarden ];
    systemd.user.services.goldwarden = lib.mkIf cfg.enable {
      Unit = {
        Description = "Goldwarden Daemon";
        After = "graphical-session.target";
      };
      Service = {
        ExecStart = "${lib.getExe pkgs.goldwarden} daemonize";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
