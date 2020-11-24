#!/usr/bin/env zsh

# Define functions for use with Invision

source "${DOTFILES_PATH}/functions/bootstrap.sh"

if [ -d "$INVISION_PATH" ]; then

    inva ()     { cd ${INVISION_VERSION_PATH}/Authentication; }    # inva:     Change to the Invision Authentication directory
    invbo ()    { cd ${INVISION_VERSION_PATH}/Billing; }           # invbo:    Change to the Invision Billing Operations directory
    invc ()     { cd ${INVISION_VERSION_PATH}/Core; }              # invc:     Change to the Invision Core directory
    invcc ()    { cd ${INVISION_VERSION_PATH}/CustomerCare; }      # invcc:    Change to the Invision Customer Care directory
    invcnf ()   { cd ${INVISION_VERSION_PATH}/Configuration; }     # invcnf:   Change to the Invision Configuration directory
    invd ()     { cd ${INVISION_VERSION_PATH}/Documentation; }     # invd:     Change to the Invision Documentation directory
    invdkr ()   { cd ${INVISION_VERSION_PATH}/docker; }            # invdkr:   Change to the Invision Docker directory
    inve2e ()   { cd ${INVISION_VERSION_PATH}/E2E; }               # inve2e:   Change to the Invision E2E directory
    invr ()     { cd ${INVISION_VERSION_PATH}/Reporting; }         # invr:     Change to the Invision Reporting directory
    invrct ()   { cd ${INVISION_VERSION_PATH}/invision; }            # invrct:   Change to the Invision React directory
    invsec ()   { cd ${INVISION_VERSION_PATH}/Security; }          # invsec:   Change to the Invision Security directory
    invstc ()   { cd ${INVISION_VERSION_PATH}/Static; }            # invstc:   Change to the Invision Static directory
    invstr ()   { cd ${INVISION_VERSION_PATH}/Starter; }           # invstr:   Change to the Invision Starter directory
    invstu ()   { cd ${INVISION_VERSION_PATH}/Studio; }            # invstu:   Change to the Invision Studio directory
    invt ()     { cd ${INVISION_VERSION_PATH}/Tools; }             # invt:     Change to the Invision Tools directory
    invui ()    { cd ${INVISION_VERSION_PATH}/UI; }                # invui:    Change to the Invision UI directory

    ## Add a distribution tag to the given module and version
    ndta () {
        local MODULE="$1"
        local TAG="$3"
        local VERSION="$2"

        if [[ ! "$MODULE" =~ ^invision ]]; then
            MODULE="invision-$MODULE"
        fi

        echo "Adding distribution tag for '${MODULE}'..."
        npm dist-tag --registry https://pkgs.dev.azure.com/Ascendon/Invision/_packaging/invision/npm/registry/ add "${MODULE}@${VERSION}" $TAG
    }

    ## List distribution tags for given module
    ndtv () {
        local DEFAULT_MODULES="Authentication Core E2E UI"
        local MODULES="$*"

        if [ -z $MODULES ]; then
            MODULES=$DEFAULT_MODULES
        fi

        read -r -A STANDARDIZED_MODULES <<< "$MODULES"

        for i in "${STANDARDIZED_MODULES[@]}"; do
            local FORMATTED_MODULE=${i}

            if [[ ! "$FORMATTED_MODULE" =~ ^invision ]]; then
                FORMATTED_MODULE="invision-${FORMATTED_MODULE}"
            fi

            echo "Retrieving distribution tags for '${FORMATTED_MODULE}'..."
            npm view --registry https://pkgs.dev.azure.com/Ascendon/Invision/_packaging/invision/npm/registry/ $FORMATTED_MODULE dist-tags
        done
    }

    ## Install packages for each of the repos
    nia () {
        CURRENT_DIRECTORY="$PWD"

        if confirmInvisionVersion 'nia'; then

            for i in "${INVISION_REPO_ALIASES[@]}"; do

                CUSTOM_ALIAS=${i}
                CUSTOM_ALIAS_LENGTH=${#CUSTOM_ALIAS}
                CUSTOM_ALIAS_LENGTH=$((CUSTOM_ALIAS_LENGTH+1))

                RESULT=`eval $CUSTOM_ALIAS && ni`

                echo -e "\n"
                echo "$CUSTOM_ALIAS:"
                printf '=%.0s' $(seq 1 $CUSTOM_ALIAS_LENGTH)
                echo -e "\n"
                echo "$RESULT"
            done
        else
            echo 'Aborted `nia` due to incorrect Invision version selected...'
        fi

        cd $CURRENT_DIRECTORY || exit
    }

    ## Add links for each of the repos and link between them
    nla () {
        CURRENT_DIRECTORY="$PWD"

        if confirmInvisionVersion 'nla'; then

            # TODO: Halt processing if `nua` is cancelled or errors
#           nua

            for i in "${INVISION_REPO_ALIASES[@]}"; do

                CUSTOM_ALIAS=${i}
                CUSTOM_ALIAS_LENGTH=${#CUSTOM_ALIAS}
                CUSTOM_ALIAS_LENGTH=$((CUSTOM_ALIAS_LENGTH+1))

                case "$CUSTOM_ALIAS" in
                    "inv")
                        eval $CUSTOM_ALIAS
                        nlp $CUSTOM_ALIAS
                        ;;
                    "inva")
                        eval $CUSTOM_ALIAS
                        nlcu
                        ;;
                    "invc")
                        eval $CUSTOM_ALIAS
                        nl
                        ;;
                    "inve2e")
                        eval $CUSTOM_ALIAS
