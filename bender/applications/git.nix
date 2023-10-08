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
  ];

  services.ssh-agent = {
    enable = true;
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {inherit name email;};
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

  custom.version_control = {
    enable_git = true;
    signing = {inherit gpg_key;};
    inherit email name;
  };
}
