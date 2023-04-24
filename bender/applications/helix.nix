{pkgs, ...}: {
  home.packages = [
    pkgs.alejandra
  ];
  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox";
    };
    languages = [
      {
        name = "typst";
        file-types = ["typ"];
        scope = "source.typst";
        roots = [".git"];
        language-server = {command = "typst-lsp"; args = []; language-id = "typst"; };
      }
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
