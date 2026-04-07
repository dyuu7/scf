#!/bin/bash
set -euo pipefail

# === Zsh + Tmux environment setup ===
#
# 联网环境：直接运行 bash install.sh
# 内网部署：先在联网机器运行此脚本，然后打包：
#   cd ~ && tar czf dotfiles.tar.gz .zshrc .zsh_plugins.txt .zsh_plugins.zsh .secrets .tmux.conf .antidote/ .cache/antidote/
# 拷贝到内网机器解压至 $HOME 即可，无需再次运行此脚本。
# uv、fnm 需通过内部镜像或手动安装。

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# --- symlink config files ---
link() {
  local src="$SCRIPT_DIR/$1" dst="$HOME/$1"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    return
  fi
  rm -f "$dst"
  ln -s "$src" "$dst"
  echo "  linked $1"
}

echo "=== Linking config files ==="
link .zshrc
link .zsh_plugins.txt
link .tmux.conf

# --- antidote + plugins ---
ANTIDOTE_DIR="$HOME/.antidote"
if [[ ! -d "$ANTIDOTE_DIR" ]]; then
  echo "Cloning antidote..."
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
fi

echo "Generating static plugin file..."
zsh -c 'source "${ZDOTDIR:-$HOME}/.antidote/antidote.zsh"; antidote bundle <"${ZDOTDIR:-$HOME}/.zsh_plugins.txt" >"${ZDOTDIR:-$HOME}/.zsh_plugins.zsh"'
echo "  cached ~/.zsh_plugins.zsh"

# --- check tools ---
echo ""
echo "Tool status:"
command -v uv &>/dev/null   && echo "  ✓ uv"   || echo "  ✗ uv:   curl -LsSf https://astral.sh/uv/install.sh | sh"
command -v fnm &>/dev/null  && echo "  ✓ fnm"  || echo "  ✗ fnm:  curl -fsSL https://fnm.vercel.app/install | bash"
command -v nvim &>/dev/null && echo "  ✓ nvim" || echo "  ✗ nvim: https://neovim.io"
