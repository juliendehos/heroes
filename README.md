# heroes

Simple isomorphic web app using [Miso](https://github.com/dmjio/miso).

![](demo-heroes.gif)

## Build and run:

```
nix develop .#wasm --command bash -c "make"
nix develop .#default --command bash -c "cabal run server"
```

## Build and deploy in a `output` folder:

```
build.sh
```

## References:

    - https://github.com/dmjio/miso/tree/master/haskell-miso.org
    - https://github.com/haskell-miso/miso-router
    - https://gitlab.com/juliendehos/talk-2019-lillefp-miso/-/tree/master/heroes-1.0

