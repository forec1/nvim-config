#!/usr/bin/env bash
# Set up this Neovim config on a new machine (Linux or macOS), no sudo needed.
#
#   curl -fsSL https://raw.githubusercontent.com/<you>/nvim-config/main/bootstrap.sh | bash -s -- <repo-url>
#   or, from an existing clone:  ~/.config/nvim/bootstrap.sh
#
# Re-running it is safe: it updates Neovim if needed, pulls the config, and syncs plugins.
set -euo pipefail

REPO_URL="${1:-}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
PREFIX="$HOME/.local"
MIN_NVIM="0.11.0"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mwarning:\033[0m %s\n' "$*"; }

version_ge() { [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -1)" = "$2" ]; }

nvim_version() { nvim --version 2>/dev/null | head -1 | sed -E 's/^NVIM v([0-9.]+).*/\1/'; }

# 1. Neovim ------------------------------------------------------------------
export PATH="$PREFIX/bin:$PATH"
if command -v nvim >/dev/null && version_ge "$(nvim_version)" "$MIN_NVIM"; then
    info "Neovim $(nvim_version) found"
elif [ "$(uname -s)" = "Linux" ]; then
    case "$(uname -m)" in
        x86_64) arch=x86_64 ;;
        aarch64 | arm64) arch=arm64 ;;
        *) echo "Unsupported architecture: $(uname -m)" >&2; exit 1 ;;
    esac
    info "Installing latest Neovim ($arch) into $PREFIX"
    tmp="$(mktemp -d)"
    curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-$arch.tar.gz" \
        | tar -xz -C "$tmp"
    rm -rf "$PREFIX/opt/nvim"
    mkdir -p "$PREFIX/opt" "$PREFIX/bin"
    mv "$tmp/nvim-linux-$arch" "$PREFIX/opt/nvim"
    ln -sf "$PREFIX/opt/nvim/bin/nvim" "$PREFIX/bin/nvim"
    rm -rf "$tmp"
    info "Installed Neovim $(nvim_version)"
else
    echo "Neovim >= $MIN_NVIM is required. On macOS: brew install neovim" >&2
    exit 1
fi

# 2. Config ------------------------------------------------------------------
if [ -d "$CONFIG_DIR/.git" ]; then
    info "Updating config in $CONFIG_DIR"
    git -C "$CONFIG_DIR" pull --ff-only
else
    if [ -z "$REPO_URL" ]; then
        echo "Usage: bootstrap.sh <repo-url>   (no config repo found at $CONFIG_DIR)" >&2
        exit 1
    fi
    if [ -e "$CONFIG_DIR" ]; then
        backup="$CONFIG_DIR.bak.$(date +%Y%m%d-%H%M%S)"
        warn "Moving existing $CONFIG_DIR to $backup"
        mv "$CONFIG_DIR" "$backup"
    fi
    info "Cloning $REPO_URL into $CONFIG_DIR"
    git clone "$REPO_URL" "$CONFIG_DIR"
fi

# 3. Tools the config expects --------------------------------------------------
for tool in git curl unzip tar gcc make rg node npm python3; do
    command -v "$tool" >/dev/null || warn "'$tool' not found; some plugins or Mason packages need it"
done

# 4. Plugins, parsers, language servers ---------------------------------------
# Restore installs the exact plugin versions pinned in lazy-lock.json.
info "Installing plugins (lazy-lock.json versions)"
nvim --headless "+Lazy! restore" +qa
info "Installing Treesitter parsers"
nvim --headless "+lua require('lazy').load({ plugins = { 'nvim-treesitter' } })" "+TSUpdateSync" +qa

if ! grep -qs "$PREFIX/bin" "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile" 2>/dev/null; then
    warn "Add $PREFIX/bin to your PATH, e.g.: echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
fi

info "Done. Start nvim; Mason installs the language servers and debuggers on first launch."
