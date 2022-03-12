{ fetchFromGitHub, stdenv, bash }:
stdenv.mkDerivation rec {
  pname = "base16-shell";
  version = "11-28-2021";

  buildInputs = [
    bash
  ];

  src = fetchFromGitHub {
    owner = "chriskempson";
    repo = pname;
    rev = "ce8e1e540367ea83cc3e01eec7b2a11783b3f9e1";
    sha256 = "OMhC6paqEOQUnxyb33u0kfKpy8plLSRgp8X8T8w0Q/o=";
  };

  installPhase = ''
  chmod -R 555 scripts/*
  mkdir -p $out/bin
  cp  scripts/* $out/bin
  '';
}
