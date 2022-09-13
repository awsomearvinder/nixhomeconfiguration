{ config, pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Arvinder";
    userEmail = "ArvinderDhan@gmail.com";
    difftastic.enable = true;
    difftastic.background = "dark";
    extraConfig = {
      pull.ff = "only";
      user.signingkey = "687341EC5B73B98BC5E4DC5D4599D30196519D5F";
      commit.gpgSign = true;
      gpg.program = "${pkgs.gnupg}/bin/gpg";
      rerere.enabled = true;
    } // (if config.work_account then { user.signingkey = "D938E040245154F8"; } else {});
  } // (if config.work_account then {
    userEmail = "Arvinder.Dhanoa@winona.edu";
  } else
    { });
}
