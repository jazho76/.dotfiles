# Neovim Modernization Plan

**Goal:** Upgrade this dotfiles Neovim setup to current stable Neovim, current lazy.nvim, current plugin versions, and modern replacements for deprecated plugins while preserving Joaquin's workflow.

**Architecture:** Keep `lazy-lock.json` as the single version freeze point. Plugin specs declare plugin topology and behavior, not exact commits. Validate in disposable XDG state first, then perform one live clean reinstall for the real `jazho` account.

**Tech Stack:** Neovim 0.12.2, lazy.nvim, Mason, nvim-lspconfig, nvim-cmp, Treesitter, DAP, Copilot, Telescope.

---

## Task 1: Baseline and repository hygiene

**Objective:** Establish the starting point and make sure the branch is clean before migration.

**Files:**
- Read: `README.md`
- Read: `nvim/.config/nvim/init.lua`
- Read: `nvim/.config/nvim/lua/plugins/*.lua`
- Read: `nvim/.config/nvim/lazy-lock.json`

**Steps:**
1. Verify branch: `git status --short --branch`.
2. Record installed Neovim: `nvim --version`.
3. Record latest upstream Neovim release from GitHub.
4. Scan for deprecated patterns: `neodev`, `Neoformat`, `vim.loop`, `setup_handlers`, stale plugin tags.
5. Commit this plan before functional edits.

**Verification:** Branch is clean except this plan, current Neovim and latest Neovim are known, and deprecated targets are listed.

## Task 2: Update Neovim installation documentation

**Objective:** Move install docs from 0.10.2/linux64 naming to current 0.12.2/x86_64 release naming.

**Files:**
- Modify: `README.md`

**Steps:**
1. Update `VERSION=0.12.2`.
2. Update tarball URL to `nvim-linux-x86_64.tar.gz`.
3. Update extracted directory from `nvim-linux64` to `nvim-linux-x86_64`.
4. Keep GNU Stow workflow unchanged.

**Verification:** Commands point at the current release artifact and match GitHub release asset names.

## Task 3: Modernize lazy bootstrap

**Objective:** Let lazy.nvim install and update from its stable branch while the lockfile records the resolved version.

**Files:**
- Modify: `nvim/.config/nvim/init.lua`

**Steps:**
1. Replace `vim.loop` with `vim.uv` fallback.
2. Remove the stale post-clone checkout of old lazy.nvim commit.
3. Keep lazy.nvim itself in the spec so it appears in `lazy-lock.json`.
4. Keep `lazy-lock.json` as source of exact plugin versions.

**Verification:** Fresh bootstrap installs lazy.nvim without checking out an old commit.

## Task 4: Replace deprecated Lua development plugin

**Objective:** Replace archived `folke/neodev.nvim` with `folke/lazydev.nvim`.

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/nvim-lspconfig.lua`

**Steps:**
1. Remove `folke/neodev.nvim` dependency.
2. Add `folke/lazydev.nvim` for Lua files with `opts = { library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } } }`.
3. Remove `require('neodev').setup()` from LSP setup.
4. Keep Lua LSP settings for workspace and diagnostics.

**Verification:** `lazy-lock.json` contains `lazydev.nvim`, not `neodev.nvim`, after sync.

## Task 5: Replace Neoformat with conform.nvim

**Objective:** Replace deprecated Neoformat formatting flow with conform.nvim while preserving format-on-save toggle and filetype coverage.

**Files:**
- Replace: `nvim/.config/nvim/lua/plugins/neoformat.lua` with `nvim/.config/nvim/lua/plugins/conform.lua`
- Modify: `nvim/.config/nvim/lua/config/format-autocmds.lua`
- Modify: `nvim/.config/nvim/lua/plugins/nvim-lspconfig.lua`

**Steps:**
1. Remove Neoformat plugin spec.
2. Add `stevearc/conform.nvim` with formatters by filetype:
   - python: `isort`, `black`
   - javascript/typescript/jsx/tsx/css/scss/html/json/yaml/markdown/graphql: `prettier`
   - go: `gofmt`
3. Preserve `<Leader>tf` toggle.
4. Replace `Neoformat` autocmds with a Lua `BufWritePre` autocmd calling `conform.format` when enabled.
5. Keep Mason tool installation for `prettier`, `black`, and `isort`.

**Verification:** No `Neoformat` or `neoformat` references remain, and format autocmd loads without startup errors.

## Task 6: Modernize Mason and LSP setup

**Objective:** Replace deprecated `mason-lspconfig.setup_handlers` usage with current explicit setup logic compatible with current releases.

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/nvim-lspconfig.lua`

