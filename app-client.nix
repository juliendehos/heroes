{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  name = "app";
  src = ./.;
  dontBuild = true;
  installPhase = ''
    mkdir $out
    cp -r $src/public $out/
  '';
}

