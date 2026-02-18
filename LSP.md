Install ts server

```sh
npm install -g typescript typescript-language-server @biomejs/biome
```

Install lua server

```sh
brew install lua-language-server
```

Install toml

```sh
brew install taplo
```

Install tailwindcss ls

```sh
npm install -g @tailwindcss/language-server
```

Install emmet lsp for html

```sh
npm i -g @olrtg/emmet-language-server
```

Install vscode servers (e.g, css)

```sh
npm i -g vscode-langservers-extracted
```

Install marksman for markdown support

```sh
brew install marksman
```

Install codebook for spell checking

- Download the tar from latest releases page, https://github.com/blopker/codebook/releases

```sh
tar -C ~/.local/bin -xzf <file-name>.tar.gz
rm <file-name>.tar.gz
```

Rust setup

```sh
rustup component add rust-analyzer
```

CSS variables autocompletion and go-to-definition

`css-variables-language-server` can be installed via `npm`:

```sh
npm i -g css-variables-language-server
```

https://github.com/hrsh7th/vscode-langservers-extracted

`css-languageserver` can be installed via `npm`:

```sh
npm i -g vscode-langservers-extracted
```

https://github.com/antonk52/cssmodules-language-server

Language server for autocompletion and go-to-definition functionality for CSS modules.

You can install cssmodules-language-server via npm:

```sh
npm install -g cssmodules-language-server
```

Shell file formatter (https://github.com/mvdan/sh)

```sh
go install mvdan.cc/sh/v3/cmd/shfmt@latest
```

yaml formatter (https://github.com/google/yamlfmt)

```sh
go install github.com/google/yamlfmt/cmd/yamlfmt@latest
```

Install stylua for lua formatting

```sh
cargo install stylua
```

or

```sh
brew install stylua
```

Install prettierd for fast js like files formatting

```sh
npm install -g @fsouza/prettierd
```

Install svelte lsp

```sh
npm install -g svelte-language-server
```

Install stylelint css formatter lsp

```sh
npm install -g stylelint-lsp
```

Setup language tools on per-project basis for code-actions, diagnostics, go to definition, etc.
See https://github.com/sveltejs/language-tools/tree/master/packages/typescript-plugin#usage

Install Sql formatter
```sh 
npm install -g sql-formatter
```
