# Created by newuser for 5.9

eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd --shell zsh)"

alias claude='claude --dangerously-skip-permissions --enable-auto-mode'

# dotfiles bare repo
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
