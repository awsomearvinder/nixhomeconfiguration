self: super: 
let unstable = import<unstable> {};
in
{
  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs(oldAttrs: {
    version = "01-27-2021";

    src = self.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "459a6c845e87662aa9aa0d6a0a68dc8d817a0498";
      sha256 = "0qs05mq70z7hqqmch7siyng4bry1r2fc36iw0pkyzfiy9rv5fvlq";
    };

    buildInputs = (oldAttrs.buildInputs ++ ([ unstable.tree-sitter ]));
    cmakeFlags = oldAttrs.cmakeFlags ++ [
      "-DUSE_BUNDLED=OFF"
    ];
  });
}
