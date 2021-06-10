self: super: {
  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "01-27-2021";

    src = super.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "fd7e77b2277d884c51bc6f0bd70c0e6e7a307bc1";
      sha256 = "1wrvvy85x7yqj4rkgpj93cdnhalyhzpr8pmyca38v59lm5ndh2w4";
    };

    buildInputs = (oldAttrs.buildInputs ++ ([ self.tree-sitter ]));
    cmakeFlags = oldAttrs.cmakeFlags ++ [ "-DUSE_BUNDLED=OFF" ];
  });
}
