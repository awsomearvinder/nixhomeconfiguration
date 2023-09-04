{
  config,
  pkgs,
  ...
}: let
  name = "Arvinder";
  email =
    if config.work_account
    then "arvinder.dhanoa@winona.edu"
    else "ArvinderDhan@gmail.com";
  gpg_key =
    if config.work_account
    then "D938E040245154F8"
    else "687341EC5B73B98BC5E4DC5D4599D30196519D5F";
in {
  home.packages = [
    pkgs.sapling
    pkgs.git-branchless
  ];

  services.ssh-agent = {
    enable = true;
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = { inherit name email; };
    };
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  xdg.configFile."sapling/sapling.conf".source = (pkgs.formats.ini {}).generate "sapling.conf" {
    ui = {
      username = "${name} <${email}>";
      editor = "hx";
    };
    gpg = {
      key = gpg_key;
    };
  };

  programs.git = {
    enable = true;
    userName = name;
    userEmail = email;
    difftastic.enable = true;
    difftastic.background = "dark";
    extraConfig = {
      pull.ff = "only";
      user.signingkey = gpg_key;
      commit.gpgSign = true;
      gpg.program = "${pkgs.gnupg}/bin/gpg";
      rerere.enabled = true;
    };
  };
  programs.lazygit.enable = true;
  programs.lazygit.settings = {
    git = {
      merging = {
        args = "--no-ff";
      };
    };
  };
}
