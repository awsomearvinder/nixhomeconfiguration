{pkgs, ...}: {
  home.packages = [
    pkgs.pinentry.curses
  ];
  programs.gpg.enable = true;
  programs.gpg.settings = {
    pinentry-mode = "loopback";
  };
  services.gpg-agent = {
    enable = true;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry.curses}/bin/pinentry

    '';
  };
}
