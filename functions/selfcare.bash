#!/usr/bin/env bash

# Define functions for use with SelfCare

source "${DOTFILES_PATH}/functions/bootstrap.bash"

if [ -d "$SELFCARE_PATH" ]; then

    slf ()      { cd ${SELFCARE_PATH}/selfcare; }       # slf:      Change to the SelfCare directory
    slfc ()     { cd ${SELFCARE_PATH}/selfcare-core; }  # slfc:     Change to the SelfCare Core directory
    slfe2e ()   { cd ${SELFCARE_PATH}/selfcare-e2e; }   # slfe2e:   Change to the SelfCare E2E directory
    slfui ()    { cd ${SELFCARE_PATH}/selfcare-ui; }    # slfui:    Change to the SelfCare UI directory
fi