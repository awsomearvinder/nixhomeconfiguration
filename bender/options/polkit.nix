{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.polkit;
in
{
  options.custom.polkit = {
    enable = lib.mkOption {
      default = false;
      description = ''
        Whether to enable polkit
      '';
    };
  };

  config = {
    home.packages = lib.mkIf cfg.enable [ pkgs.polkit_gnome ];
    systemd.user.services.polkit-gnome-authentication-agent-1 = lib.mkIf cfg.enable {
      Unit = {
        Description = "polkit-gnome-authentication-agent-1";
        After = [ "graphical-session.target" ];
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
