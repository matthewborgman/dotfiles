#!/usr/bin/env bash

# Define custom Terraform-related functions

if [ -d "$INVISION_PATH" -o -d "$SELFCARE_PATH" ]; then

    tfpa () {
        AWS_PROFILE=ascendondev terraform apply plan.tfplan
    }

    tfpp () {
        local WORKSPACE=$(determineProjectWorkspace)
        local WORKSPACE_NAMES_FILE="${WORKSPACE}_app_names.tfvars"
        local WORKSPACE_VERSIONS_FILE="${WORKSPACE}_app_versions.tfvars"

        AWS_PROFILE=ascendondev terraform plan \
            -var="environment_id=$(terraform workspace show)" \
            -var-file="$WORKSPACE_NAMES_FILE" \
            -var-file="$WORKSPACE_VERSIONS_FILE" \
            -out plan.tfplan
    }

    tfpr () {
        local WORKSPACE="$(determineProjectWorkspace)"
        local WORKSPACE_NAMES_FILE="${WORKSPACE}_app_names.tfvars"
        local WORKSPACE_VERSIONS_FILE="${WORKSPACE}_app_versions.tfvars"

        AWS_PROFILE=ascendondev terraform refresh \
            -var="environment_id=$(terraform workspace show)" \
            -var-file="$WORKSPACE_NAMES_FILE" \
            -var-file="$WORKSPACE_VERSIONS_FILE"
    }

    tfpv () {
        local WORKSPACE="$(determineProjectWorkspace)"
        local WORKSPACE_NAMES_FILE="${WORKSPACE}_app_names.tfvars"
        local WORKSPACE_VERSIONS_FILE="${WORKSPACE}_app_versions.tfvars"

        AWS_PROFILE=ascendondev terraform validate \
            -var="environment_id=$(terraform workspace show)" \
            -var-file="$WORKSPACE_NAMES_FILE" \
            -var-file="$WORKSPACE_VERSIONS_FILE"
    }

    tfwsi () {
        AWS_PROFILE=ascendondev terraform init \
            -backend-config="profile=ascendondev" \
            -backend-config="shared_credentials_file=~/.aws/credentials" \
            -backend-config="bucket=terraform-109628516527" \
            -backend-config="region=us-east-1"
    }
fi