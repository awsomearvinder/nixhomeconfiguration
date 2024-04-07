{ ... }:
{
  services.ssh-agent = {
    enable = true;
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
