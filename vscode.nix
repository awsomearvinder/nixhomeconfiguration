{config, pkgs, ...}:
let
  extensions = with pkgs.vscode-extensions; [
    bbenoist.Nix
    #matklad.rust-analyzer
    ms-vscode.cpptools
    vscodevim.vim
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
