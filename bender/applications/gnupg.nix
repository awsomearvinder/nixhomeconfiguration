{pkgs, ...}: {
  home.packages = [
    pkgs.pinentry.qt
  ];
  programs.gpg.enable = true;
  programs.gpg.settings = {
    pinentry-mode = "loopback";
  };
  services.gpg-agent = {
    enable = true;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry.qt}/bin/pinentry

    '';
  };
}
