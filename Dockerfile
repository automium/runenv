##Download base image ubuntu focal
FROM ubuntu:focal

MAINTAINER cloudfactory@irideos.it

# Set Timezone
ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

##Install required pakages
RUN apt -y update && apt -y install wget git jq bc curl unzip python3-pip apt-transport-https rsync python3-openstackclient

##Download terraform binary
RUN wget https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip && unzip terraform_0.14.7_linux_amd64.zip -d /bin/

## add kubernetes repository
RUN wget -qO - https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list && apt -y update 

# Install plugins
RUN apt -y install kubectl=1.18.16-00 && pip3 install ansible==2.9.6 && pip3 install python-consul==1.0.1 && pip3 install hvac

COPY terraform-inventory /bin/terraform-inventory

# Add providers
COPY init.tf /root/init.tf
RUN terraform init && rm init.tf

WORKDIR "/root"
