#!/usr/bin/env bash
set -euo pipefail
repo_dir="$(cd "$(dirname "$0")" && pwd)"
if [[ "${1:-}" == "--install-tools" ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo 'Install Homebrew from https://brew.sh first, then rerun.' >&2
    exit 1
  fi
  brew bundle --file="$repo_dir/Brewfile"
elif [[ $# -gt 0 ]]; then
  echo 'Usage: ./install.sh [--install-tools]' >&2
  exit 1
fi
# Clone missing dependencies only; preserve existing plugin installations.
clone_missing() {
  if [[ ! -e "$2" ]]; then git clone --depth=1 "$1" "$2"; fi
}
clone_missing https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
mkdir -p "$HOME/.oh-my-zsh/custom/plugins"
clone_missing https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
clone_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
# nvm is optional; install only its shell integration if nvm already exists.
if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
  clone_missing https://github.com/lukechilds/zsh-nvm.git "$HOME/.oh-my-zsh/custom/plugins/zsh-nvm"
fi
backup_dir="$HOME/.terminal-backups/dotfiles-$(date +%Y%m%d-%H%M%S)-$$"
mkdir -p "$backup_dir" "$HOME/.config/terminal"
chmod 700 "$backup_dir"
[[ ! -f "$HOME/.zsh_history" ]] || cp -p "$HOME/.zsh_history" "$backup_dir/zsh_history"
link_file() {
  local src="$1" dest="$2" name="$3"
  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then return; fi
  if [[ -e "$dest" || -L "$dest" ]]; then mv "$dest" "$backup_dir/$name"; fi
  ln -s "$src" "$dest"
}
link_file "$repo_dir/zsh/zshrc" "$HOME/.zshrc" zshrc
link_file "$repo_dir/starship.toml" "$HOME/.config/starship.toml" starship.toml
link_file "$repo_dir/terminal/Clean Dark.terminal" "$HOME/.config/terminal/Clean Dark.terminal" Clean-Dark.terminal
printf 'Linked settings. Backups: %s\nOpen a new shell to load them.\n' "$backup_dir"
