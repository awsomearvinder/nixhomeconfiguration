self: super: {
  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "01-27-2021";

    src = super.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "fd7e77b2277d884c51bc6f0bd70c0e6e7a307bc1";
      sha256 = "pV2q2ta9oNrK+4G/mbChjl10piystrlCfJNsyDIDdLI=";
    };

    buildInputs = (oldAttrs.buildInputs ++ ([ self.tree-sitter ]));
    cmakeFlags = oldAttrs.cmakeFlags ++ [ "-DUSE_BUNDLED=OFF" ];
  });
}
