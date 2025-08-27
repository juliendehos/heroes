 
let

  miso-src = fetchTarball {
    url = https://github.com/dmjio/miso/archive/fe0dd4797c5bc9e695c90072539198488af2d8c2.tar.gz;
    sha256 = "sha256:07b24nx0xwxskas7agnbbdhahnbk14qzxx6ngc74d4gf630s6535";
    # should match cabal.project
  };

  servant-miso-html-src = fetchTarball {
    url = https://github.com/haskell-miso/servant-miso-html/archive/7fe3339ce17fc463e1467647ee1da0d87cb5eb55.tar.gz;
    sha256 = "sha256:08y82n72zq8wa98s4gij54r87ab8zwdr4sb2hhrghq3sc7vxiqb3";
    # should match cabal.project
  };

  config = {
    packageOverrides = pkgs: rec {
      haskellPackages = pkgs.haskellPackages.override {
        overrides = self: super: rec {
          miso = self.callCabal2nixWithOptions "miso" miso-src "-ftemplate-haskell" {};
          servant-miso-html = self.callCabal2nix "servant-miso-html" servant-miso-html-src {};
        };
      };
    };
  };

  channel = <nixpkgs>;
  # channel = fetchTarball "https://github.com/NixOS/nixpkgs/archive/25.05.tar.gz";

  pkgs = import channel { inherit config; };

in pkgs

