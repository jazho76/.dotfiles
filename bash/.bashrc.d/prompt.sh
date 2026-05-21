if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
else
    color_prompt=
fi

if [ "$color_prompt" = yes ]; then
    if [ "$EUID" -eq 0 ]; then
        pc='01;35'
    else
        pc='01;32'
    fi
    PS1='\[\033['"$pc"'m\]\u@\h\[\033[00m\]:\[\033['"$pc"'m\]\w\[\033[00m\]\$ '
    unset pc
else
    PS1='\u@\h:\w\$ '
fi

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
