#!/usr/bin/env zsh

# Define custom functions to be used throughout

## Decorate builtin `cd` to track which Invision version custom functions (e.g. `invcc`) apply to
## TODO: Refactor `INVISION_VERSION_*` variables usage
# cd () {
#     builtin cd "$@"

#     if [[ $PWD/ = $INVISION_BACKPORT_PATH/* ]]; then
#         INVISION_VERSION=${INVISION_VERSIONS[1]}
#         INVISION_VERSION_NPM_CACHE_PATH=${INVISION_VERSION_NPM_CACHE_PATHS[1]}
#         INVISION_VERSION_NPM_MODULES_PATH=${INVISION_VERSION_NPM_MODULES_PATHS[1]}
#         INVISION_VERSION_PATH=${INVISION_VERSION_PATHS[1]}
#     elif [[ $PWD/ = $INVISION_PATH/* ]]; then
#         INVISION_VERSION=${INVISION_VERSIONS[0]}
#         INVISION_VERSION_NPM_CACHE_PATH=${INVISION_VERSION_NPM_CACHE_PATHS[0]}
#         INVISION_VERSION_NPM_MODULES_PATH=${INVISION_VERSION_NPM_MODULES_PATHS[0]}
#         INVISION_VERSION_PATH=${INVISION_VERSION_PATHS[0]}
#     fi
# }

## Determine whether a command exists for the current platform
commandExists () {
    type "$1" &> /dev/null
}

## Confirm that a command should be peformed on the current Invision version (e.g. "invision-backport")
confirmInvisionVersion () {
    echo -e "\n"
    echo -n "Execute \`"$1"\` on modules for Invision version '${INVISION_VERSION}' (y/N)? "

    while read -r -n 1 ANSWER; do
        if [[ $ANSWER = [YyNn] ]]; then
            [[ $ANSWER = [Yy] ]] && RETURN_VALUE=0
            [[ $ANSWER = [Nn] ]] && RETURN_VALUE=1

            break
        fi
    done

    echo -e "\n"

    return $RETURN_VALUE
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