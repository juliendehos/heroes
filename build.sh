#! /bin/sh

make clean

nix develop .#wasm --command bash -c "make"

nix develop .#default --command bash -c "cabal build heroes-server"

cp `cabal list-bin heroes-server` public/

