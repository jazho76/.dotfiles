command -v zoxide >/dev/null || return 0

eval "$(zoxide init bash)"
alias cd=z
