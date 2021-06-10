[
  (import ./neovimOverlay.nix)
  (import ./discordOverlay.nix)
  #(self: super:
  #  {
  #    discord = super.discord.overrideAttrs (_: {
  #      src = builtins.fetchTarball {
  #        src = "https://discordapp.com/api/download?platform=linux&format=tar.gz";
  #    }});
  #  })
]
