# Make this an overlay.
{ config, pkgs, ... }:
let
  extensions = with pkgs.vscode-extensions;
    [
      bbenoist.Nix
      #matklad.rust-analyzer
      ms-vscode.cpptools
      vscodevim.vim
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "pretty-formatter";
        publisher = "mblode";
        version = "0.2.2";
        sha256 = "1kdcxdvccf1fhg8lr8zwi5v7l2ja02p1kxq871jgakq2y42fclpy";
      }
      {
        name = "rust-analyzer";
        publisher = "matklad";
        version = "0.2.297";
        sha256 = "0pj29k5pm1p7f987x9rjd0pks552fxvjv72dscxsk84svl132s0f";
      }
      {
        name = "cmake-tools";
        publisher = "ms-vscode";
        version = "1.4.2";
        sha256 = "1azjqd5w14q1h8z6cib4lwyk3h9hl1lzzrnc150inn0c7v195qcl";
      }
      {
        name = "CMake";
        publisher = "twxs";
        version = "0.0.17";
        sha256 = "11hzjd0gxkq37689rrr2aszxng5l9fwpgs9nnglq3zhfa1msyn08";
      }
      {
        name = "nix-env-selector";
        publisher = "arrterian";
        version = "1.0.7";
        sha256 = "0mralimyzhyp4x9q98x3ck64ifbjqdp8cxcami7clvdvkmf8hxhf";
      }
    ];
  vscode =
    pkgs.vscode-with-extensions.override { vscodeExtensions = extensions; };
in { home.packages = [ vscode ]; }
