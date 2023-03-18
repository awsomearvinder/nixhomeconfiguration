{pkgs, ...}: {
  home.packages = [
    pkgs.alejandra
  ];
  programs.helix = {
    enable = true;
    languages = [
      {
        name = "nix";
        auto-format = true;
        config = {
          nil = {
            formatting = {
              command = ["alejandra" "--quiet"];
            };
          };
        };
      }
    ];
  };
}
