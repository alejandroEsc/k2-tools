#!/bin/bash

TERRAFORM_VERSION=0.8.6
TF_COREOSBOX_VERSION=v0.0.3
TF_DISTROIMAGE_VERSION=v0.0.1
TF_PROVIDEREXECUTE_VERSION=v0.0.4

ETCD_VERSION=v3.1.0

K8S_VERSION=v1.6.7
K8S_HELM_VERSION=v2.5.0

K8S_VERSION_1_4=v1.4.12
K8S_VERSION_1_5=v1.5.7
K8S_VERSION_1_6=v1.6.7

K8S_HELM_VERSION_1_4=v2.1.3
K8S_HELM_VERSION_1_5=v2.3.1
K8S_HELM_VERSION_1_6=v2.5.0

#Latest version of tools
LATEST=v1.6
K8S_VERSION_LATEST=$K8S_VERSION_1_6
K8S_HELM_VERSION_LATEST=$K8S_HELM_VERSION_1_6

function doKubernetes () {
    mkdir -p /opt/cnct/kubernetes/v1.4/bin \
    /opt/cnct/kubernetes/v1.5/bin \
    /opt/cnct/kubernetes/v1.6/bin \
    /etc/helm/plugins && \
    ln -s /opt/cnct/kubernetes/${LATEST} /opt/cnct/kubernetes/latest
}
function doTerraform() {
    echo 'Installing Terraform binary'
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && mv terraform /usr/bin/

    echo 'Adding Terraform Provider Execute addon'
    wget https://github.com/samsung-cnct/terraform-provider-execute/releases/download/${TF_PROVIDEREXECUTE_VERSION}/terraform-provider-execute_linux_amd64.tar.gz && \
    tar -zxvf terraform-provider-execute_linux_amd64.tar.gz && rm terraform-provider-execute_linux_amd64.tar.gz && mv terraform-provider-execute /usr/bin/

    echo 'Adding Terraform CoreOS Box addon'
    wget https://github.com/samsung-cnct/terraform-provider-coreosbox/releases/download/${TF_COREOSBOX_VERSION}/terraform-provider-coreosbox_linux_amd64.tar.gz && \
    tar -zxvf terraform-provider-coreosbox_linux_amd64.tar.gz && rm terraform-provider-coreosbox_linux_amd64.tar.gz && mv terraform-provider-coreosbox /usr/bin/

    echo 'Adding Terraform Distro Image Selector addon'
    wget https://github.com/samsung-cnct/terraform-provider-distroimage/releases/download/${TF_DISTROIMAGE_VERSION}/terraform-provider-distroimage_linux_amd64.tar.gz && \
    tar -zxvf terraform-provider-distroimage_linux_amd64.tar.gz && rm terraform-provider-distroimage_linux_amd64.tar.gz && mv terraform-provider-distro /usr/bin/
}



function doKubectl() {
    wget https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION_1_4}/bin/linux/amd64/kubectl && \
    chmod a+x kubectl && \
    mv kubectl /opt/cnct/kubernetes/v1.4/bin && \

    wget https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION_1_5}/bin/linux/amd64/kubectl && \
    chmod a+x kubectl && \
    mv kubectl /opt/cnct/kubernetes/v1.5/bin

    wget https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION_1_6}/bin/linux/amd64/kubectl && \
    chmod a+x kubectl && \
    mv kubectl /opt/cnct/kubernetes/v1.6/bin && \
    ln -s /opt/cnct/kubernetes/${LATEST}/bin/kubectl /usr/bin/
}

function doHelm() {
    wget http://storage.googleapis.com/kubernetes-helm/helm-${K8S_HELM_VERSION_1_4}-linux-amd64.tar.gz  && \
    tar -zxvf helm-${K8S_HELM_VERSION_1_4}-linux-amd64.tar.gz  && \
    mv linux-amd64/helm /opt/cnct/kubernetes/v1.4/bin/helm  && \
    rm -rf linux-amd64 helm-${K8S_HELM_VERSION_1_4}-linux-amd64.tar.gz

    wget http://storage.googleapis.com/kubernetes-helm/helm-${K8S_HELM_VERSION_1_5}-linux-amd64.tar.gz  && \
    tar -zxvf helm-${K8S_HELM_VERSION_1_5}-linux-amd64.tar.gz  && \
    mv linux-amd64/helm /opt/cnct/kubernetes/v1.5/bin/helm  && \
    rm -rf linux-amd64 helm-${K8S_HELM_VERSION_1_5}-linux-amd64.tar.gz && \
    ln -s /opt/cnct/kubernetes/v1.5/bin/helm /usr/bin/

    wget http://storage.googleapis.com/kubernetes-helm/helm-${K8S_HELM_VERSION_1_6}-linux-amd64.tar.gz  && \
    tar -zxvf helm-${K8S_HELM_VERSION_1_6}-linux-amd64.tar.gz  && \
    mv linux-amd64/helm /opt/cnct/kubernetes/v1.6/bin/helm  && \
    rm -rf linux-amd64 helm-${K8S_HELM_VERSION_1_6}-linux-amd64.tar.gz
}

function doEtcd() {
    wget https://github.com/coreos/etcd/releases/download//${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz && \
    tar -zxvf etcd-${ETCD_VERSION}-linux-amd64.tar.gz && \
    cp etcd-${ETCD_VERSION}-linux-amd64/etcdctl /usr/local/bin && \
    rm -rf etcd-${ETCD_VERSION}-linux-amd64/
}


function doGoogleCloud() {
    wget https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip && \
    unzip google-cloud-sdk.zip && \
    rm google-cloud-sdk.zip
    google-cloud-sdk/install.sh --usage-reporting=false --path-update=false --bash-completion=false


    # Disable updater check for the whole installation.
    # Users won't be bugged with notifications to update to the latest version of gcloud.
    google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

    # Disable updater completely.
    # Running `gcloud components update` doesn't really do anything in a union FS.
    # Changes are lost on a subsequent run.
    sed -i -- 's/\"disable_updater\": false/\"disable_updater\": true/g' /google-cloud-sdk/lib/googlecloudsdk/core/config.json
}

