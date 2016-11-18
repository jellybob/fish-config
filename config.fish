. ~/.config/fish/aliases.fish

# Prompt
set -gx fish_greeting ''

function fish_prompt
  set_color $fish_color_cwd
  echo -n (prompt_pwd)
  set_color normal

  git-prompt

  set_color green
  if test "$USER" = "root"
    printf '# '
  else
    printf '$ '
  end

  set_color normal
end

function fish_right_prompt
  set last_status $status

  printf '%s ' (date +%H:%M:%S)

  if test $last_status -ne 0
    set_color red -o
    printf '%d ' $last_status
    set_color normal
  end
end

function git_current_branch -d 'Prints a human-readable representation of the current branch'
  set -l ref (git symbolic-ref HEAD ^/dev/null; or git rev-parse --short HEAD ^/dev/null)
  if test -n "$ref"
    echo $ref | sed -e s,refs/heads/,,
    return 0
  end
end

function git-prompt
  if git rev-parse --show-toplevel >/dev/null 2>&1
    set_color magenta
    printf ' (%s)' (git_current_branch)
    set_color green
    set_color normal
  end
end

# Globals
set -gx EDITOR vim

function fish_user_key_bindings
  bind \es prepend-sudo
  bind \eb prepend-bundle-exec
  bind \ev edit-command
end

. ~/.config/fish/env.fish

set -gx __fish_initialized 1

set -gx RBENV_ROOT ~/.rbenv
append-to-path ~/.rbenv/bin
. (rbenv init -|psub)

nvm > /dev/null
eval (python -m virtualfish)
eval (direnv hook fish)
