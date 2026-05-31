if status is-interactive
  # Theme
  source $HOME/.config/fish/themes/onedark.fish

  # Key bindings
  set --erase --universal fish_key_bindings
  set --global fish_key_bindings fish_default_key_bindings
  # set --global fish_key_bindings fish_vi_key_bindings

  # # The prompt renders vi mode inline on its second line.
  # function fish_mode_prompt; end

  # omf
  source $HOME/.config/fish/functions/fish_prompt.fish
  source $HOME/.config/fish/functions/fish_right_prompt.fish

  alias ga='git add .'
  alias gs='git status'
  alias gc='git commit -m'
  alias gl='git log'

  alias vim='nvim'
  alias pac='sudo pacman'
  alias unlock='sudo rm /var/lib/pacman/db.lck'

  alias ..='cd ..'
  alias ...='cd ../..'
  alias .3='cd ../../..'
  alias .4='cd ../../../..'
  alias .5='cd ../../../../..'

  # bat
  # alias cat='bat'

  function cheatsh --description "Streamline cheat.sh call"
      curl cheat.sh/$argv
  end

  function tldr --description "Streamline cheat.sh call"
      curl cheat.sh/$argv
  end

  # log into fish when switched into root
  alias su='su -s /bin/fish'

  # Changing "ls" to "exa"
  alias ls='eza -al --color=always --group-directories-first' # my preferred listing
  alias la='eza -a --color=always --group-directories-first'  # all files and dirs
  alias ll='eza -l --color=always --group-directories-first'  # long format
  alias lt='eza -aT --color=always --group-directories-first' # tree listing
  alias l.='eza -a | egrep "^\."' # only hidden files

  # Colorize grep output (good for log files)
  alias grep='grep --color=auto'
  alias egrep='egrep --color=auto'
  alias fgrep='fgrep --color=auto'

  # ip
  alias ip='ip -color'

  # others
  alias pipes='pipes.sh -p 5 -f 40 R -r 2000'
  alias icat='kitty +kitten icat'
  alias neofetch='fastfetch'
  alias fm='nemo .'

  # fish_add_path "$HOME/go/bin/"

  zoxide init --cmd cd fish | source
end
