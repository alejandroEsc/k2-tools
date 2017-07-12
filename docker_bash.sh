#!/bin/bash

function terraform() {

TERRAFORM_VERSION=$1
TF_PROVIDEREXECUTE_VERSION=$2
TF_COREOSBOX_VERSION=$3
TF_DISTROIMAGE_VERSION=$4

#Installing Terraform binary
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && mv terraform /usr/bin/

# Adding Terraform Provider Execute addon
wget https://github.com/samsung-cnct/terraform-provider-execute/releases/download/${TF_PROVIDEREXECUTE_VERSION}/terraform-provider-execute_linux_amd64.tar.gz && \
tar -zxvf terraform-provider-execute_linux_amd64.tar.gz && rm terraform-provider-execute_linux_amd64.tar.gz && mv terraform-provider-execute /usr/bin/

# Adding Terraform CoreOS Box addon
wget https://github.com/samsung-cnct/terraform-provider-coreosbox/releases/download/${TF_COREOSBOX_VERSION}/terraform-provider-coreosbox_linux_amd64.tar.gz && \
tar -zxvf terraform-provider-coreosbox_linux_amd64.tar.gz && rm terraform-provider-coreosbox_linux_amd64.tar.gz && mv terraform-provider-coreosbox /usr/bin/

# Adding Terraform Distro Image Selector addon
wget https://github.com/samsung-cnct/terraform-provider-distroimage/releases/download/${TF_DISTROIMAGE_VERSION}/terraform-provider-distroimage_linux_amd64.tar.gz && \
tar -zxvf terraform-provider-distroimage_linux_amd64.tar.gz && rm terraform-provider-distroimage_linux_amd64.tar.gz && mv terraform-provider-distro /usr/bin/
}




