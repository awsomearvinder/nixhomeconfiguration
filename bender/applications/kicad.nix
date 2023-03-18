{pkgs, ...}: {
  xdg.configFile."kicad/6.0/colors/Gruvbox.json".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/AlexanderBrevig/kicad-gruvbox-theme/main/colors/Gruvbox.json";
    sha256 = "3r66lM03qzgTlItvR99KaA+0XdQnLZgbSa6KiF+kNJw=";
  };
}
