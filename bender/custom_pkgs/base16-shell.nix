{
  fetchFromGitHub,
  stdenv,
  bash,
}:
stdenv.mkDerivation rec {
  pname = "base16-shell";
  version = "07-05-2022";

  buildInputs = [
    bash
  ];

  src = fetchFromGitHub {
    owner = "base16-project";
    repo = pname;
    rev = "1af738dbb8fb6dbfd0402502ed47937ef4ebd461";
    sha256 = "ZlZpMvoljpfeTuOfTrF9qEnoGnkpxGjznd54y+deYwA=";
  };

  installPhase = ''
    chmod -R 555 scripts/*
    mkdir -p $out/bin
    cp  scripts/* $out/bin
  '';
}
