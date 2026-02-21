#!/bin/bash
set -euo pipefail

DO_JAVA=false
DO_JENKINS=false
DO_TERRAFORM=false
DO_DOCKER=false
DO_KUBERNETES=false
DO_SECURITY=false
DO_MONITORING=false




if $JAVA; then
sudo apt install openjdk-17-jre -y
java --version
fi


if $DO_JENKINS; then
echo "Installing Java 17 + Jenkins LTS..."
sudo yum install -y java-17-amazon-corretto-devel
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum install -y jenkins
sudo systemctl enable jenkins --now
fi


if $AWS_CLI; then
sudo apt update
sudo apt install -y unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
fi


if $DO_TERRAFORM; then
echo "Installing latest Terraform..."
VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r .current_version)
wget -q https://releases.hashicorp.com/terraform/$$ {VERSION}/terraform_ $${VERSION}*linux_amd64.zip
unzip -qo terraform*${VERSION}*linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform*${VERSION}_linux_amd64.zip
fi





echo "Installation complete!"
