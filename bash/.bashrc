# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# enable toggling
set -o emacs
bind '"\ee": vi-editing-mode'
# enable vi mode
set -o vi
bind '"\ee": emacs-editing-mode'

eval `dircolors ~/.dir_colors`

# use real path on symbolic links
set -P

# disable ctrl-s because it confuses me
stty stop undef start undef

# keep history forever and combined
export HISTCONTROL=ignoredups
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export HISTIGNORE='ls:bg:fg:history'
export HISTFILE=~/.persistent_history
shopt -s histappend
shopt -s cmdhist
PROMPT_COMMAND="history -a;"

# set the EDITOR variable so I'm in control
export EDITOR=vim

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

PS1='$ '
SHOW_HOST=''
if [ -n "$SSH_CLIENT" -a `hostname -s` != gb ]; then
    SHOW_HOST='\h:'
fi
if [ -f /usr/bin/git ]; then
    export GIT_PS1_SHOWDIRTYSTATE=true
    export GIT_PS1_SHOWUNTRACKEDFILES=true
    if [ -f /usr/lib/git-core/git-sh-prompt ]; then
        . /usr/lib/git-core/git-sh-prompt;
    elif [ -f /etc/bash_completion.d/git ]; then
        . /etc/bash_completion.d/git
    else
        [ -t 1 ] && echo "Did not find git prompt"
    fi
    case "$TERM" in
    xterm*|screen*|tmux*)
        export PS1='\[\e[00;34m\]'"$SHOW_HOST"'\W\[\e[00;31m\]`__git_ps1`\[\e[00m\]\$ '
        ;;
    *)
        export PS1="$SHOW_HOST"'\W`__git_ps1`$ '
        ;;
    esac
fi
if [ -n "$TMUX" -o "$TERM" = "tmux-256color" ]; then
    export PS1=$PS1'\[\e]2;\h:\w\e\\\ek\h:\W\e\\\]'
    function tc() { tmux new-window -c $(readlink -e $1); }
    function ts() { tmux new-window ssh $1; }
fi

# Alias definitions.
alias ls='ls -F --color --hide=__pycache__ '
alias more=less
alias ka='/usr/bin/kinit -l7d; /usr/bin/aklog'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -f ~/.docker-completion.sh ]; then
    . ~/.docker-completion.sh
fi
if [ -f ~/share/bash/git-completion.bash ]; then
    . ~/share/bash/git-completion.bash
fi


# configure fzf
export FZF_DEFAULT_COMMAND='ag -g ""'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Use ag instead of the default find command for listing candidates.
# - The first argument to the function is the base path to start traversal
# - Note that ag only lists files not directories
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  ag -g "" "$1"
}

# try redefining their function to include all previous
__fzf_history__() (
  cat ~/.persistent_history | $(__fzfcmd) +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r
)

# load up cd hack
[ -f ~/dotfiles/z/z.sh ] && source ~/dotfiles/z/z.sh

# node version manager
export NVM_DIR="/home/gb/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
