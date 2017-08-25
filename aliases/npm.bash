#!/usr/bin/env bash

# Define custom NPM-related aliases

source "${DOTFILES_PATH}/functions/bootstrap.bash"

if commandExists npm; then

	alias ni='npm install --loglevel error'
	alias nl='npm link'
	alias nrl='npm run lint'
	alias nrt='npm run test'
	alias ns='npm start'
	alias nsd='npm run start:dev'
fi