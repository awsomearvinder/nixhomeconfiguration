{ config, ... }:
let inherit (config) dots;
in {
  xdg.configFile."mako/config".text = builtins.readFile (dots + "/mako.conf");
}
