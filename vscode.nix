{config, pkgs, ...}:
let
  extensions = with pkgs.vscode-extensions; [
    bbenoist.Nix
    #matklad.rust-analyzer
    ms-vscode.cpptools
    vscodevim.vim
  ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
    name="rust-analyzer";
    publisher="matklad";
    version="0.2.297";
    sha256 = "0pj29k5pm1p7f987x9rjd0pks552fxvjv72dscxsk84svl132s0f";
  }];
  vscode = pkgs.vscode-with-extensions.override {
    vscodeExtensions = extensions;
  };
in 
{
  home.packages = [
    vscode
  ];
}