**Steps:**
1. Remove `tag = 'v1.0.0'` from `nvim-lspconfig` so latest release is used.
2. Keep `mason.nvim`, `mason-lspconfig.nvim`, and `mason-tool-installer.nvim`.
3. Use `mason_lspconfig.setup({ ensure_installed = ..., automatic_enable = false })`.
4. Iterate server table and call `require('lspconfig')[server_name].setup(...)` explicitly.
5. Remove invalid Mason package key `eslint@4.8.0`; use `eslint = {}` for lspconfig and install current `eslint-lsp` through Mason if available.
6. Keep custom capabilities and mappings.

**Verification:** Startup no longer calls `setup_handlers`, Mason installs servers, and lspconfig setup does not fail.

## Task 7: Remove stale plugin tags and update all plugins

**Objective:** Move all plugins to latest compatible versions and update `lazy-lock.json`.

**Files:**
- Modify: plugin specs under `nvim/.config/nvim/lua/plugins/`
- Modify: `nvim/.config/nvim/lazy-lock.json`

**Steps:**
1. Remove stale `tag = ...` pins from plugin specs unless the tag is required for compatibility.
2. Run Lazy sync/update in disposable XDG directories.
3. Copy the resulting `lazy-lock.json` back to the repo.
4. Keep plugins that are still maintained and not deprecated.

**Verification:** `lazy-lock.json` reflects latest resolved plugin commits, and no manual commit pins exist in Lua specs.

## Task 8: Install latest Neovim and perform clean live validation

**Objective:** Validate from a blank Neovim runtime as Joaquin would experience it.

**Files:**
- Runtime paths only, not committed:
  - `/home/jazho/.local/nvim`
  - `/home/jazho/.local/share/nvim`
  - `/home/jazho/.local/state/nvim`
  - `/home/jazho/.cache/nvim`

**Steps:**
1. Download Neovim 0.12.2 x86_64 tarball.
2. Replace `/home/jazho/.local/nvim` with the extracted release.
3. Ensure `/usr/local/bin/nvim` or the active `nvim` path points at 0.12.2.
4. Remove Neovim data/state/cache for `jazho`.
5. Run `Lazy! sync` as a clean install using the actual config.
6. Run headless startup and health checks.
7. Capture logs for the migration report.

**Verification:** `nvim --version` reports 0.12.2, clean Lazy sync exits 0, startup exits 0, and no blocking errors remain.

## Task 9: Migration report

**Objective:** Commit an audit trail of what changed, what was validated, and any residual risks.

**Files:**
- Create: `docs/nvim-modernization-report.md`

**Steps:**
1. Document Neovim version change.
2. Document plugin replacements.
3. Document major API migrations.
4. Include validation commands and outcomes.
5. List non-blocking warnings or manual follow-ups, if any.

**Verification:** Report is readable from the repo and matches actual validation output.

## Task 10: Commit and push coherent chunks

**Objective:** Make the remote branch useful for review.

**Files:**
- All changed files.

**Steps:**
1. Commit plan.
2. Commit Neovim install docs update.
3. Commit plugin/config modernization.
4. Commit lockfile refresh.
5. Commit migration report.
6. Push `joaquin/nvim-maintenance`.

**Verification:** Remote branch contains all commits and working tree is clean.

## Unresolved questions

None. Default choices are clear: use latest stable Neovim, preserve current workflow semantics, replace only deprecated pieces, and report any residual warnings instead of hiding them.
