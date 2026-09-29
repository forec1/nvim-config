# Neovim config

NvChad-based config, shared between my Mac and remote machines.

## New machine

```sh
git clone <repo-url> ~/.config/nvim
~/.config/nvim/bootstrap.sh
```

`bootstrap.sh` installs Neovim into `~/.local` if it's missing or too old (no sudo), installs the plugins
at the versions pinned in `lazy-lock.json`, and builds the Treesitter parsers. Mason installs the language
servers and debuggers the first time you start `nvim`. Run it again any time to update.

## Keeping machines in sync

- Change the config on any machine, commit, and push.
- On the others: `git -C ~/.config/nvim pull`, then `:Lazy restore` in Neovim (or re-run `bootstrap.sh`).
- Updating plugins (`:Lazy sync`) changes `lazy-lock.json`; commit it so every machine gets the same versions.

## Machine-specific settings

Nothing in the repo contains absolute paths. Shared defaults live in `lua/machine.lua`; to override one on a
single machine, copy `lua/local.example.lua` to `lua/local.lua`. That file is gitignored.

## Remote work

Run Neovim on the remote over SSH, ideally inside tmux. Yanks are sent to the local clipboard with OSC 52
(the terminal needs clipboard access enabled; in iTerm2: Settings > General > Selection). Inside tmux, add
this to the remote `~/.tmux.conf`:

```
set -g set-clipboard on
set -as terminal-features ',xterm-256color:clipboard'
```
