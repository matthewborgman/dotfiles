#!/usr/bin/env bash

# Define functions for use with Invision

source "${DOTFILES_PATH}/functions/bootstrap.bash"

if [ -d "$INVISION_PATH" ]; then

    inv ()      { cd ${INVISION_VERSION_PATH}/invision; }                   # inv:      Change to the Invision directory
    inva ()     { cd ${INVISION_VERSION_PATH}/invision-authentication; }    # inva:     Change to the Invision Authentication directory
    invbo ()    { cd ${INVISION_VERSION_PATH}/invision-billingoperations; } # invbo:    Change to the Invision Billing Operations directory
    invc ()     { cd ${INVISION_VERSION_PATH}/invision-core; }              # invc:     Change to the Invision Core directory
    invcc ()    { cd ${INVISION_VERSION_PATH}/invision-customercare; }      # invcc:    Change to the Invision Customer Care directory
    invcnf ()   { cd ${INVISION_VERSION_PATH}/invision-configuration; }     # invcnf:   Change to the Invision Configuration directory
    invd ()     { cd ${INVISION_VERSION_PATH}/invision-documentation; }     # invd:     Change to the Invision Documentation directory
    invdkr ()   { cd ${INVISION_VERSION_PATH}/invision-docker; }            # invdkr:   Change to the Invision Docker directory
    inve2e ()   { cd ${INVISION_VERSION_PATH}/invision-e2e; }               # inve2e:   Change to the Invision E2E directory
    invr ()     { cd ${INVISION_VERSION_PATH}/invision-reporting; }         # invr:     Change to the Invision Reporting directory
    invsec ()   { cd ${INVISION_VERSION_PATH}/invision-security; }          # invsec:   Change to the Invision Security directory
    invstc ()   { cd ${INVISION_VERSION_PATH}/invision-static; }            # invstc:   Change to the Invision Static directory
    invstr ()   { cd ${INVISION_VERSION_PATH}/invision-starter; }           # invstr:   Change to the Invision Starter directory
    invstu ()   { cd ${INVISION_VERSION_PATH}/invision-studio; }            # invstu:   Change to the Invision Studio directory
    invt ()     { cd ${INVISION_VERSION_PATH}/invision-tools; }             # invt:     Change to the Invision Tools directory
    invui ()    { cd ${INVISION_VERSION_PATH}/invision-ui; }                # invui:    Change to the Invision UI directory

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
        nl invision-authentication
        nl invision-core
        nl invision-ui

        nsll $CURRENT_LOGLEVEL
    }

    nlc () {
        CURRENT_LOGLEVEL=`ngll`
        PROJECT="$*"

        eval $PROJECT

        nsll silent
        nl
        nl invision-core

        nsll $CURRENT_LOGLEVEL
    }

    nlcu () {
        CURRENT_LOGLEVEL=`ngll`
        PROJECT="$*"

        eval $PROJECT

        nsll silent
        nl
        nl invision-core
        nl invision-ui

        nsll $CURRENT_LOGLEVEL
    }

    nlp () {
        CURRENT_LOGLEVEL=`ngll`
        PROJECT="$*"

        eval $PROJECT

        nsll silent
        nl
        nl invision-core
        nl invision-ui
        nl invision-authentication
        nl invision-billingoperations
        nl invision-customercare
        nl invision-configuration
        nl invision-documentation
        nl invision-reporting
#		nl invision-starter
        nl invision-static
        nl invision-security
        nl invision-studio

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



    }
fi