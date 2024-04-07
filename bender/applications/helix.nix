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
        pyright = {
          command = "pyright-langserver";
          args = ["--stdio"];
        };
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
          name = "python";
          roots = ["pyproject.toml"];
          formatter = {
            command = "black";
            args = ["--quiet" "-"];
          };
          language-servers = ["pylsp" "pyright"];
          auto-format = true;
        }
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
