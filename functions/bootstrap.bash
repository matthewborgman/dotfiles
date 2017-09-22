#!/usr/bin/env bash

# Define custom functions to be used throughout

## Determine whether a command exists for the current platform
commandExists () {
	type "$1" &> /dev/null
}

## Determine the current platform (e.g. OSX or Windows)
detectPlatform () {

	PLATFORM=
	UNAME_RESULT=`uname -s`

	case $UNAME_RESULT in
		CYGWIN*)
			PLATFORM=linux-win
		;;
		Darwin*)
			PLATFORM=mac
		;;
		FreeBSD*)
			PLATFORM=freebsd
		;;
		Linux*)
			PLATFORM=linux
		;;
		MINGW*)
			PLATFORM=linux-win
		;;
		MSYS*)
			PLATFORM=linux-win
		;;
		Windows*)
			PLATFORM=windows
		;;
		*)
			PLATFORM=unknown
		;;
	esac

	echo $PLATFORM
}