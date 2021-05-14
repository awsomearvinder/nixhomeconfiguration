{ fetchFromGitHub, pkgconfig, openssl, glib, pango, atk, gdk-pixbuf, gtk3, libappindicator, llvmPackages, clang, cairo, ...}:

let unstable = import <unstable> { };

in unstable.rustPlatform.buildRustPackage rec {
  pname = "buzz";
  version = "04-29-21";

  nativeBuildInputs = [
    pkgconfig
    openssl
    glib
    pango
    atk
    gdk-pixbuf
    gtk3
    libappindicator
    llvmPackages.libclang
    clang
  ];
  buildInputs = [
    pkgconfig
    openssl
    glib
    cairo
    pango
    atk
    gdk-pixbuf
    gtk3
    libappindicator
    llvmPackages.libclang
  ];

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = pname;
    rev = "02479643ed1b0325050245dbb3b70411b8cffb7a";
    sha256 = "1spklfv02qlinlail5rmhh1c4926gyrkr2ydd9g6z919rxkl0ywk";
  };

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
  cargoSha256 = "1saj2r337jmy0fzyriyk7xk6q30d0hzl8zdl06f9xbmvdmmjddjy";
}
