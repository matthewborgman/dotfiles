#!/usr/bin/env bash

# Define custom NPM-related aliases

source "${DOTFILES_PATH}/functions/bootstrap.bash"

if commandExists npm; then

	alias ni='npm install --loglevel error'	# ni:	Install packages
	alias nl='npm link'						# nl:	Link packages
	alias nrl='npm run lint'				# nrl:	Run lint tests
	alias nrsl='npm run stylelint'			# nrsl:	Run stylelint tests
	alias nrt='npm run test'				# nrt:	Run unit tests
	alias ns='npm start'					# ns:	"Start"
	alias nsd='npm run start:dev'			# nsd:	"Start" in development mode
fi