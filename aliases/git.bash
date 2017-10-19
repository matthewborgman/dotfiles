#!/usr/bin/env bash

# Define custom Git-related aliases

source "${DOTFILES_PATH}/functions/bootstrap.bash"

if commandExists git; then

	alias gbl='git branch -l'																										# gbl:	List branches in the current repo
	alias gbn='git rev-parse --abbrev-ref HEAD'																						# gbn:	Display the name of the current branch
	alias gbls='git for-each-ref --sort=-committerdate refs/heads/ --format="%(HEAD) %(committerdate:local) %09 %(refname:short)"'	# gbls:	List branches in the current repo sorted by commit date
	alias gcd="git checkout ${DEVELOPMENT_BRANCH_NAME}"																				# gc:	Checkout the "development" branch
	alias gcf='git clean -f'																										# gcf:	Clean the current repo
	alias gcp='git checkout -'																										# gcp:	Checkout the previous branch
	alias gd='git diff'																												# gd:	Display a diff for the current branch
	alias gl='git log'																												# gl:	Display a log of commits to the current branch
	alias glg='gl --decorate --oneline --graph --date-order --all'																	# glg:	Display a log of commits to the current branch as a graph
	alias gmd="git merge --commit --log --no-ff ${DEVELOPMENT_BRANCH_NAME}"															# gmd:	Merge the "development" branch into the current branch
	alias gp='git pull'																												# gp:	Pull into the current branch
	alias grd="git rebase ${DEVELOPMENT_BRANCH_NAME}"																				# grd:	Rebase the current branch off the "development" branch
	alias gs='git status'																											# gs:	Display the status of the current branch
	alias gsl='git stash list'																										# gsl:	List stashes for the current repo
	alias gsp='git stash pop'																										# gsp:	Apply then drop the most recent stash for the current repo onto the current branch
	alias gtl='git describe --abbrev=0'																								# gtl:	Display the most recent tag for the current repo
fi