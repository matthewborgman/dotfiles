#!/usr/bin/env bash

# NOTE: Adopted from https://github.com/amatellanes/terraform-workspace-prompt
function terraform_prompt () {
    if [ -d ".terraform" ]; then
        workspace="$(command terraform workspace show 2>/dev/null)"

        echo " (${workspace})"
    fi
}