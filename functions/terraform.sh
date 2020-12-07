#!/usr/bin/env zsh

# Define custom Terraform-related functions

if [ -d "$INVISION_PATH" ]; then

    generateInvEnvTfVars() {
        echo "environment_id = \"$(terraform workspace show)\"" > invision_environment.tfvars
    }

    removeInvEnvTfVars() {
        rm invision_environment.tfvars
    }

    tfd () {
        generateInvEnvTfVars && \
        terraform destroy -refresh=true && \
        removeInvEnvTfVars
    }

    tfi () {
        terraform import $*
    }

    tfpa () {
        terraform apply plan.tfplan
    }

    tfpp () {
        generateInvEnvTfVars && \
        terraform plan -out plan.tfplan && \
        removeInvEnvTfVars
    }

    tfpr () {
        generateInvEnvTfVars && \
        terraform refresh && \
        removeInvEnvTfVars
    }

    tfpv () {
        generateInvEnvTfVars && \
        terraform validate && \
        removeInvEnvTfVars
    }

    tfwsi () {
        terraform init \
            -backend-config="profile=${AWS_PROFILE}" \
            -backend-config="shared_credentials_file=~/.aws/credentials" \
            -backend-config="bucket=terraform-${AWS_ACCOUNT_ID}" \
            -backend-config="region=us-east-1"
    }
fi