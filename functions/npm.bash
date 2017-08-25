#!/usr/bin/env bash

# Define custom NPM-related functions

source "${DOTFILES_PATH}/functions/bootstrap.bash"

# Define functions for use with Invision
if [ -d "$INVISION_PATH" ]; then

	nia () {
		DEFAULT_ALIASES=(invc invui invr invcc invbo invstu invsec invd inve2e inv)

		ALIASES=("${*:-${DEFAULT_ALIASES[@]}}")
		CURRENT_DIRECTORY="$PWD"

		for i in "${ALIASES[@]}"; do

			CUSTOM_ALIAS=${i}
			CUSTOM_ALIAS_LENGTH=${#CUSTOM_ALIAS}
			CUSTOM_ALIAS_LENGTH=$((CUSTOM_ALIAS_LENGTH+1))

			RESULT=`eval ${BASH_ALIASES[$CUSTOM_ALIAS]} && ni`

			echo -e "\n"
			echo "$CUSTOM_ALIAS:"
			printf '=%.0s' $(seq 1 $CUSTOM_ALIAS_LENGTH)
			echo -e "\n"
			echo "$RESULT"
		done

		cd $CURRENT_DIRECTORY || exit
	}
fi