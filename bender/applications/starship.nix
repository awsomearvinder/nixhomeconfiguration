{ config, ... }:
let inherit (config) dots;
in {
  xdg.configFile."starship.toml".text =
    builtins.readFile (dots + "/starship.toml");
}
