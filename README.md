# Hello World Application using Node.js over AWS Elastic Beanstalk

Deploy a Node.js Application over AWS Beanstalk using Ansible tool.

## Prepare your AWS Account

To run this code, you need an AWS Account and a user with AWS Access Key

## Install Requirements

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

### Create key pairs for AWS Beanstalk EC2 instances

EC2
```
aws ec2 create-key-pair --key-name hello-world-app-ec2-key-pair --query 'KeyMaterial' --region eu-west-1 --output text > ~/.ssh/hello-world-app-ec2-key-pair.pem
chmod 400 ~/.ssh/hello-world-app-ec2-key-pair.pem
```

## Create initial stack

```
aws cloudformation create-stack --stackname startmyinstance  
    --template-body file:///some/local/path/templates/startmyinstance.json
    --parameters file:///some/local/path/params/startmyinstance-parameters.json
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

## Stuff created by this project
* [AWS R53 Public Hosted Zones](http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/AboutHZWorkingWith.html)
* [AWS Elastic Load Balancer](https://aws.amazon.com/elasticloadbalancing/)
* []()

## References
* [Passing Parameters to CloudFormation Stacks with the AWS CLI and Powershell](https://aws.amazon.com/es/blogs/devops/passing-parameters-to-cloudformation-stacks-with-the-aws-cli-and-powershell/)
* [AWS Elastic Beanstalk --> Supported Platforms](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html#concepts.platforms.nodejs)
* [AWS Elastic Beanstalk --> General Options for All Environments](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elasticbeanstalkhealthreporting)
* [AWS CloudFormation --> Sample Templates](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/sample-templates-services-us-west-2.html#w2ab2c21c48c13c29)
* [Develop, Deploy, and Manage for Scale with Elastic Beanstalk and CloudFormation Series](https://aws.amazon.com/es/blogs/devops/part-1-develop-deploy-and-manage-for-scale-with-elastic-beanstalk-and-cloudformation-series/)
