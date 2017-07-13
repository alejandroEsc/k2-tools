FROM alpine:3.6
MAINTAINER Michael Venezia <mvenezia@gmail.com>

ENV     GCLOUD_SDK_VERSION=128.0.0
ENV     GCLOUD_SDK_URL=https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz
ENV     CLOUDSDK_PYTHON_SITEPACKAGES 1
        # google cloud kubectl is superceeded by downloaded kubectl
ENV     PATH $PATH:/google-cloud-sdk/bin

ENV     GOPATH /go
ENV     GO15VENDOREXPERIMENT 1

ENV     HELM_HOME=/etc/helm
ENV     HELM_PLUGIN=/etc/helm/plugins

# Prepping Alpine

ADD     /alpine-builds /alpine-builds
ADD     dockerfile_script.sh /dockerfile_script.sh

# Python / ansible addon work
ADD     requirements.txt /requirements.txt
ADD     imagerun.sh /imagerun.sh
ADD     gcloud_tree.py /gcloud_tree.py
ADD     k2dryrun.sh /k2dryrun.sh
        # Adding baseline alpine packages
RUN     apk update && apk add libffi-dev openssl-dev python bash wget py-pip py-cffi py-cryptography unzip zip make git && \
    	/alpine-builds/build-docker.sh && rm -rf /alpine-builds &&  rm -rfv /var/cache/apk/*

# wget
RUN     apk update && apk add ca-certificates wget &&  rm -rfv /var/cache/apk/*

        # Adding AWS CLI
RUN     pip install awscli

# k2 and kubernetes related items.
RUN     source /dockerfile_script.sh && \
        doTerraform && \
        doGoogleCloud && \
        doEtcd && \
        doKubernetes && \
        doKubectl && \
        doHelm

RUN     /imagerun.sh
RUN     appr plugins install helm && rm /etc/helm/plugins/*.gz

# Crash application
RUN     wget https://github.com/samsung-cnct/k2-crash-application/releases/download/0.1.0/k2-crash-application_0.1.0_linux_amd64.tar.gz  && \
        tar -zxvf k2-crash-application_0.1.0_linux_amd64.tar.gz  && \
        mv k2-crash-application /usr/bin/k2-crash-application && \
        rm -rf k2-crash-application_0.1.0_linux_amd64.tar.gz
