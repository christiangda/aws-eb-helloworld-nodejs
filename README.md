# Hello World Application using Node.js over AWS Elastic Beanstalk

Deploy a Node.js Application over AWS Beanstalk using Ansible tool.

## Prepare your AWS Account

To run this code, you need an AWS Account and a user with AWS Access Key

## Install requirements

### Ansible

Installing Ansible tool

From fedora
```
sudo dnf install ansible -y

pip install --upgrade --user boto
```

### AWS Command Line Interface (AWS CLI)

Installing the AWS Command Line Interface (AWS CLI)
```
pip install --upgrade --user awscli
```

Configure awscli
```
cd ~
aws Configure
```

### Elastic Beanstalk Command Line Interface (EB CLI)
Install the Elastic Beanstalk Command Line Interface (EB CLI)
```
pip install --upgrade --user awsebcli
```

## Prepare application

### Create Application work Directory
```
mkdir -p ~/DevOps/HelloWorld/{code,deployment}
cd ~/DevOps/HelloWorld/
```
### Prepare Git local and remote repository
```
git init
git remote add --master master origin git@github.com:christiangda/aws-eb-helloworld-python.git
git branch --set-upstream-to=origin/master master
git pull origin master --allow-unrelated-histories
```

### Prepare Elastic Beanstalk environments
```
eb init --region eu-west-1 --platform Python HelloWorld

eb use prod
```
