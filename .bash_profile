
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# run our bash colours script if we have one
[[ -s "$HOME/.bash_profile_colours" ]] && source "$HOME/.bash_profile_colours"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=~/.aed/bin:~/bin:$PATH

# MacPorts Installer addition on 2014-01-07_at_12:23:45: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

export DISPLAY=:0.0

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

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

# The \e[x;yym  are what start a colour
# \e[m ends a colour
# \H is hostname
# \! is the command history number
# \$ is the full path
# NOTE: non-printing characters, if not escaped with \[...\] will mess you up
#       if you hit the up arrow, get a long command, then hit up arrow again and
#       get a short command. 
#       Using {$BLAH} instead of \[$BLAH\] will do this to you. 
# The colours are loaded from .bash_profile_colors

# Create a function for Bash to run because although \H and \! are magic 
# and will always print out the right value, $(git_prompt) will be static 
# once PS1 is set. 
# This way we'll reset the prompt every time Bash asks us to.
set_prompt () {
  PS1="\[$Cyan\]\H\[$Color_Off\] \! \[$Green\]\w\[$Color_Off\] $(git_prompt) \n\[$Red\]\$\[$Color_Off\]"
}

export PROMPT_COMMAND="set_prompt"

# "export" is key
export LSCOLORS=Dxfxcxdxbxegedabagacad
export EDITOR=vim

# G adds colours, which are modified by LSCOLORS above and defined below
alias l="ls -lG"
alias la="ls -laG"
# -d says not to go down into directories, so this lists all the dot
# files
alias ld="la -dlaG .*"

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
