#!/usr/bin/env zsh

# Define custom Terraform-related aliases

source "${DOTFILES_PATH}/functions/bootstrap.sh"

if commandExists terraform; then

    alias tffu='terraform force-unlock' # tffu: Unlock Terrafom state
    alias tfs='terraform state'         # tfs:  Manage state
    alias tfv='terraform validate'      # tfv:  Validate Terraform files
    alias tfws='terraform workspace'    # tfws: Manage workspaces
fi