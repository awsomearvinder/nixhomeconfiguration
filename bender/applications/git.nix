{ config, pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Arvinder";
    userEmail = "ArvinderDhan@gmail.com";
    extraConfig = {
      pull.ff = "only";
      user.signingkey = "687341EC5B73B98BC5E4DC5D4599D30196519D5F";
      commit.gpgSign = true;
      gpg.program = "${pkgs.gnupg}/bin/gpg";
    };
  };
}
