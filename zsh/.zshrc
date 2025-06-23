#!/usr/bin zsh

# helper function to safely add paths
add_to_path() {
  for dir in "$@"; do
    [[ ":$PATH:" != *":$dir:"* ]] && export PATH="$dir:$PATH"
  done
}

# --- PATH enhancements ---
add_to_path \
  "$HOME/.local/bin" \
  "$HOME/bin" \
  "$HOME/.local/share/fnm"

# --- uv setup ---
install_uv() {
    curl -LsSf https://astral.sh/uv/install.sh | sh -s -- -y
}

if ! command -v uv >/dev/null 2>&1; then
    echo "Installing uv..."
    install_uv
fi

# --- antidote setup ---
antidote_dir="${ZDOTDIR:-$HOME}/.antidote"
install_antidote() {
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$antidote_dir"
}

if [[ ! -d "$antidote_dir" ]]; then
    echo "Installing antidote..."
    install_antidote
fi

source "$antidote_dir/antidote.zsh"
antidote load

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# --- fnm setup ---
install_fnm() {
    curl -fsSL https://fnm.vercel.app/install | bash
}

command -v fnm >/dev/null 2>&1 || install_fnm

eval "$(fnm env --use-on-cd)"

# --- environment variables ---
export \
  EDITOR=nvim \
  HISTFILE="$HOME/.zsh_history" \
  HISTSIZE=1000 \
  SAVEHIST=1000

# --- zsh options ---
setopt \
  append_history \
  share_history \
  hist_ignore_dups
