[[ $- != *i* ]] && return

# 'bindkey -v' for vim mode
bindkey -e

# For 'sudoedit' command
export SUDO_EDITOR="$EDITOR"

# Theme for bat
export BAT_THEME=base16

# Theme for fzf
export FZF_DEFAULT_OPTS="--color=fg:#abb2bf,bg:#282c34,hl:#98c379 --color=fg+:#abb2bf,bg+:#2c313c,hl+:#98c379 --color=info:#61afef,prompt:#98c379,pointer:#e06c75 --color=marker:#e06c75,spinner:#e5c07b,header:#5c6370"

# Meta/UTF-8 settings
setopt COMBINING_CHARS

# Color man pages with bat
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Duplicated from .config/uwsm/env so SSH works too
export OMARCHY_PATH=$HOME/.local/share/omarchy
export PATH=$OMARCHY_PATH/bin:$PATH:$HOME/.local/bin

# Ensure command hashing is off for mise
setopt NO_HASH_CMDS
setopt NO_HASH_DIRS

# # Fix long menus
# setopt MENU_COMPLETE
# setopt AUTO_MENU

# Don't beep on errors
unsetopt BEEP

# Mise
if command -v mise &>/dev/null; then
  eval "$(mise activate zsh)"
fi

# Zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init --cmd cd zsh)"
fi

### Zimfw
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
zstyle ':zim' disable-version-check yes

ZIM_HOME=${ZDOTDIR:-${HOME}}/.local/share/zim
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source /usr/share/zimfw/zimfw.zsh init
fi

source ${ZIM_HOME}/init.zsh
###

# disable groups
zstyle -d ':completion:*:descriptions' format
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
# zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Navigation
alias ..='cd ..'
alias ...='cd ../..'

# Listing
alias ls='eza -al --color=always --group-directories-first'
alias la='eza -a --color=always --group-directories-first'
alias ll='eza -l --color=always --group-directories-first'
alias lt='eza -aT --color=always --group-directories-first'
alias l.='eza -a | egrep "^\."'

# Colorized output
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ip='ip -color'

# fzf
alias ff="fzf --style full --preview 'bat --style=numbers --color=always {}'"
alias eff='$EDITOR "$(ff)"'
sff() {
  if [ $# -eq 0 ]; then
    echo "Usage: sff <destination> (e.g. sff host:/tmp/)"
    return 1
  fi
  local file
  file=$(find . -type f -printf '%T@\t%p\n' | sort -rn | cut -f2- | ff) && [ -n "$file" ] && scp "$file" "$1"
}

# Editor
n() { if [[ $# -eq 0 ]]; then nvim .; else nvim "$@"; fi; }

# Misc tools
open() (
  xdg-open "$@" >/dev/null 2>&1 &
)
tldr() { curl -s "cheat.sh/$1"; }
alias neofetch='fastfetch'

# Pacman
alias pac='sudo pacman'
alias unlock='sudo rm /var/lib/pacman/db.lck'

### Git worktree helpers ###
# Create a new worktree and branch from within current git directory.
GWA() {
  if [[ -z "$1" ]]; then
    echo "Usage: GWA [branch name]"
    return 1
  fi

  local branch="$1"
  local base="$(basename "$PWD")"
  local wt_path="../${base}--${branch}"

  git worktree add -b "$branch" "$wt_path"
  mise trust "$wt_path"
  cd "$wt_path"
}

# Remove worktree and branch from within active worktree directory.
GWD() {
  if gum confirm "Remove worktree and branch?"; then
    local cwd base branch root worktree

    cwd="$(pwd)"
    worktree="$(basename "$cwd")"

    # split on first `--`
    root="${worktree%%--*}"
    branch="${worktree#*--}"

    # Protect against accidentally nuking a non-worktree directory
    if [[ "$root" != "$worktree" ]]; then
      cd "../$root"
      git worktree remove "$cwd" --force || return 1
      git branch -D "$branch"
    fi
  fi
}
