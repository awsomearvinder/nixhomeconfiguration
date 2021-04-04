self: super: 
let unstable = import<unstable> {};
in
{
  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs(oldAttrs: {
    version = "01-27-2021";

    src = self.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "0f187700ab1437e949f03d6915df7c76f8287304";
      sha256 = "1k2dc63bpn3c0d1vi04342mp84ihw22qpy8gk3v77j8ag0cnzibm";
    };

    buildInputs = (oldAttrs.buildInputs ++ ([ unstable.tree-sitter ]));
    cmakeFlags = oldAttrs.cmakeFlags ++ [
      "-DUSE_BUNDLED=OFF"
    ];
  });
}
