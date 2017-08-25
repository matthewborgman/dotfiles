#!/usr/bin/env bash

# Define custom Git-related functions

source "${DOTFILES_PATH}/functions/bootstrap.bash"

# NOTE: Adopted from https://github.com/tj/git-extras/blob/master/bin/git-archive-file
garchv () {
	ARCHIVE_NAME=$(basename "$(pwd)")
	BRANCH_FULL_NAME=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
	BRANCH_TYPE_DELIMITER='--'

	if [[ $BRANCH_FULL_NAME = tags* ]]; then

		BRANCH_FULL_NAME=$(git describe)
		CONFIRMATION_MESSAGE="Archive for tag \"${BRANCH_FULL_NAME}\""

		BRANCH_ABBREVIATED_NAME=${BRANCH_FULL_NAME/\//$BRANCH_TYPE_DELIMITER}

		FILENAME=$ARCHIVE_NAME.$BRANCH_ABBREVIATED_NAME.zip
	else

		CONFIRMATION_MESSAGE="Archive for branch \"${BRANCH_FULL_NAME}\""
		VERSION=$(git describe --always --long)

		BRANCH_ABBREVIATED_NAME=${BRANCH_FULL_NAME/\//$BRANCH_TYPE_DELIMITER}

		if [ "$BRANCH_FULL_NAME" = "master" ]; then
			FILENAME=$ARCHIVE_NAME.$VERSION.zip
		else
			FILENAME=$ARCHIVE_NAME.$VERSION.$BRANCH_ABBREVIATED_NAME.zip
		fi
	fi

	OUTPUT=$(pwd)/$FILENAME

	git archive --format zip --output $OUTPUT $BRANCH_FULL_NAME

	echo "$CONFIRMATION_MESSAGE saved to \"$FILENAME\" (`du -h $OUTPUT | cut -f1`)"
}

gc () {
	BRANCH=${@:-${DEVELOPMENT_BRANCH_NAME}}

	if [[ $BRANCH =~ ^[0-9]+$ ]]; then

		NUM_BRANCHES_LIMIT=$((BRANCH + 1))

		BRANCH=$(git for-each-ref --count ${NUM_BRANCHES_LIMIT} --sort=-committerdate refs/heads/ --format="%(refname:short)" | tail -1)
	fi

	git checkout "${BRANCH}"
}

gcm () {
	git commit -m "$*"
}

gcma () {
	git commit -am "$*"
}

# NOTE: Adopted from https://github.com/tj/git-extras/blob/master/bin/git-delta
gdlt () {
	BRANCH=${1:-${DEVELOPMENT_BRANCH_NAME}}
	FILTER=${2:-ACM}

	git diff --name-only --diff-filter=${FILTER} "${BRANCH}"
}

glf () {
	git log -- "$1"
}

glm () {
	GIT_USERNAME=$(git config user.name)
	NUM_COMMITS=${1:-20}

	git log --author="$GIT_USERNAME" --max-count=$NUM_COMMITS
}

# NOTE: Adopted from https://github.com/tj/git-extras/blob/master/bin/git-commits-since
gls () {
	SINCE=${@:-"last week"}

	git log --pretty='%an - %s' --after="@{$SINCE}"
}

# NOTE: Adopted from https://stackoverflow.com/a/6658352
gptch () {
	ANCESTOR=${1:-1}

	git format-patch -${ANCESTOR} HEAD
}

# NOTE: Patches, unless explicitly specified, will be found and applied in alphabetical order by default
gptcha () {
	PATCHES=${@}

	if [ -z "$PATCHES" ]; then

		PATCHES=$(find . -maxdepth 1 -name "*.patch")
		PATCHES=${PATCHES[@]}
	fi

	if [ -n "$PATCHES" ]; then
		git apply $PATCHES
	fi
}

# grhh () {
# 	ANCESTOR=${1:-0}
#
# 	git reset --hard HEAD~$ANCESTOR
# }

grsh () {
	ANCESTOR=${1:-1}

	if [[ $ANCESTOR =~ ^[0-9]+$ ]]; then
		ANCESTOR=HEAD~${ANCESTOR}
	fi

	git reset --soft $ANCESTOR
}

gss () {
	git stash save "$*"
}

gtd () {
	SPECIFIED_TAG=$1

	if [ -z "$SPECIFIED_TAG" ]; then
		SPECIFIED_TAG=$(git describe --abbrev=0)
	fi

	git tag --delete $SPECIFIED_TAG
}

# Define functions for use with Invision
if [ -d "$INVISION_PATH" ]; then

	gpa () {
		DEFAULT_ALIASES=(inv invc inve2e invui)

		ALIASES=("${*:-${DEFAULT_ALIASES[@]}}")
		CURRENT_DIRECTORY="$PWD"

		for i in "${ALIASES[@]}"; do

			CUSTOM_ALIAS=${i}
			CUSTOM_ALIAS_LENGTH=${#CUSTOM_ALIAS}
			CUSTOM_ALIAS_LENGTH=$((CUSTOM_ALIAS_LENGTH+1))

			RESULT=`eval ${BASH_ALIASES[$CUSTOM_ALIAS]} && git fetch --quiet && git merge FETCH_HEAD`

			echo -e "\n"
			echo "$CUSTOM_ALIAS:"
			printf '=%.0s' $(seq 1 $CUSTOM_ALIAS_LENGTH)
			echo -e "\n"
			echo "$RESULT"
		done

		cd $CURRENT_DIRECTORY || exit
	}
fi