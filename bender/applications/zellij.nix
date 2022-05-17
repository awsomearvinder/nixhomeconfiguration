{pkgs, ...}: {
  programs.zellij = {
    enable = true;
    settings = {
      default-shell = "${pkgs.ion}/bin/ion";
    };
  };
}
