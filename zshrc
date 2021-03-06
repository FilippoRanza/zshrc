#
#   zshrc - personal implementation of zsh's run configuration file
#
#   Copyright (c) 2018-2019 Filippo Ranza <filipporanza@gmail.com>
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


if [[ -e '/usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme' ]]; then

	zsh_wifi_signal(){
	    local net=$(iwgetid | perl -ne '/.+"(.+)"/; print $1' )
		if [[ $net ]] ; then
			echo -n "$net"
		fi
	}

	POWERLEVEL9K_CUSTOM_WIFI_SIGNAL_BACKGROUND='118'
	POWERLEVEL9K_CUSTOM_WIFI_SIGNAL_FOREGROUND='black'
	POWERLEVEL9K_CUSTOM_WIFI_SIGNAL="zsh_wifi_signal"

	POWERLEVEL9K_MODE='nerdfont-complete'

	source '/usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme'
	# install segments
	POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs dir_writable)
	POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status custom_wifi_signal  background_jobs)


	# customize prompt
	POWERLEVEL9K_PROMPT_ON_NEWLINE=true
	POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
	POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%{$fg_bold[yellow]%}->%{$reset_color%} "

	#define colors
	# dir
	POWERLEVEL9K_DIR_HOME_BACKGROUND='081'
	POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='111'
	POWERLEVEL9K_DIR_ETC_BACKGROUND='196'
	POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='196'

	# battery
	POWERLEVEL9K_BATTERY_CHARGING_BACKGROUND='202'
	POWERLEVEL9K_BATTERY_CHARGED_BACKGROUND='046'
	POWERLEVEL9K_BATTERY_LOW_BACKGROUND='001'
	POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND='black'
	POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND='black'
	POWERLEVEL9K_BATTERY_LOW_FOREGROUND='black'

	# vcs
	POWERLEVEL9K_VCS_CLEAN_BACKGROUND='046'
	POWERLEVEL9K_VCS_CLEAN_FOREGROUND='black'
	POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='red'
	POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='black'
	POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='154'
	POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='black'

else
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
fi

PROMPT="%{$fg_bold[magenta]%}[$_host_%~]%{$fg_bold[yellow]%}$_prompt_%{$reset_color%} "
RPROMPT='$(print_error)'

off(){
      echo "shutdown  now!!!"
      shutdown -h now
}


#add common aliases
#color ls output
if which lsd &> /dev/null ; then
	alias ls='lsd'
else
	alias ls='ls --color=auto'
fi

#ll rapid alias for ls -alF(remember ls = ls --color=auto)
alias ll='ls -alF'

#color grep,fgrep and egrep output
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

#add some custom program direcories to the path
local custom_path=("$HOME/.config/composer/vendor/bin" "/usr/scripts")
for p in "${custom_path[@]}"; do 
    if [[ -d "$p" ]] ; then
        PATH="$PATH:$p"
    fi
done
unset custom_path

export PATH


alias R='R --no-save'

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

_SATISFIED_DEPENCENCY_=''



function _sha512_(){
    sha512sum "$1" |
    awk '{print $1}'
}

function auto_type(){
  MSG=${1:-''}
  TIMES=${2:-'10'}
  DELAY=${3:-'10'}
  TYPE_DELAY=${4:-''}

  [[ -z "$MSG" ]] && return 1

  sleep "$DELAY"
  for i in {1.."$TIMES"}; do
    xdotool type "$MSG"
    xdotool key KP_Enter
    [[ "$TYPE_DELAY" ]] && sleep "$TYPE_DELAY"
  done

  notify-send "$0" "$TIMES x $MSG : done" -t 2500

}
function _compact_date_(){
    date '+%Y-%m-%d %H:%M'
}

function same_file(){

    if [[ -z "$1" ]]; then
        echo "$0 expected 2 parameters, got 0"
        return 2
    elif [[ -z "$2" ]] ; then
        echo "$0 expected 2 parameters, got 1"
        return 2
    fi

    if [[ ! ( -f "$1" ) ]]; then
        echo "$0: $1: not a regular file"
        return 3
    fi

    if [[ ! ( -f "$2" ) ]]; then
        echo "$0: $2: not a regular file"
        return 3
    fi

    [[ "$1" -ef "$2" ]] && return 0
    [[ $(stat -c '%s' "$1") == $(stat -c '%s' "$2") ]] || return 1
    [[ $(_sha512_ "$1") ==  $(_sha512_ "$2") ]]
}


function download(){
    local url=$(xclip -o 2> /dev/null | perl -pe 's/^\s+|\s+$//g' || exit)
    if [[ "$url" ]] ; then
        if wget -q "$url" &> /dev/null ; then
            echo -e "$0: done \U1f600"
        else
            echo -e "$0 : error : can't download '$url' \U1f621"
        fi
    fi
}


