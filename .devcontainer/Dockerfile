ARG OS_VERSION=20.04
FROM ubuntu:${OS_VERSION} AS base

# Needs to be set to your host user UID and GID
# so that all files created in the container are
# owned by your account
ARG HOST_USER_UID=1000
ARG HOST_USER_GID=1000
ARG USER_NAME=devuser

USER root

WORKDIR /devops

# Create non-root user
RUN set -ex \
  && groupadd -g $HOST_USER_GID $USER_NAME \
  && useradd -lm -u $HOST_USER_UID -g $HOST_USER_GID $USER_NAME
# Create docker group
RUN set -ex \
  && groupadd docker \
  && usermod -aG docker $USER_NAME

# Install base packages
RUN set -ex \
 && apt update \
 && apt-get -y install \
    apt-transport-https \
    bash-completion \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \ 
    jq \
    software-properties-common \
    sudo \
    tmux \
    telnet \
    tree \
    vim \
    unzip

# Configure completion
RUN mkdir -p /etc/bash_completion.d/ && \
    echo -e "\nsource /usr/share/bash-completion/bash_completion" >> ~/.bashrc

# Install MS cert
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

# Install Docker
RUN curl -sSL https://get.docker.com/ | sh

# Install yq
RUN add-apt-repository ppa:rmescandon/yq \
 && apt update \
 && apt install yq -y

# Install git
RUN apt-get -y install git

# Install Node
ARG NODE_VERSION=16.17.0
ARG NPM_VERSION=8.15.0	

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash \
 && apt-get -y install nodejs \
 && npm i -g n \
 && n install ${NODE_VERSION}

# Install Terraform
ARG TERRAFORM_VERSION=1.2.8

RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
 && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
 && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
 && chmod +x terraform \
 && mv terraform /usr/local/bin

# Install Terragrunt
#RUN curl -LO https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 \
# && chmod +x terragrunt_linux_amd64 \
# && mv terragrunt_linux_amd64 /usr/local/bin/terragrunt

# Install Kubectl
ARG KUBECTL_VERSION=1.24.2

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
 && chmod +x kubectl \
 && mv kubectl /usr/local/bin/kubectl \
 # Configure Kubectl completion
 && echo -e "source <(kubectl completion bash)" >> ~/.bashrc \
 && kubectl completion bash >/etc/bash_completion.d/kubectl

# Install Helm
ARG HELM_VERSION=3.9.4

RUN curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
 && tar -xvzf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
 && rm helm-v${HELM_VERSION}-linux-amd64.tar.gz \
 && chmod +x linux-amd64/helm \
 && mv linux-amd64/helm /usr/local/bin/ \ 
 # Configure Helm completion
 && echo -e "source <(helm completion bash)" >> ~/.bashrc \
 && helm completion bash >/etc/bash_completion.d/helm

# Install az CLI
ARG AZ_CLI_VERSION=2.40.0-1

RUN OS_CODENAME=$(lsb_release -cs) \
 && AZ_FULL_VERSION=${AZ_CLI_VERSION}~${OS_CODENAME} \
 && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ ${OS_CODENAME} main" | \
    tee /etc/apt/sources.list.d/azure-cli.list \
 && apt-get update \
 && apt-cache madison azure-cli \
 && apt-get -y install azure-cli=${AZ_FULL_VERSION}

# Install ArgoCD CLI
ARG ARGOCD_VERSION=v2.5.0 # Select desired TAG from https://github.com/argoproj/argo-cd/releases
RUN curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/$ARGOCD_VERSION/argocd-linux-amd64 \
 && sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd \
 && rm argocd-linux-amd64

# Install MS SQL CLI
RUN apt install -y python3-pip \
 && pip install mssql-cli \
 && sed -i 's/python/python3/g' /usr/local/bin/mssql-cli

USER $USER_NAME
