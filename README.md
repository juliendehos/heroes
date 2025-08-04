# heroes

Simple isomorphic web app using [Miso](https://github.com/dmjio/miso).

![](demo-heroes.gif)

## Build and run:

```
nix develop .#wasm --experimental-features "nix-command flakes" --command bash -c "make"
nix develop .#default --experimental-features "nix-command flakes" --command bash -c "cabal build server"
```

## Build and deploy in a `output` folder:

```
build.sh
```

## References:

    - [https://github.com/haskell-miso/haskell-miso.org](https://github.com/haskell-miso/haskell-miso.org)
    - [https://gitlab.com/juliendehos/talk-2019-lillefp-miso/-/tree/master/heroes-1.0](https://gitlab.com/juliendehos/talk-2019-lillefp-miso/-/tree/master/heroes-1.0)

