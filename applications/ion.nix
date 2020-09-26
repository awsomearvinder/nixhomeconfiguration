{ config, ... }:
let inherit (config) dots;
in {
  xdg.configFile."ion/initrc".text = builtins.readFile (dots + "/init.ion");
}
