#!/usr/bin/env bash

# Define custom NPM-related aliases

source "${DOTFILES_PATH}/functions/bootstrap.bash"

if commandExists npm; then

    alias ni='npm install --loglevel error'	# ni:	Install packages
    alias nl='npm link'						# nl:	Add "global" link to package or link to other global package if specified
    alias nrl='npm run lint'				# nrl:	Run lint tests
    alias nrsl='npm run stylelint'			# nrsl:	Run stylelint tests
    alias nrt='npm run test'				# nrt:	Run unit tests
    alias nrtd='npm run test:debug'			# nrtd:	Run unit tests in debug mode
    alias ns='npm start'					# ns:	"Start"
    alias nsd='npm run start:dev'			# nsd:	"Start" in development mode
fi