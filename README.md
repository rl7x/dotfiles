# Terminal dotfiles

Clean dark Apple Terminal, Starship, searchable Tab completion, history/completion autosuggestions, zoxide, and readable file listings. Supports Apple Silicon and Intel Macs with zsh and Homebrew.

## Install on another Mac

Install Homebrew from https://brew.sh and sign into GitHub (`gh auth login`) to access this private repository. Then:

```sh
mkdir -p ~/code
cd ~/code
gh repo clone rl7x/dotfiles
cd dotfiles
./install.sh --install-tools
```

The installer installs the Brewfile tools, clones missing Oh My Zsh/plugins from their upstream repositories, backs up replaced files under `~/.terminal-backups/dotfiles-*`, and symlinks the shared settings. It preserves existing plugin installations. It does not change your default shell, history, `.zprofile`, `.zshenv`, or local settings. If your account uses another shell, select `/bin/zsh` as your login shell in macOS account settings.

Double-click `terminal/Clean Dark.terminal` to import the appearance. In Terminal Settings → Profiles, choose Clean Dark and click Default; choose it for startup under General as well. Existing windows stay as they are. Open a new window to load the shell configuration.

## Update

```sh
cd ~/code/dotfiles
git pull --ff-only
```

Open a new shell, or run `exec zsh -l` in an idle one. Linked shell/prompt settings update directly; reimport the Terminal profile when its colors or font change. Run `./install.sh --install-tools` again when the Brewfile changes. The installer is safe to rerun and skips links already pointing here.

To publish your edits:

```sh
cd ~/code/dotfiles
git diff
git add zsh/zshrc starship.toml terminal/Clean\ Dark.terminal Brewfile README.md install.sh
git commit -m "Update terminal settings"
git push
```

## Autocomplete and shortcuts

- **Tab:** complete text; if it extends a shared prefix, press Tab again for the searchable menu.
- **Inside the menu:** type to filter, arrows or Tab/Shift-Tab to move, Enter to insert, Escape to cancel. Selecting does not run the command.
- **Gray suggestions:** history first, available completions second, fetched asynchronously.
- **Right Arrow at end of line:** accept the suggestion.
- **Option-F:** accept one word. Clean Dark enables Option as Meta.
- **Ctrl-R:** fuzzy history; **Ctrl-T:** insert a file path; **Option-C:** choose a directory.
- **z name / zi:** jump to a visited directory / choose interactively.
- **ll / la / lt:** detailed listing / hidden files / two-level tree.
- **bat file:** highlighted file view; q exits its pager.

Try `git switch ` then Tab in a repository, or `cd ` then Tab. Available flags and subcommands depend on installed completion definitions.

## Computer-specific settings

Put private aliases, project paths, and local tool configuration in `~/.zshrc.local`. It loads before Oh My Zsh. Never commit credentials or shell history. This repo does not include the original Mac's local paths or its Node 18 fallback; those stay in that Mac's local file.

Example:

```zsh
path=("$HOME/my-tools/bin" $path)
alias work='cd ~/code/my-project'
```

The shared config uses tools when installed and falls back to normal zsh completion if fzf-tab is missing. nvm integration is optional and does not automatically select a Node version. Linux is not covered by the installer or Apple Terminal profile.

## Roll back

Find the backup directory printed by the installer. Restore only files present there, replacing `BACKUP` below with that directory. For an original zshrc:

```sh
cp -P BACKUP/zshrc ~/.zshrc.restored
mv -f ~/.zshrc.restored ~/.zshrc
exec zsh -l
```

Use the same temporary-copy-and-move pattern to restore `BACKUP/starship.toml` to `~/.config/starship.toml` and `BACKUP/Clean-Dark.terminal` to `~/.config/terminal/Clean Dark.terminal`. This replaces the symlink instead of writing through it into the repository. If a target had no original file, remove only its dotfiles symlink. Select your previous Terminal profile to restore appearance. Installed tools/plugins may remain installed.
