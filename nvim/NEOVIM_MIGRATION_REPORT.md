# Neovim migration report

Generated: 2026-05-23T23:40:49+00:00
Branch: `joaquin/nvim-maintenance`
Repo: `/home/jazho/.dotfiles`

## Scope

Modernized the Neovim config for current stable Neovim and refreshed the lazy.nvim lockfile. Work was performed directly on the authorized maintenance branch.

## Runtime staged

- Installed Neovim `0.12.2` under `/home/jazho/.local/nvim`.
- Added `/home/jazho/.local/bin/nvim` wrapper pointing at the staged runtime.
- Installed host prerequisites needed by the refreshed config:
  - `nodejs`, `npm`
  - `tree-sitter-cli`
  - `rust`, `cargo`

## Config changes

- Migrated Lua LSP helper support from archived `folke/neodev.nvim` to `folke/lazydev.nvim`.
- Updated LSP setup for newer Neovim/mason-lspconfig APIs:
  - `vim.lsp.config()` / `vim.lsp.enable()`
  - `ts_ls` instead of deprecated `tsserver`
  - explicit `automatic_enable = false`
  - global `vim.o.winborder = 'rounded'`
- Replaced Neoformat with `stevearc/conform.nvim` while preserving the format-on-save toggle behavior.
- Migrated nvim-treesitter to the current main-branch API:
  - parser install through `require('nvim-treesitter').install(...):wait(...)` during Lazy build
  - native `vim.treesitter.start()` activation by filetype
  - explicit textobjects mappings via the textobjects modules
- Reworked JavaScript debugging:
  - removed `mxsdev/nvim-dap-vscode-js`
  - use `microsoft/vscode-js-debug` DAP release asset `v1.117.0`
  - configure `nvim-dap` server adapters directly for `pwa-node`, `pwa-chrome`, `pwa-msedge`, and `node-terminal`
- Refreshed `lazy-lock.json` after plugin updates.

## Validation performed

Final validation log directory: `/tmp/ghost-nvim-final-validation`

Commands completed from a clean Neovim state after deleting:

- `/home/jazho/.local/share/nvim`
- `/home/jazho/.local/state/nvim`
- `/home/jazho/.cache/nvim`

Validation results:

- `nvim --headless '+Lazy! sync' '+qa'`: exit 0
- `nvim --headless '+MasonToolsInstallSync' '+qa'`: completed
- `nvim --headless '+MasonInstall ...' '+qa'`: completed
- `nvim --headless '+checkhealth' '+qa'`: exit 0, health summary showed 0 ERROR and 0 WARNING lines
- Headless startup smoke opening a Lua buffer: exit 0 with empty stderr/stdout
- `vscode-js-debug` DAP server smoke: printed `Debug server listening at 127.0.0.1:<port>`
- Configured Mason packages present: 15/15

## Residual risks and notes

- Lazy logs a non-fatal `lsp_signature.nvim` checkout warning about generated `doc/tags` during clean sync. Lazy exits 0 and the plugin ends at the locked commit. This looks like generated helptags colliding with Lazy's checkout order, not a runtime failure.
- `gopls` currently requires Go `>= 1.26`; validation used `GOTOOLCHAIN=auto` so Go downloaded a compatible toolchain. If Joaquin's shell forces `GOTOOLCHAIN=local`, `gopls` updates may fail until system Go catches up.
- `asm-lsp` is installed from crates.io and requires `cargo`. Cargo was installed as a host prerequisite.
- JavaScript DAP now uses the prebuilt upstream DAP tarball instead of building `vsDebugServerBundle`; this avoids the current upstream build failure around unresolved `vscode` imports.
