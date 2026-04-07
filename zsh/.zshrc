typeset -U path
path=($HOME/.local/bin $HOME/bin $HOME/.local/share/fnm $HOME/apps/CPLEX_Studio/cpoptimizer/bin/x86-64_linux $path)

export EDITOR=nvim HISTFILE=$HOME/.zsh_history HISTSIZE=10000 SAVEHIST=10000
setopt share_history hist_ignore_dups

[[ -f ~/.secrets ]] && source ~/.secrets

_setup_history_keys() {
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
}

[[ -f ${ZDOTDIR:-$HOME}/.zsh_plugins.zsh ]] && source ${ZDOTDIR:-$HOME}/.zsh_plugins.zsh

command -v fnm &>/dev/null && eval "$(fnm env --use-on-cd --shell zsh)"
