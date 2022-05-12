{config, ...}: let
  inherit (config) dots;
in {
  xdg.configFile."waybar/style.css".text =
    builtins.readFile (dots + "/waybar/style.css");
  xdg.configFile."waybar/config".text =
    builtins.readFile (dots + "/waybar/config");
}
