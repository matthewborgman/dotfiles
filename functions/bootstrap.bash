#!/usr/bin/env bash

# Define custom functions to be used throughout

commandExists () {
	type "$1" &> /dev/null
}

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