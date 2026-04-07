# zsh

## Usage

Run `install.sh` to:
1. Symlink `.zshrc`, `.zsh_plugins.txt`, `.tmux.conf` to `$HOME`
2. Install antidote and generate static plugin cache
3. Report missing tools (uv, fnm, nvim)

## Offline deployment

On a machine with internet, run `install.sh`, then bundle:

```bash
cd ~ && tar czf dotfiles.tar.gz .zshrc .zsh_plugins.txt .zsh_plugins.zsh .secrets .tmux.conf .antidote/ .cache/antidote/
```

Copy and extract on the target machine. No network needed.

## Secrets

API keys live in `~/.secrets` (chmod 600, not versioned). Create it manually:

```bash
cat > ~/.secrets << 'EOF'
export ANTHROPIC_BASE_URL="..."
export ANTHROPIC_AUTH_TOKEN="..."
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export CONTEXT7_API_KEY="..."
EOF
chmod 600 ~/.secrets
```
