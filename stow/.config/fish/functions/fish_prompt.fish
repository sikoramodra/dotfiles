function fish_prompt
  # Cache exit status
  set -l last_status $status

  # Just calculate these once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end
  if not set -q __fish_prompt_char
    switch (id -u)
      case 0
	set -g __fish_prompt_char '#'
      case '*'
	set -g __fish_prompt_char 'λ'
    end
  end
    
  # Colors
  set -l normal (set_color normal)
  set -l white (set_color ABB2BF)
  set -l cyan (set_color 56B6C2)
  set -l orange (set_color D19A66)
  set -l red (set_color E06C75)
  set -l green (set_color 98C379)
 
  # Configure __fish_git_prompt
  set -g __fish_git_prompt_char_stateseparator ' '
  set -g __fish_git_prompt_color 61AFEF
  set -g __fish_git_prompt_color_flags E06C75
  set -g __fish_git_prompt_color_prefix ABB2BF
  set -g __fish_git_prompt_color_suffix ABB2BF
  set -g __fish_git_prompt_showdirtystate true
  set -g __fish_git_prompt_showuntrackedfiles true
  set -g __fish_git_prompt_showstashstate true
  set -g __fish_git_prompt_show_informative_status true 

  set -l current_user (whoami)

  # Line 1
  echo -n $white'╭─'$red$current_user$white' at '$orange$__fish_prompt_hostname$white' in '$green(pwd|sed "s=$HOME=⌁=")$cyan
  __fish_git_prompt " (%s)"
  echo

  # Line 2
  echo -n $white'╰'
  # support for virtual env name
  if set -q VIRTUAL_ENV
    echo -n "($cyan"(basename "$VIRTUAL_ENV")"$white)"
  end
  echo -n $white'─'$__fish_prompt_char $normal
end

set -g VIRTUAL_ENV_DISABLE_PROMPT 1

