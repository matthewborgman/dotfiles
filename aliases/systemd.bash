#!/usr/bin/env bash

# Define custom systemd-related functions

source "${DOTFILES_PATH}/functions/bootstrap.bash"

## NOTE: Adopted from https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/systemd/systemd.plugin.zsh
if commandExists systemctl; then

	SUDO_COMMANDS=(
		start stop reload restart try-restart isolate kill
		reset-failed enable disable reenable preset mask unmask
		link load cancel set-environment unset-environment
		edit)

	USER_COMMANDS=(
		list-units is-active status show help list-unit-files
		is-enabled list-jobs show-environment cat list-timers)

	for c in "${USER_COMMANDS[@]}"; do
		alias sc-$c="systemctl $c"
	done

	for c in "${SUDO_COMMANDS[@]}"; do
		alias sc-$c="sudo systemctl $c"
	done

	unset SUDO_COMMANDS
	unset USER_COMMANDS
fi