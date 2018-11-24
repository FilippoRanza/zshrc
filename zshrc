#
#   zshrc - personal implementation of zsh's run configuration file
#
#   Copyright (c) 2018 Filippo Ranza <filipporanza@gmail.com>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.


# The following lines were added by compinstall

zstyle ':completion:*' auto-description 'Must Specify: %d!'
zstyle ':completion:*' completer _oldlist _expand _complete _ignored _match _correct _approximate _prefix
zstyle ':completion:*' completions 1
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' format 'Autocompleting %d:'
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=** l:|=*'
zstyle ':completion:*' max-errors 3 numeric
zstyle ':completion:*' menu select=6
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' prompt '%e Errors:'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' substitute 1
zstyle ':completion:*' use-compctl true
zstyle ':completion:*' verbose false
zstyle :compinstall filename '/home/filippo/.zshrc'

autoload -Uz compinit
autoload -U colors && colors
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
unsetopt autocd
# End of lines configured by zsh-newuser-install
# this part is added by me ;-)
#this simple zsh script will add some personal aliases and set some enviriorment variables

#test connection
nt(){
	if [[ $1 ]]; then
		echo "ping 20 ECHO_REQUEST to ${1} 30s timout"
		ping -c 20 -w 30 -q  $1
	else
		echo "ping 20 ECHO_REQUEST to google.com 30s timeout "
		ping -c 20 -w 30 -q  google.com
	fi
	return 0
}


#reset prompt string
U_ID=$(id -u $USER)
R_ID=$(id -u root)
setopt PROMPT_SUBST

function print_error(){
    local ERR=$?
    if [[ $ERR -ne 0 ]]; then
        local msg="%{$fg_bold[white]%}%{$bg_bold[red]%}-$ERR-%{$reset_color%}"
        echo "$msg"
    fi
}


# change last string so the user knows if it is root or not
if [[ $U_ID -eq  $R_ID ]] ; then
	_prompt_='#'
else
	_prompt_='->'
fi

# change prompt if the user is logged into a remote shell
if [[ "$SSH_CLIENT" ]] ; then
	_host_="$(hostname) "
else
	_host_=''
fi

PROMPT="%{$fg_bold[magenta]%}[$_host_%~]%{$fg_bold[yellow]%}$_prompt_%{$reset_color%} "
RPROMPT='$(print_error)'

off(){
      echo "shutdown  now!!!"
      shutdown -h now
}


#add common aliases
#color ls output
alias ls='ls --color=auto'

#ll rapid alias for ls -alF(remember ls = ls --color=auto)
alias ll='ls -alF'

#color grep,fgrep and egrep output
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

#add /usr/scripts to executable dirs in PATH variable
export PATH=$PATH":/usr/scripts"


#this function counts the number of files inside a directory,it ignores hidden files ans directories
gfc(){
	out=$(ls -l | grep -v ^d | wc -l)
 	((out--))
	echo $out
}



#set default editor, for yaourt
export VISUAL=vim

#Plugins
#Syntax highlight plugin
HLIGHT_PLUGIN='/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
if [[ -f "$HLIGHT_PLUGIN" ]] ; then
	source "$HLIGHT_PLUGIN"

	#change default color scheme
	ZSH_HIGHLIGHT_STYLES[default]=none
	ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
	ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=yellow,bold
	ZSH_HIGHLIGHT_STYLES[alias]=none
	ZSH_HIGHLIGHT_STYLES[builtin]=none
	ZSH_HIGHLIGHT_STYLES[function]=fg=yellow
	ZSH_HIGHLIGHT_STYLES[command]=none
	ZSH_HIGHLIGHT_STYLES[precommand]=none
	ZSH_HIGHLIGHT_STYLES[commandseparator]=none
	ZSH_HIGHLIGHT_STYLES[hashed-command]=none
	ZSH_HIGHLIGHT_STYLES[path]=none
	ZSH_HIGHLIGHT_STYLES[redirection]=fg=white,bold
	ZSH_HIGHLIGHT_STYLES[globbing]=none
	ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue
	ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=yellow
	ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=yellow
	ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=fg=yellow
	ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=magenta
	ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=cyan
	ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=cyan
	ZSH_HIGHLIGHT_STYLES[assign]=fg=white,bold

fi


#History shearch plugin
HIST_PLUGIN='/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh'
if [[ -f  "$HIST_PLUGIN" ]] ; then
	source "$HIST_PLUGIN"
	bindkey '^[[A' history-substring-search-up
	bindkey '^[[B' history-substring-search-down

fi

#syntax highlight in man
export LESS_TERMCAP_mb=$'\e[1;35m'
export LESS_TERMCAP_md=$'\e[1;35m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;37m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;36m'


#automatically show man page for current command
#on specified key event

function _exist_man_page(){
    man -f "$1" &> /dev/null
}

function _show_current_command_man(){
    if [[ "$BUFFER" ]] ; then
        tmp=("${=BUFFER}")
        if [[ $#tmp -eq  '1' ]] ; then
            _exist_man_page "$tmp[1]"  && man "$tmp[1]"
        else
            if [[ ! $tmp[2] =~ ^- ]] && [[ ! -e $tmp[2] ]]; then
                if _exist_man_page "$tmp[1]-$tmp[2]" ; then
                    man "$tmp[1]-$tmp[2]"
                elif  _exist_man_page "$tmp[1]" ; then
                    man "$tmp[1]"
                fi
            else
                _exist_man_page "$tmp[1]"  && man "$tmp[1]"
            fi
        fi
    fi
}
zle -N _show_current_command_man
#action is ctrl + Z
bindkey '^Z' _show_current_command_man
