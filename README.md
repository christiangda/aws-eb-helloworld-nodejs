# aws-eb-helloworld-nodejs

This is a project to show you how to Deploy a Node.js Application like [this](https://github.com/GoogleCloudPlatform/nodejs-getting-started.git) over [AWS Beanstalk](https://aws.amazon.com/elasticbeanstalk/) using [AWS Cloud Formation](https://aws.amazon.com/cloudformation).

## Prerequisites

To run this code, you need:
* An [AWS Account](https://aws.amazon.com) and an [user with AWS Access Key](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)
* Python and Python Pip installed on your local computer

## Install Local Requirements

### AWS Command Line Interface (AWS CLI)

Installing the [AWS Command Line Interface](https://aws.amazon.com/cli)
```
pip install --upgrade --user awscli
```

Configure awscli (iterative mode)
```
cd ~
aws configure
```

### Elastic Beanstalk Command Line Interface (EB CLI)

Install the [Elastic Beanstalk Command Line Interface](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3.html)
```
pip install --upgrade --user awsebcli
```

### Create key pairs for AWS Beanstalk EC2 instances

Creating a [AWS Key Pairs using AWSCLI](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-using-cli.html)
```
aws ec2 create-key-pair \
  --key-name hello-world-app-ec2-key-pair \
  --query 'KeyMaterial' \
  --region eu-west-1 \
  --output text > ~/.ssh/hello-world-app-ec2-key-pair.pem

chmod 400 ~/.ssh/hello-world-app-ec2-key-pair.pem
```

## Create initial stack

This project provide a [deploy.sh](deploy.sh) script to help us deploy our project and environment.

```
./deploy.sh init
```

It use AWS CloudFormation template locate in [deployment/cf-beanstalk.json](deployment/cf-beanstalk.json)
and a config file [deployment/helloworld-conf.json](deployment/helloworld-conf.json) where you can put your own config Parameters

## Destroy stack

This project provide a [deploy.sh](deploy.sh) script to help us destroy our project and environment.

```
./deploy.sh destroy
```

## Deploying changes

you can use [eb cli](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb3-cmd-commands.html) to control  your project.

if you want to changes your project, execute:

```
eb deploy <your environment name>
```

if you want to know the environments in your project, just execute:

```
eb list
```

if you want open your application environment using your default web browser use:

```
eb open
```

if you want to knoe more about [eb cli, click here](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb3-cmd-commands.html)

## References

* [Passing Parameters to CloudFormation Stacks with the AWS CLI and Powershell](https://aws.amazon.com/es/blogs/devops/passing-parameters-to-cloudformation-stacks-with-the-aws-cli-and-powershell/)
* [AWS Elastic Beanstalk --> Supported Platforms](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html#concepts.platforms.nodejs)
* [AWS Elastic Beanstalk --> General Options for All Environments](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elasticbeanstalkhealthreporting)
* [AWS CloudFormation --> Sample Templates](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/sample-templates-services-us-west-2.html#w2ab2c21c48c13c29)
* [Develop, Deploy, and Manage for Scale with Elastic Beanstalk and CloudFormation Series](https://aws.amazon.com/es/blogs/devops/part-1-develop-deploy-and-manage-for-scale-with-elastic-beanstalk-and-cloudformation-series/)
