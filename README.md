# Dotfiles

Personal configuration files for development environments across Linux and macOS.

## Structure

```
.config/
  nvim/          # Neovim configuration (LazyVim)
```

## Setup

### First-time setup on a new machine

1. Clone this repository:
   ```bash
   git clone <your-repo-url> ~/dev/dotfiles
   ```

2. Create symlinks:
   ```bash
   # Neovim
   ln -s ~/dev/dotfiles/.config/nvim ~/.config/nvim
   ```

3. Install Neovim (v0.11+):
   - **Linux (Arch)**: `sudo pacman -S neovim`
   - **macOS**: `brew install neovim`

4. Launch Neovim - plugins will auto-install via lazy.nvim:
   ```bash
   nvim
   ```

## Notes

- `lazy-lock.json` is tracked to ensure identical plugin versions across machines
- Plugin installations (`.lazy/` directory) are not tracked
- Configuration works on both Linux and macOS

## Adding more dotfiles

To add other configurations (bash, zsh, git, etc.):

1. Add files to this repo under appropriate directories
2. Create symlinks from your home directory
3. Commit and push changes
