(self: super: {
  discord = super.discord.overrideAttrs (_: {
    src = builtins.fetchTarball {
      url = "https://discordapp.com/api/download?platform=linux&format=tar.gz";
      sha256 = "1ahj4bhdfd58jcqh54qcgafljqxl1747fqqwxhknqlasa83li75n";
    };
  });  
})
