FROM ubuntu:22.04 AS base
USER root

WORKDIR /devops

FROM base AS requirements

RUN apt update \
 && apt-get -y install \
    bash-completion \
    curl \
    gnupg \ 
    software-properties-common \
    tree \
    vim \
    unzip \
    jq

# Configure completion
RUN mkdir -p /etc/bash_completion.d/ && \
    echo -e "\nsource /usr/share/bash-completion/bash_completion" >> ~/.bashrc

# Install Docker
RUN curl -sSL https://get.docker.com/ | sh

# Install yq
RUN add-apt-repository ppa:rmescandon/yq \
 && apt update \
 && apt install yq -y

# Install Node
ENV NODE_VERSION 16.17.0
ENV NPM_VERSION 8.15.0	

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash \
 && apt-get -y install nodejs \
 && npm i -g n \
 && n install ${NODE_VERSION}

# Install Terraform
ENV TERRAFORM_VERSION 1.2.8

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
ENV KUBECTL_VERSION 1.24.2

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
 && chmod +x kubectl \
 && mv kubectl /usr/local/bin/kubectl \
 # Configure Kubectl completion
 && echo -e "source <(kubectl completion bash)" >> ~/.bashrc \
 && kubectl completion bash >/etc/bash_completion.d/kubectl

# Install Helm
ENV HELM_VERSION 3.9.4

RUN curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
 && tar -xvzf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
 && rm helm-v${HELM_VERSION}-linux-amd64.tar.gz \
 && chmod +x linux-amd64/helm \
 && mv linux-amd64/helm /usr/local/bin/ \ 
 # Configure Helm completion
 && echo -e "source <(helm completion bash)" >> ~/.bashrc \
 && helm completion bash >/etc/bash_completion.d/helm

# Install az CLI
ENV AZ_CLI_VERSION 2.40.0-1~jammy

RUN apt-get -y install ca-certificates curl apt-transport-https lsb-release gnupg \
 && curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null \
 && AZ_REPO=$(lsb_release -cs) \
 && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
    tee /etc/apt/sources.list.d/azure-cli.list \
 && apt-get update \
 && apt-cache madison azure-cli \
 && apt-get -y install azure-cli=${AZ_CLI_VERSION}

# Install git
RUN apt-get -y install git

#USER rootless
#ENV DOCKER_HOST=unix:///var/run/user/1000/docker.sock