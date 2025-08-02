
.PHONY= update build optim

all: update build optim

update:
	wasm32-wasi-cabal update

build:
	wasm32-wasi-cabal build app
	rm -rf public
	mkdir public
	cp -r static public/static
	$(eval my_wasm=$(shell wasm32-wasi-cabal list-bin app | tail -n 1))
	$(shell wasm32-wasi-ghc --print-libdir)/post-link.mjs --input $(my_wasm) --output public/static/ghc_wasm_jsffi.js
	cp -v $(my_wasm) public/static/

optim:
	wasm-opt -all -O2 public/static/app.wasm -o public/static/app.wasm
	wasm-tools strip -o public/static/app.wasm public/static/app.wasm

clean:
	rm -rf dist-newstyle public

