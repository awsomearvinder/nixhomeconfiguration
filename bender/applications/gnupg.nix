{ ... }:
{
  home.packages = [ ];
  programs.gpg.enable = true;
  programs.gpg.settings = { };
  services.gpg-agent = {
    enable = true;
    # pinentryFlavor = "gnome3";
  };
}
