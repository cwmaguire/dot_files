# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# For history stuff, see
# https://administratosphere.wordpress.com/2011/05/20/logging-every-shell-command/

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    #xterm-color) color_prompt=yes;;

    # Changed in Ubuntu 21.10
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# run our bash colours script if we have one
[[ -s "$HOME/.bash_profile_colours" ]] && source "$HOME/.bash_profile_colours"

git_prompt () {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi

  git_branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')

  if git diff --quiet 2>/dev/null >&2; then
    git_color="${White}"
  else
    git_color=${Red}
  fi

  echo "[$git_color$git_branch${Color_Off}]"
}

set_prompt () {
  PS1="\[$Cyan\]\H\[$Color_Off\] \! \[$Green\]\w\[$Color_Off\] $(git_prompt) \n\[$Red\]\$\[$Color_Off\]"

  # If this is an xterm set the title to user@host:dir
  case "$TERM" in
  xterm*|rxvt*)
      PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
      ;;
  *)
      ;;
  esac
}

export PROMPT_COMMAND="set_prompt"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
#alias la='ls -A'
#alias l='ls -CF'

# G adds colours, which are modified by LSCOLORS above and defined below
alias l="ls -lG"
alias la="ls -laG"
alias lr="ls -laGrt"
# -d says not to go down into directories, so this lists all the dot
# files
alias ld="la -dlaG .*"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
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

# I _think_ if you leave off "-display :0" and then open a terminal
# in a screen other than display :0 then it screws up the arrow keys, home,
# end, etc.
setxkbmap -display :0 -option ctrl:nocaps


#2023-06-06 CM - I don't have an Android phone anymore and I don't plan on doing installs
#export ANDROID_HOME="/home/c/Downloads/android-sdk-linux"
#export PATH="${ANDROID_HOME}/platform_tools:${ANDROID_HOME}/tools:${PATH}"

# PyEnv
# 2022-06-06
# Install pyenv as a shell function
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export PS_FORMAT="pid,ppid,uid,euser,tname,ni,%cpu,%mem,cputime,cmd"

#The color designators are as follows:
#
#                           a     black
#                           b     red
#                           c     green
#                           d     brown
#                           e     blue
#                           f     magenta
#                           g     cyan
#                           h     light grey
#                           A     bold black, usually shows up as dark grey
#                           B     bold red
#                           C     bold green
#                           D     bold brown, usually shows up as yellow
#                           E     bold blue
#                           F     bold magenta
#                           G     bold cyan
#                           H     bold light grey; looks like bright white
#                           x     default foreground or background
#
#                     Note that the above are standard ANSI colors.  The actual display may differ depending on the color capabilities of the terminal in use.
#
#                     The order of the attributes are as follows:
#
#                           1.   directory
#                           2.   symbolic link
#                           3.   socket
#                           4.   pipe
#                           5.   executable
#                           6.   block special
#                           7.   character special
#                           8.   executable with setuid bit set
#                           9.   executable with setgid bit set
#                           10.  directory writable to others, with sticky bit
#                           11.  directory writable to others, without sticky bit
#

#                     The default is "exfxcxdxbxegedabagacad"

# activate erlang 18.2 with kerl activate script (source it)
#. ~/dev/erlang_kerl/18.2/activate
 #activate erlang 23.0 with kerl activate script (source it)
#. /home/c/dev/erlang_kerl/23.0/activate
# activate erlang 21.2.3 with kerl activate script (source it)
#. /home/c/dev/erlang_kerl/21.2.3/activate
# activate erlang 23.2.6 with kerl activate script (source it)
#. /home/c/dev/erlang_kerl/23.2.6/activate
# activate erlang 23.1.5 with kerl activate script (source it)
#. /home/c/dev/erlang_kerl/23.1.5/activate
. /home/c/dev/erlang_kerl/23.3.4.5/activate
#. ~/dev/erlang_kerl/18.3/activate

# Kiex manages Elixir versions like Kerl for Erlang
test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"

# setup wacom tablet
if ( xsetwacom list devices | grep -q "Pen stylus" )
then
  xsetwacom set "Wacom Intuos PT M Pen stylus" MapToOutput "2550x2160+1280+1080";
  xsetwacom set "Wacom Intuos PT M Pen stylus" button 3 "key ctrl z";
fi


# set default postgres database and user
#export PGUSER=voalte
#export PGDATABASE=audit

# Google's Go language
export PATH=$PATH:/usr/local/go/bin

# Julia language
export PATH=$PATH:$HOME/dev/julia-1.0.0/bin

PATH="/home/c/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/c/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/c/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/c/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/c/perl5"; export PERL_MM_OPT;
export PATH="$PATH:/opt/mssql-tools/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"
