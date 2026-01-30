# History
HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=100000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Vi mode
bindkey -v
export KEYTIMEOUT=1

# Completion system
zstyle :compinstall filename '/home/pspeckles/.zshrc'
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
autoload -Uz compinit
compinit

# ============================================
# PATH and Environment
# ============================================
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=/usr/bin/nvim

# ============================================
# Aliases
# ============================================
[[ -f ~/.config/zsh/aliases ]] && source ~/.config/zsh/aliases

# ============================================
# Colors (Tomorrow Night theme)
# ============================================
# Syntax highlighting colors (configured below after plugin load)
typeset -A ZSH_HIGHLIGHT_STYLES

# ============================================
# Starship Prompt
# ============================================
# Install: curl -sS https://starship.rs/install.sh | sh
# Or: pacman -S starship (Arch) / brew install starship (macOS)
eval "$(starship init zsh)"

# ============================================
# asdf version manager
# ============================================
export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
if [[ -f "$ASDF_DATA_DIR/asdf.sh" ]]; then
    source "$ASDF_DATA_DIR/asdf.sh"
    # asdf completions
    fpath=(${ASDF_DATA_DIR}/completions $fpath)
fi

# ============================================
# Auto-update JAVA_HOME (from asdf)
# ============================================
update_java_home() {
    if command -v asdf &>/dev/null; then
        local java_path=$(asdf which java 2>/dev/null)
        if [[ -n "$java_path" ]]; then
            local full_path=$(realpath "$java_path")
            export JAVA_HOME=$(dirname $(dirname "$full_path"))
            export JDK_HOME="$JAVA_HOME"
        fi
    fi
}
# Run on each prompt
precmd_functions+=( update_java_home )

# ============================================
# Local environment files (per-system config and secrets)
# ============================================
# Directory for machine-specific env files (not tracked in git)
# Only sources *.env files owned by current user with safe permissions
# Use this to override ZSH_PLUGIN_DIR, ZSH_AUTOSUGGESTIONS_PATH, etc.
ZSH_LOCAL_DIR="${ZSH_LOCAL_DIR:-$HOME/.config/zsh-local}"

if [[ -d "$ZSH_LOCAL_DIR" ]]; then
    for envfile in "$ZSH_LOCAL_DIR"/*.env(N); do
        [[ -f "$envfile" ]] || continue
        # Security checks:
        # 1. Must be owned by current user
        # 2. Must not be writable by group or others (mode should be 600 or 400)
        # Note: stat syntax differs between GNU (Linux) and BSD (macOS)
        if [[ "$OSTYPE" == darwin* ]]; then
            _zsh_local_mode=$(stat -f '%A' "$envfile" 2>/dev/null)
        else
            _zsh_local_mode=$(stat -c '%a' "$envfile" 2>/dev/null)
        fi
        if [[ -O "$envfile" ]] && [[ "$_zsh_local_mode" == "600" || "$_zsh_local_mode" == "400" ]]; then
            source "$envfile"
        else
            echo "zsh: skipping $envfile (must be owned by you with mode 600 or 400)" >&2
        fi
    done
    unset envfile _zsh_local_mode
fi

# ============================================
# Plugins
# ============================================
# Override ZSH_PLUGIN_DIR or individual paths in ~/.config/zsh-local/*.env
# Arch Linux (pacman): /usr/share/zsh/plugins
# macOS Homebrew: /opt/homebrew/share (Apple Silicon) or /usr/local/share (Intel)

# Auto-detect plugin directory if not set
if [[ -z "$ZSH_PLUGIN_DIR" ]]; then
    if [[ -d /usr/share/zsh/plugins ]]; then
        ZSH_PLUGIN_DIR="/usr/share/zsh/plugins"
    elif [[ -d /opt/homebrew/share ]]; then
        ZSH_PLUGIN_DIR="/opt/homebrew/share"
    elif [[ -d /usr/local/share ]]; then
        ZSH_PLUGIN_DIR="/usr/local/share"
    fi
fi

# Autosuggestions (fish-like)
ZSH_AUTOSUGGESTIONS_PATH="${ZSH_AUTOSUGGESTIONS_PATH:-$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh}"
if [[ -f "$ZSH_AUTOSUGGESTIONS_PATH" ]]; then
    source "$ZSH_AUTOSUGGESTIONS_PATH"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#969896'
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# Syntax highlighting (fish-like) - MUST be sourced last
ZSH_SYNTAX_HIGHLIGHTING_PATH="${ZSH_SYNTAX_HIGHLIGHTING_PATH:-$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh}"
if [[ -f "$ZSH_SYNTAX_HIGHLIGHTING_PATH" ]]; then
    source "$ZSH_SYNTAX_HIGHLIGHTING_PATH"

    # Tomorrow Night theme colors
    ZSH_HIGHLIGHT_STYLES[default]='none'
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#d54e53'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#c397d8'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=#c397d8'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=#c397d8'
    ZSH_HIGHLIGHT_STYLES[function]='fg=#c397d8'
    ZSH_HIGHLIGHT_STYLES[command]='fg=#c397d8'
    ZSH_HIGHLIGHT_STYLES[precommand]='fg=#c397d8,underline'
    ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#c397d8'
    ZSH_HIGHLIGHT_STYLES[path]='underline'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#b9ca4a'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#b9ca4a'
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#b9ca4a'
    ZSH_HIGHLIGHT_STYLES[comment]='fg=#e7c547'
    ZSH_HIGHLIGHT_STYLES[redirection]='fg=#70c0b1'
    ZSH_HIGHLIGHT_STYLES[arg0]='fg=#c397d8'
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#7aa6da'
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#7aa6da'
fi

# ============================================
# Keybindings
# ============================================
# Accept autosuggestion with Ctrl+F or End key
bindkey '^F' autosuggest-accept
bindkey '^[[F' autosuggest-accept      # End key
bindkey '^[[4~' autosuggest-accept     # End key (alternate)

# Partial accept (word by word) with Ctrl+Right
bindkey '^[[1;5C' forward-word

# History search
bindkey '^R' history-incremental-search-backward
bindkey '^P' up-history
bindkey '^N' down-history

# ============================================
# Custom completions (Rustup/Cargo, etc.)
# ============================================
if [[ -d ~/.config/zsh/zfunc ]]; then
    fpath=(~/.config/zsh/zfunc $fpath)
fi
