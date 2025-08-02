# heroes

Build and run:

```
nix develop .#wasm --command bash -c "make"
nix develop .#default --command bash -c "cabal run heroes-server"
```

Develop:

```
nix develop .#wasm
make build

nix develop .#default
cabal run heroes-server
```

Rebuild and deploy in `public`:

```
build.sh
```

References:

    - https://github.com/dmjio/miso/tree/master/haskell-miso.org
    - https://github.com/haskell-miso/miso-router
    - https://gitlab.com/juliendehos/talk-2019-lillefp-miso/-/tree/master/heroes-1.0

