#!/usr/bin/env bash

# Define custom Git-related aliases

source "${DOTFILES_PATH}/functions/bootstrap.bash"

if commandExists git; then

	alias gbl='git branch -l'
	alias gbls='git for-each-ref --sort=-committerdate refs/heads/ --format="%(HEAD) %(committerdate:local) %09 %(refname:short)"'
	alias gcd="git checkout ${DEVELOPMENT_BRANCH_NAME}"
	alias gcf='git clean -f'
	alias gcp='git checkout -'
	alias gd='git diff'
	alias gl='git log'
	alias glg='gl --decorate --oneline --graph --date-order --all'
	alias gmd="git merge --commit --log --no-ff ${DEVELOPMENT_BRANCH_NAME}"
	alias gp='git pull'
	alias gpo='git pull origin'
	alias grd="git rebase ${DEVELOPMENT_BRANCH_NAME}"
	alias gs='git status'
	alias gsl='git stash list'
	alias gsp='git stash pop'
	alias gtl='git describe --abbrev=0'
fi