{pkgs, ...}: {
  home.packages = [
    pkgs.alejandra
  ];
  programs.helix = {
    enable = true;
    settings = {
      theme = "gruvbox";
    };
    languages = {
      language-server = {
        typst = {
          command = "typst-lsp";
          args = [];
        };
        nil = {
          formatting = {
            command = ["alejandra" "--quiet"];
          };
        };
      };
      language = [
        {
          name = "typst";
          file-types = ["typ"];
          scope = "source.typst";
          roots = [".git"];
        }
        {
          name = "nix";
          auto-format = true;
        }
      ];
    };
  };
}
