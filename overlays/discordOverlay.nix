self: super: {
  discord = super.discord.overrideAttrs (_: {
    src = builtins.fetchTarball
      "https://discordapp.com/api/download?platform=linux&format=tar.gz";
  });
}
