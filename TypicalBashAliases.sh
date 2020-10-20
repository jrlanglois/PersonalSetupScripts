#!/bin/bash -e

#
# Colour & text styling variables to cut down on nonsense:
#

# Colours:
restoreColour=$(echo -en '\033[0m')
red=$(echo -en '\033[00;31m')
green=$(echo -en '\033[00;32m')
yellow=$(echo -en '\033[00;33m')
blue=$(echo -en '\033[00;34m')
magenta=$(echo -en '\033[00;35m')
purple=$(echo -en '\033[00;35m')
cyan=$(echo -en '\033[00;36m')
lightgray=$(echo -en '\033[00;37m')
lred=$(echo -en '\033[01;31m')
lgreen=$(echo -en '\033[01;32m')
lyellow=$(echo -en '\033[01;33m')
lblue=$(echo -en '\033[01;34m')
lmagenta=$(echo -en '\033[01;35m')
lpurple=$(echo -en '\033[01;35m')
lcyan=$(echo -en '\033[01;36m')
white=$(echo -en '\033[01;37m')

# Text styling:
restoreStyle=$(tput sgr0)
underline=$(tput smul)
removeUnderline=$(tput rmul)
#bold=$(tput smso)
#removeBold=$(tput rmso)
bold='\[\033[01;32m\]'
removeBold='[\033[00m\]'
italic=$(tput sitm)
removeItalic=$(tput ritm)

# Extract archives automatically!
extract()
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1    ;;
            *.tar.gz)    tar xvzf $1    ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xvf $1     ;;
            *.tbz2)      tar xvjf $1    ;;
            *.tgz)       tar xvzf $1    ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# Use netstat command to quickly list all TCP/UDP port on the server:
alias ports='netstat -tulanp'

# Git branch getters:
function getGitBranch()
{
    if [ -x /usr/bin/git ]; then
        if [ -x $PWD/.git ]; then
            echo "$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')"
            return
        fi
    fi

    echo ""
}

function prettyPrintGitBranch()
{
    currentBranch=$(getGitBranch)

    if [ -z "$currentBranch" ]; then
        echo ""
        return
    fi

    echo " ($currentBranch)"
}

# Way better 'ls'
unalias ls
alias ls='LC_COLLATE=C ls --color -lsha --group-directories-first'

# Fancy console:
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]: ${blue}\w${restoreColour}${yellow}$(prettyPrintGitBranch)${restoreColour} \n> '
