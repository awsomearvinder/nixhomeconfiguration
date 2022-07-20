{ config, ... }: let
  inherit (config) dots;
in {
  xdg.configFile."elvish".source = ''${dots}/elvish'';
}
