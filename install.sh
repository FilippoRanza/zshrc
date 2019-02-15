#! /bin/sh

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


REPO_PATH="$(pwd)/zshrc"
REPO_VERS=$(sha512sum "$REPO_PATH" | awk '{print $1}')
REPO_SIZE=$(stat -c '%s' "$REPO_PATH") 

# get file onwer and group
get_owner(){
    stat -c '%U:%G' $1
}

check_install(){
    
    #if the files have different size they can't be equal
    [[ "$REPO_SIZE" ==  $(stat -c '%s' "$1/.zshrc") ]] || return '1'

    USER_VERS=$(sha512sum "$1/.zshrc" | awk '{print $1}')
    if [[ "$REPO_VERS" == "$USER_VERS" ]]; then
        OUT=0
        echo "$(stat -c '%U' $1) already has installed the last version"
    else
        OUT=1
    fi
    return "$OUT"
}

install(){
    check_install "$1" && return
    if [[ $2 ]] ; then
        ln -s "$REPO_PATH" "$1/.zshrc"
    else
        cp "$REPO_PATH" "$1/.zshrc"
    fi
    # reset .zshrc owner.
    chown "$(get_owner $1)" "$1/.zshrc"
}


zsh_user(){
    cat '/etc/passwd' |
    perl -aln -F: -e 'print $F[5] if $F[6] =~ /zsh/'
}

# install .zshrc in every home directory
auto_install(){
    for d in $(zsh_user); do
        install "$d" "$1"
    done
}






AUTO=''
SOFT=''
while [[ $1 ]]; do
    # the values doesn't metter,
    # the only important thing
    # is that the variable is not
    # empty
    case $1 in
        'auto') AUTO='auto'
            ;;
        'soft') SOFT='soft'
            ;;
        *) echo "unknown option $1"
    esac

    shift

done


if [[ "$AUTO" ]] ; then
    auto_install "$SOFT"
else
    install "$HOME" "$SOFT"
fi
