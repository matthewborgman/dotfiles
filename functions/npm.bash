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

# Define functions for use with Invision
if [ -d "$INVISION_PATH" ]; then

	## Install packages for each of the repos
	nia () {
		CURRENT_DIRECTORY="$PWD"

		for i in "${INVISION_REPO_ALIASES[@]}"; do

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

	## Add links for each of the repos and link between them
	nla () {
		CURRENT_DIRECTORY="$PWD"

		nua

		for i in "${INVISION_REPO_ALIASES[@]}"; do

			CUSTOM_ALIAS=${i}
			CUSTOM_ALIAS_LENGTH=${#CUSTOM_ALIAS}
			CUSTOM_ALIAS_LENGTH=$((CUSTOM_ALIAS_LENGTH+1))

			case "$CUSTOM_ALIAS" in
				"inv")
					eval ${BASH_ALIASES[$CUSTOM_ALIAS]}
					nlp ${CUSTOM_ALIAS}
					;;
				"invc")
					eval ${BASH_ALIASES[$CUSTOM_ALIAS]}
					nl
					;;
				"inve2e")
					eval ${BASH_ALIASES[$CUSTOM_ALIAS]}
#					npm run install:webDriver
					./node_modules/.bin/webdriver-manager update
					nlp ${CUSTOM_ALIAS}
					nl invision
					;;
				"invui")
					nlc ${CUSTOM_ALIAS}
					;;
				*)
					nlcu ${CUSTOM_ALIAS}
					;;
			esac

			echo -e "\n"
			echo "$CUSTOM_ALIAS:"
			printf '=%.0s' $(seq 1 $CUSTOM_ALIAS_LENGTH)
			echo -e "\n"
			echo 'Linked'
		done

		cd $CURRENT_DIRECTORY || exit
	}

	nlc () {
		CURRENT_LOGLEVEL=`ngll`
		PROJECT="$*"

		eval ${BASH_ALIASES[$PROJECT]}

		nsll silent
		nl
		nl invision-core

		nsll $CURRENT_LOGLEVEL
	}

	nlcu () {
		CURRENT_LOGLEVEL=`ngll`
		PROJECT="$*"

		eval ${BASH_ALIASES[$PROJECT]}

		nsll silent
		nl
		nl invision-core
		nl invision-ui

		nsll $CURRENT_LOGLEVEL
	}

	nlp () {
		CURRENT_LOGLEVEL=`ngll`
		PROJECT="$*"

		eval ${BASH_ALIASES[$PROJECT]}

		nsll silent
		nl
		nl invision-core
		nl invision-ui
		nl invision-billingoperations
		nl invision-customercare
		nl invision-configuration
		nl invision-documentation
		nl invision-reporting
#		nl invision-starter
		nl invision-security
		nl invision-studio

		nsll $CURRENT_LOGLEVEL
	}

	## Uninstall packages for each of the repos as well as reinstall any global packages
	nua () {
		CURRENT_DIRECTORY="$PWD"

		cd ~ && \
			npm cache clean && \
			rm -fR npm

		npm install -g \
			gulp webpack-dev-server \
			npm-run-all mocha eslint-watch eslint \
			rimraf

		cd ${INVISION_PATH}/.. && \
			rimraf ./{I,i}nvision*/node_modules/

		cd $CURRENT_DIRECTORY || exit
	}
fi