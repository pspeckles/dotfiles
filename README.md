# Dotfiles

Personal configuration files for development environments across Linux and macOS.

## Structure

```
.zshrc           # Main zsh configuration (~/.zshrc)
.config/
  nvim/          # Neovim configuration (~/.config/nvim)
  zsh/           # Zsh config directory (~/.config/zsh)
    aliases      # Shell aliases
    zfunc/       # Custom completion functions
```

## Setup

### First-time setup on a new machine

1. Clone this repository:
   ```bash
   git clone <your-repo-url> ~/dev/dotfiles
   ```

2. Create symlinks:
   ```bash
   ln -s ~/dev/dotfiles/.zshrc ~/.zshrc
   ln -s ~/dev/dotfiles/.config/nvim ~/.config/nvim
   ln -s ~/dev/dotfiles/.config/zsh ~/.config/zsh
   ```

3. Install Neovim (v0.11+):
   - **Linux (Arch)**: `sudo pacman -S neovim`
   - **macOS**: `brew install neovim`

4. Launch Neovim - plugins will auto-install via lazy.nvim:
   ```bash
   nvim
   ```

5. Install zsh plugins:
   - **Linux (Arch)**: `sudo pacman -S zsh-autosuggestions zsh-syntax-highlighting starship`
   - **macOS**: `brew install zsh-autosuggestions zsh-syntax-highlighting starship`

## Zsh Local Environment Files

For machine-specific configuration and secrets that shouldn't be committed to git, zsh automatically sources `*.env` files from `~/.config/zsh-local/`.

Setup:
```bash
mkdir -p ~/.config/zsh-local
touch ~/.config/zsh-local/local.env
chmod 600 ~/.config/zsh-local/local.env
```

### Configurable Variables

Plugin paths are auto-detected but can be overridden:

| Variable | Default | Description |
|----------|---------|-------------|
| `ZSH_PLUGIN_DIR` | Auto-detected | Base directory for zsh plugins |
| `ZSH_AUTOSUGGESTIONS_PATH` | `$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh` | Path to autosuggestions plugin |
| `ZSH_SYNTAX_HIGHLIGHTING_PATH` | `$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh` | Path to syntax highlighting plugin |
| `ZSH_LOCAL_DIR` | `~/.config/zsh-local` | Directory for local env files |

Auto-detection checks these locations in order:
1. `/usr/share/zsh/plugins` (Arch Linux)
2. `/opt/homebrew/share` (macOS Apple Silicon)
3. `/usr/local/share` (macOS Intel)

Example local config:
```bash
# ~/.config/zsh-local/local.env

# Override plugin paths (if non-standard location)
export ZSH_PLUGIN_DIR="/custom/path/to/plugins"

# Secrets
export ARTIFACTORY_USER="your-username"
export ARTIFACTORY_TOKEN="your-token"
```

**Security requirements:**
- Files must have `.env` extension
- Files must be owned by current user
- Files must have mode `600` or `400` (no group/other access)
- Files failing these checks are skipped with a warning

## Notes

- `lazy-lock.json` is tracked to ensure identical plugin versions across machines
- Plugin installations (`.lazy/` directory) are not tracked
- Configuration works on both Linux and macOS

## Adding more dotfiles

To add other configurations (bash, zsh, git, etc.):

1. Add files to this repo under appropriate directories
2. Create symlinks from your home directory
3. Commit and push changes
