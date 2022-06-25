{pkgs, ...}: {
  home.packages = [
    pkgs.pinentry.qt
  ];
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry.qt}/bin/pinentry

    '';
  };
}
