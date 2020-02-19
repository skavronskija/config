# ~/.bashrc: executed by bash(1) for non-login shells.

function command_exists () {
  command -v "$1"  > /dev/null 2>&1;
}

# COLORS
RED=""
YELLOW=""
GREEN=""
BLUE=""
CYAN=""
PURPLE=""
LIGHT_RED=""
LIGHT_GREEN=""
LIGHT_CYAN=""
WHITE=""
LIGHT_GRAY=""
NORMAL=""
# check if stdout is a terminal...
if test -t 1; then
  # see if it supports colors...
  force_color_prompt=yes
  color_prompt=yes
  export TERM="xterm-256color"
  RED="\[\033[0;31m\]"
  YELLOW="\[\033[1;33m\]"
  GREEN="\[\033[0;32m\]"
  BLUE="\[\033[1;34m\]"
  PURPLE="\[\033[0;35m\]"
  CYAN="\[\033[0;36m\]"
  LIGHT_RED="\[\033[1;31m\]"
  LIGHT_GREEN="\[\033[1;32m\]"
  LIGHT_CYAN="\[\033[1;36m\]"
  WHITE="\[\033[1;37m\]"
  LIGHT_GRAY="\[\033[0;37m\]"
  NORMAL="\[\e[0m\]"
  # enable color support of ls and also add handy aliases
  alias ls='ls --color=auto'
fi

umask 022

# HISTORY
# don't put duplicate lines or lines starting with space in the history.
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTCONTROL=ignoreboth
HISTSIZE=
HISTFILESIZE=
HISTFILE=$HOME/.hist_bash
HISTTIMEFORMAT="%F %T "

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s checkwinsize
shopt -s cdspell
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# ALIASES
# some more ls aliases
alias ll='ls -hlF --time-style=long-iso'
alias lla='ls -ahlF --time-style=long-iso'
alias la='ls -A'
alias upd='sudo -- sh -c "apt update && apt full-upgrade -y"' 
                                 
alias mcc='mvn clean compile'    
alias mcp='mvn clean package'    
alias mci='mvn clean install'    
                                 

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# BINS CONDITIONS
SUDO=''
if [[ $EUID -ne 0 ]] && command_exists sudo ; then
  complete -cf sudo
  SUDO='sudo'
fi

if command_exists tmux ; then
	alias tl='tmux list-sessions'    
	alias ta='tmux attach -t'        
fi

if command_exists docker ; then
  # Docker
	alias dc='docker-compose'        
	alias d='docker'                 
	alias dv='docker volume'         
	alias di='docker images'         
fi

#if [ -d /usr/lib/jvm/default ]; then
#  export JAVA_HOME=/usr/lib/jvm/default
#elif [ -d /usr/lib/jvm/default-java ]; then
#  export JAVA_HOME=/usr/lib/jvm/default-java
#fi

export EDITOR='vim'

if command_exists git; then
  alias gpl="git pull origin"
  alias gps="git push origin"
  alias gst="git status"
  alias gco="git checkout"
  alias ga="git add"
  alias gaa="git add ."
  alias gcm="git commit -m"
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

LOCAL_BIN=$HOME/.local/bin
if [ -d $LOCAL_BIN ]; then
  export PATH=$PATH:$LOCAL_BIN
fi

# Autocomplete
source ~/.bash_completion.d/complete_alias
complete -F _complete_alias d
complete -F _complete_alias dv
complete -F _complete_alias di
complete -F _complete_alias dc


# PROMPT
# get current status of git repo
function parse_git_branch(){
  git branch 2> /dev/null | sed -n 's/^\* //p'
}
# Determine the branch/state information for this git repository.
function set_git_branch() {
  # Get the name of the branch.
  BRANCH=""
  if command_exists git_status ; then
    branch="$(git_status bash)"
  else
    branch="$(parse_git_branch)"
  fi

  if [ ! "${branch}" == "" ]; then
    BRANCH=" ${PURPLE}($branch)${NORMAL}"
  fi
}

# Return the prompt symbol to use, colorized based on the return value of the
# previous command.
function set_prompt_symbol () {
  if test $1 -eq 0 ; then
    P_SYMBOL="${GREEN}\n➤${NORMAL} "
  else
    P_SYMBOL="${LIGHT_RED}\n➤${NORMAL} "
  fi
}

# function new_line () {
#   NEW_LINE=""
#   echo -en "\033[6n" > /dev/tty && read -sdR CURPOS
#   if [[ ${CURPOS##*;} -gt 1 ]]; then
#       NEW_LINE="${RED}¬\n${NORMAL}"
#   fi
# }

# Set the full bash prompt.
function set_bash_prompt () {
  local EXIT_CODE="$?"
  local USERCOLOR="${GREEN}"
  # Set the P_SYMBOL variable. We do this first so we don't lose the
  # return value of the last command.
  # new_line

  set_prompt_symbol $EXIT_CODE

  # Set the BRANCH variable.
  set_git_branch

  # history -a
  # history -c
  # history -r
  if [[ $EUID -eq 0 ]] ; then
    USERCOLOR="${RED}"
  fi

  # Set the bash prompt variable.
  PS1="${NEW_LINE}${LIGHT_CYAN}\A${NORMAL} ${USERCOLOR}\u${NORMAL}@\h:${WHITE}[${GREEN}\w${WHITE}]${BRANCH}${P_SYMBOL}"
}

# Tell bash to execute this function just before displaying its prompt.
export PROMPT_COMMAND=set_bash_prompt

