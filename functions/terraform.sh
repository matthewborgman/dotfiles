#!/usr/bin/env zsh

# Define custom Terraform-related functions

if [ -d "$INVISION_PATH" ]; then

    tfd () {
        local NAMES_FILE="invision_app_names.tfvars"
        local VERSIONS_FILE="invision_app_versions.tfvars"

        terraform destroy \
            -refresh=true \
            -var="environment_id=$(terraform workspace show)" \
            -var-file="$NAMES_FILE" \
            -var-file="$VERSIONS_FILE"
    }

    tfi () {
        terraform import $*
    }

    tfpa () {
        terraform apply plan.tfplan
    }

    tfpp () {
        local NAMES_FILE="invision_app_names.tfvars"
        local VERSIONS_FILE="invision_app_versions.tfvars"

        terraform plan \
            -var="environment_id=$(terraform workspace show)" \
            -var-file="$NAMES_FILE" \
            -var-file="$VERSIONS_FILE" \
            -out plan.tfplan
    }

    tfpr () {
        local NAMES_FILE="invision_app_names.tfvars"
        local VERSIONS_FILE="invision_app_versions.tfvars"

        terraform refresh \
            -var="environment_id=$(terraform workspace show)" \
            -var-file="$NAMES_FILE" \
            -var-file="$VERSIONS_FILE"
    }

    tfpv () {
        local NAMES_FILE="invision_app_names.tfvars"
        local VERSIONS_FILE="invision_app_versions.tfvars"

        terraform validate \
            -var="environment_id=$(terraform workspace show)" \
            -var-file="$NAMES_FILE" \
            -var-file="$VERSIONS_FILE"
    }

    tfwsi () {
        terraform init \
            -backend-config="profile=${AWS_PROFILE}" \
            -backend-config="shared_credentials_file=~/.aws/credentials" \
            -backend-config="bucket=terraform-${AWS_ACCOUNT_ID}" \
            -backend-config="region=us-east-1"
    }
fi