[
  #import ./neovimOverlay.nix
  #import ./discordOverlay.nix
  (self: super:
    {
      #discord = super.discord.overrideAttrs (_: {
      #  src = builtins.fetchTarball {
      #    src = "https://discordapp.com/api/download?platform=linux&format=tar.gz";
      #}});
    })
  (self: super: {
    neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
      version = "01-27-2021";

      src = self.fetchFromGitHub {
        owner = "neovim";
        repo = "neovim";
        rev = "52ca7f1a26e4da95f3b3b00670252cfdf788a011";
        sha256 = "1970c4yrbfcwa2nnf3wjzaic7n6dplz786ns40sf5saj0nkqp7hj";
      };

      buildInputs = (oldAttrs.buildInputs ++ ([ self.tree-sitter ]));
      cmakeFlags = oldAttrs.cmakeFlags ++ [ "-DUSE_BUNDLED=OFF" ];
    });
  })
]
