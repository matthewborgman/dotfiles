#!/usr/bin/env zsh

# Define custom AWS-related functions

## Authenticate with AWS using the provided profile, via Okta
awsauth() {
    if [[ -z "$1" ]]; then

        echo "\`awsauth\` requires the name of a Okta/AWS profile to use.\n"
    else
        echo "Retrieving Okta credentials from 1Password...\n"
        1pauth

        wait

        echo "\nAuthenticating with Okta...\n"
        okta-awscli --okta-profile "$1" --profile "$1" --password "$(1prp Okta)"

        wait

        if [[ $? == 0 ]]; then

            local RESULT=$(aws --profile "$1" sts get-caller-identity)

            export AWS_ACCOUNT_ID=$(echo $RESULT | jq -r ".Account")
            export AWS_PROFILE="$1"

            echo "Successfully authenticated using profile \"$1\". Current identity:\n"
            echo $RESULT | bat --language json
        fi
    fi
}
