#!/usr/bin/env zsh

# Define custom AWS-related functions

## Authenticate with AWS using the provided profile, via Okta
awsauth() {
    okta-awscli --okta-profile "$1" --profile "$1"

    wait
    echo "\n Successfully authenticated using profile \"$1\". Current identity:\n"
    aws --profile "$1" sts get-caller-identity | bat --language json
    echo "\n"
}
