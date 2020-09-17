{config, pkgs, ...}:
let
  extensions = with pkgs.vscode-extensions; [
    bbenoist.Nix
    #matklad.rust-analyzer
    ms-vscode.cpptools
    vscodevim.vim
  ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name="rust-analyzer";
      publisher="matklad";
      version="0.2.297";
      sha256 = "0pj29k5pm1p7f987x9rjd0pks552fxvjv72dscxsk84svl132s0f";
    }
    {
      name="CMake";
      publisher="twxs";
      version="0.0.17";
      sha256 = "11hzjd0gxkq37689rrr2aszxng5l9fwpgs9nnglq3zhfa1msyn08";
    }
  ];
  vscode = pkgs.vscode-with-extensions.override {
    vscodeExtensions = extensions;
  };
in 
{
  home.packages = [
    vscode
  ];
}
