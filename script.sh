#!/bin/bash
set -euo pipefail

DO_JAVA=false
DO_JENKINS=false
DO_MAVEN=false
DO_SONARQUBE=false
DO_DOCKER=false
DO_TRIVY=false
DO_JFROG=false
DO_TERRAFORM=false
DO_KUBERNETES=false
DO_SECURITY=false
DO_MONITORING=false




if $JAVA; then
sudo apt install openjdk-17-jre -y
java --version
fi


if $DO_JENKINS; then
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins
fi


if $AWS_CLI; then
sudo apt update
sudo apt install -y unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
fi

if $MAVEN; then
sudo apt update -y
sudo apt install maven -y
mvn -version
fi



if $SONARQUBE; then
 docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
fi



if $DOCKER; then
sudo apt update -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" -y
sudo apt update -y
apt-cache policy docker-ce -y
sudo apt install docker-ce -y
#sudo systemctl status docker
sudo chmod 777 /var/run/docker.sock
sudo usermod -aG docker jenkins #optional
fi


if $TRIVY; then
# A Simple and Comprehensive Vulnerability Scanner for Containers and other Artifacts, Suitable for CI.
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy
fi


if $JFROG; then
##Install in Amazon Ubuntu
sudo usermod -aG docker $USER
docker pull docker.bintray.io/jfrog/artifactory-oss:latest
sudo mkdir -p /jfrog/artifactory
sudo chown -R 1030 /jfrog/
docker run --name artifactory -d -p 8081:8081 -p 8082:8082 -v /jfrog/artifactory:/var/opt/jfrog/artifactory docker.bintray.io/jfrog/artifactory-oss:latest
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
