#! /bin/sh

echo ""
echo ""###############################################################################
echo "# clean previous build"
echo ""###############################################################################
make clean

echo ""
echo ""###############################################################################
echo "# build and deploy client"
echo ""###############################################################################
nix develop .#wasm --command bash -c "make"

echo ""
echo ""###############################################################################
echo "# build and deploy server"
echo ""###############################################################################
nix develop .#default --command bash -c "cabal build server" 
myserver=$(nix develop .#default --command bash -c "cabal list-bin server")
cp $myserver public/

