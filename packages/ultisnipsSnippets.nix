{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "ultisnipsSnippets";
  src = ../ultisnips;
  installPhase = ''
    mkdir -p $out/
    cp ./*.snippets $out/
  '';
}
