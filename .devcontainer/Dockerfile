FROM mcr.microsoft.com/azure-cli:2.40.0 AS base

ENV TERRAFORM_VERSION 1.2.8
ENV KUBECTL_VERSION 1.24.2
ENV HELM_VERSION 3.9.4
# TODO: Create new image that installs az CLI and node/npm/nvm
ENV AZ_CLI_VERSION 2.39.0
ENV NODE_VERSION 16.13.1

WORKDIR /devops

FROM base AS requirements

RUN apk update \
 && apk add bash-completion \
            gnupg \ 
            tree \
            vim

# Configure completion
RUN mkdir -p /etc/bash_completion.d/
RUN echo -e "\nsource /usr/share/bash-completion/bash_completion" >> ~/.bashrc

FROM requirements AS terraform

# TODO: Install az extensions
#az extensions 

# Install Terraform
RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN chmod +x terraform
RUN mv terraform /usr/local/bin

# Install Terragrunt
RUN curl -LO https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64
RUN chmod +x terragrunt_linux_amd64
RUN mv terragrunt_linux_amd64 /usr/local/bin/terragrunt

FROM terraform AS kubernetes

# Install Kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl
RUN chmod +x kubectl
RUN mv kubectl /usr/local/bin/kubectl

# Configure Kubectl completion
RUN echo -e "source <(kubectl completion bash)" >> ~/.bashrc
RUN kubectl completion bash >/etc/bash_completion.d/kubectl

# Install Helm
RUN curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz
RUN tar -xvzf helm-v${HELM_VERSION}-linux-amd64.tar.gz
RUN rm helm-v${HELM_VERSION}-linux-amd64.tar.gz
RUN chmod +x linux-amd64/helm
RUN mv linux-amd64/helm /usr/local/bin/

# Configure Helm completion
RUN echo -e "source <(helm completion bash)" >> ~/.bashrc
RUN helm completion bash >/etc/bash_completion.d/helm
