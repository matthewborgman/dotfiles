#!/usr/bin/env zsh

# Define custom AWS-related functions

## Authenticate with AWS using the provided profile, via Okta
awsauth() {
    if [[ -z "$1" ]]; then

        echo '`awsauth` requires the name of a Okta/AWS profile to use.'
    else

        okta-awscli --okta-profile "$1" --profile "$1"

        wait

        if [[ $? == 0 ]]; then

            local RESULT=$(aws --profile "$1" sts get-caller-identity)

            export AWS_ACCOUNT_ID=$(echo $RESULT | jq -r ".Account")
            export AWS_PROFILE="$1"

            echo "\n Successfully authenticated using profile \"$1\". Current identity:\n"
            echo $RESULT | bat --language json
            echo "\n"
        fi
    fi
}
