# Make this an overlay.
{ pkgs, ... }:
let
  extensions = with pkgs.vscode-extensions; [
    ms-vscode.cpptools
    vscodevim.vim
  ];
  vscode = pkgs.vscode-with-extensions.override {
    vscodeExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace (import ./vscode-extensions.nix)
    .extensions;
  };
in
{
  home.packages = [ vscode ];
}
