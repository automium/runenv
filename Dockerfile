##Download base image ubuntu xenial
FROM ubuntu:focal

MAINTAINER Lorenzo Comotti

##Update packages 
RUN apt -y update

##Install required pakages
RUN apt -y install wget git jq && apt -y --fix-missing install unzip && apt -y --fix-missing install python3-pip && apt -y --fix-missing install git && apt -y --fix-missing install apt-transport-https rsync

##Download terraform binary
RUN wget https://releases.hashicorp.com/terraform/0.14.7/terraform_0.14.7_linux_amd64.zip && unzip terraform_0.14.7_linux_amd64.zip -d /bin/

## add kubernetes repository
RUN wget -qO - https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list && apt -y update 

# Install plugins
RUN apt -y install kubectl=1.18.16-00 && pip3 install ansible==2.9.6 && pip3 install python-consul==1.0.1 && pip3 install hvac

COPY terraform-inventory /bin/terraform-inventory

WORKDIR "/root"

ENTRYPOINT [ "/bin/bash" ]
