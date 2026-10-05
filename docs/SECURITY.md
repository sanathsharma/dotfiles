## Identifying rust security vulnerabilities

```sh
cargo install cargo-audit && cargo audit     # checks Cargo.lock against the RustSec advisory DB
cargo install cargo-deny && cargo deny check # advisories + licenses + banned/duplicate crates
```

## For languages supported by snyk

See https://docs.snyk.io/supported-languages/supported-languages-package-managers-and-frameworks for language support

Run the following from the root of the project.

```sh
snyk test
```
