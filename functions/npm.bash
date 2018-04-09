#!/usr/bin/env bash

# Define custom NPM-related functions

source "${DOTFILES_PATH}/functions/bootstrap.bash"

## Get the current loglevel
ngll () {
    echo `npm config get loglevel`
}

## Set the current loglevel
nsll () {
    npm config set loglevel "$*"
}