#    					npm run install:webDriver
                        ./node_modules/.bin/webdriver-manager update
                        nlp $CUSTOM_ALIAS
                        nl invision
                        ;;
                    "invui")
                        nlc $CUSTOM_ALIAS
                        ;;
                    *)
                        nlacu $CUSTOM_ALIAS
                        ;;
                esac

                echo -e "\n"
                echo "$CUSTOM_ALIAS:"
                printf '=%.0s' $(seq 1 $CUSTOM_ALIAS_LENGTH)
                echo -e "\n"
                echo 'Linked'
            done
        else
            echo 'Aborted `nla` due to incorrect Invision version selected...'
        fi

        cd $CURRENT_DIRECTORY || exit
    }

    nlacu () {
        CURRENT_LOGLEVEL=`ngll`
        PROJECT="$*"

        eval $PROJECT

        nsll silent
        nl
        nl Authentication
        nl Core
        nl UI

        nsll $CURRENT_LOGLEVEL
    }

    nlc () {
        CURRENT_LOGLEVEL=`ngll`
        PROJECT="$*"

        eval $PROJECT

        nsll silent
        nl
        nl Core

        nsll $CURRENT_LOGLEVEL
    }

    nlcu () {
        CURRENT_LOGLEVEL=`ngll`
        PROJECT="$*"

        eval $PROJECT

        nsll silent
        nl
        nl Core
        nl UI

        nsll $CURRENT_LOGLEVEL
    }

    nlp () {
        CURRENT_LOGLEVEL=`ngll`
        PROJECT="$*"

        eval $PROJECT

        nsll silent
        nl
        nl Core
        nl UI
        nl Authentication
        nl Billing
        nl CustomerCare
        nl Configuration
        nl Documentation
        nl Reporting
#		nl Starter
        nl Static
        nl Security
        nl Studio

        nsll $CURRENT_LOGLEVEL
    }

    ## Uninstall packages for each of the repos as well as reinstall any global packages
    nua () {
        CURRENT_DIRECTORY="$PWD"

        if confirmInvisionVersion 'nua'; then

             npm cache clean -f $INVISION_VERSION_NPM_CACHE_PATH && \
                rm -fR $INVISION_VERSION_NPM_MODULES_PATH

            npm install -g \
                gulp webpack-dev-server \
                npm-run-all mocha eslint-watch eslint \
                rimraf

            rimraf "${INVISION_VERSION_PATH}/{I,i}nvision*/node_modules/"

            cd $CURRENT_DIRECTORY
        else
            echo 'Aborted `nua` due to incorrect Invision version selected...'
        fi
    }
fi