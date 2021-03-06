#!/usr/bin/env zsh

# Define custom 1Password-related functions

## Sign-in to 1Password account, reusing an existing session if active
1pauth() {
    eval $(op signin matthewborgman --session "${OP_SESSION_matthewborgman}")
}

## Retrieve the password for the given item
1prp () {
    if [[ -z "$1" ]]; then

        echo '`1prp` requires the name of a 1Password item.'
    else

        op get item "$1" --fields password
    fi
}