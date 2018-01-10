#!/usr/bin/env bash

# Define custom Git-related functions

source "${DOTFILES_PATH}/functions/bootstrap.bash"

## Archive the current branch or tag for the current repo
## NOTE: Adopted from https://github.com/tj/git-extras/blob/master/bin/git-archive-file
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

## Delete the given branch
gbd () {
	BRANCH="$*"

	if [ -z $BRANCH ]; then

		echo '`gbd` requires the name of the branch to be deleted.'
	else

		git branch -d $BRANCH
	fi
}

## Checkout the given branch or relative commit, defaulting to the "development" branch if none specified
gc () {
	BRANCH=${@:-${DEVELOPMENT_BRANCH_NAME}}

	if [[ $BRANCH =~ ^[0-9]+$ ]]; then

		NUM_BRANCHES_LIMIT=$((BRANCH + 1))

		BRANCH=$(git for-each-ref --count ${NUM_BRANCHES_LIMIT} --sort=-committerdate refs/heads/ --format="%(refname:short)" | tail -1)
	fi

	git checkout "${BRANCH}"
}

## Commit the staged files using the given message
gcm () {
	git commit -m "$*"
}

# Ammend the last commit using the given message
gcma () {
	git commit -am "$*"
}

## List files that differ in the current branch from the given branch, defaulting to the "development" branch if none specified
## NOTE: Adopted from https://github.com/tj/git-extras/blob/master/bin/git-delta
gdlt () {
	BRANCH=${1:-${DEVELOPMENT_BRANCH_NAME}}
	FILTER=${2:-ACM}

	git diff --name-only --diff-filter=${FILTER} "${BRANCH}"
}

## Display a log of commits for the given file
glf () {
	git log -- "$1"
}

## Display a log of commits by the current user
glm () {
	GIT_USERNAME=$(git config user.name)
	NUM_COMMITS=${1:-20}

	git log --author="$GIT_USERNAME" --max-count=$NUM_COMMITS
}

## Display a log of commits since a given time, defaulting to last week if none specified
## NOTE: Adopted from https://github.com/tj/git-extras/blob/master/bin/git-commits-since
gls () {
	SINCE=${@:-"last week"}

	git log --pretty='%an - %s' --after="@{$SINCE}"
}

## Peform a dry-run of merging the given branch into the current one
gmdr () {
	BRANCH="$*"

	if [ -z $BRANCH ]; then

		echo '`gmdr` requires the name of the branch to be merged in the dry-run.'
	else

		git merge --no-commit --no-ff $BRANCH && git merge --abort
	fi
}

## Create a patch from commits to the current branch since the given commit or relative to the most recent commit, defaulting to the 1 prior if none specified
## NOTE: Adopted from https://stackoverflow.com/a/6658352
gptch () {
	ANCESTOR=${1:-1}

	if [[ $ANCESTOR =~ $SHA1_REGEX ]]; then
		git format-patch $ANCESTOR
	else
		git format-patch -${ANCESTOR} HEAD
	fi
}

## Apply the given patches to the current branch, defaulting to searching the current directory for any if none specified
## NOTE: Patches, unless explicitly specified, will be found and applied in alphabetical order by default
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

grhh () {
	ANCESTOR=${1:-0}

	if [[ $ANCESTOR =~ ^[0-9]+$ ]]; then
		ANCESTOR=HEAD~${ANCESTOR}
	fi

	git reset --hard $ANCESTOR
}

## Reset the current branch to the given commit relative to the most recent, defaulting to the 1 prior if none specified, but leaving the index and working tree untouched
grsh () {
	ANCESTOR=${1:-1}

	if [[ $ANCESTOR =~ ^[0-9]+$ ]]; then
		ANCESTOR=HEAD~${ANCESTOR}
	fi

	git reset --soft $ANCESTOR
}

## Drop the given stash from the current repo
gsd () {
	SPECIFIED_STASH=${1:-'stash@{0}'}

	git stash drop $SPECIFIED_STASH
}

## Stash any modifications, including untracked files, to the current repo
gss () {
	git add . && git stash save "$*"
}

## Delete the given tag, defaulting to the most recent if none specified
gtd () {
	SPECIFIED_TAG=$1

	if [ -z "$SPECIFIED_TAG" ]; then
		SPECIFIED_TAG=$(git describe --abbrev=0)
	fi

	git tag --delete $SPECIFIED_TAG
}

# Define functions for use with Invision
if [ -d "$INVISION_PATH" ]; then

	## Pull into each of the repos
	gpa () {
		CURRENT_DIRECTORY="$PWD"

		for i in "${INVISION_REPO_ALIASES[@]}"; do

			CUSTOM_ALIAS=${i}
			CUSTOM_ALIAS_LENGTH=${#CUSTOM_ALIAS}
			CUSTOM_ALIAS_LENGTH=$((CUSTOM_ALIAS_LENGTH+1))

			eval ${BASH_ALIASES[$CUSTOM_ALIAS]}

			CURRENT_BRANCH=$(gbn)

			if [ "$DEVELOPMENT_BRANCH_NAME" = "$CURRENT_BRANCH" ]; then
				RESULT=`git fetch --quiet && git merge FETCH_HEAD`
			else
				RESULT="Branch '$DEVELOPMENT_BRANCH_NAME' is not checked-out. Skipping..."
			fi

			echo -e "\n"
			echo "$CUSTOM_ALIAS:"
			printf '=%.0s' $(seq 1 $CUSTOM_ALIAS_LENGTH)
			echo -e "\n"
			echo "$RESULT"
		done

		cd $CURRENT_DIRECTORY || exit
	}
fi