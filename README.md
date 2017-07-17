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

Configure awscli
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

The first time you need to create all your infrastructure as a code, and deploying the first version of our code
```
aws cloudformation create-stack \
  --stack-name HelloWorld \
  --template-body file://./deployment/cf-beanstalk.json \
  --parameters file://./deployment/helloworld-conf.json \
  --capabilities CAPABILITY_NAMED_IAM \
  --disable-rollback \
  --region eu-west-1
```

## Managing deployments

### Prepare Elastic Beanstalk environments

```
eb init --platform node.js --region eu-west-1

eb use production
```

## Stuff created by this project

* [AWS R53 Public Hosted Zones](http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/AboutHZWorkingWith.html)
* [AWS Elastic Load Balancer](https://aws.amazon.com/elasticloadbalancing/)

## References

* [Passing Parameters to CloudFormation Stacks with the AWS CLI and Powershell](https://aws.amazon.com/es/blogs/devops/passing-parameters-to-cloudformation-stacks-with-the-aws-cli-and-powershell/)
* [AWS Elastic Beanstalk --> Supported Platforms](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/concepts.platforms.html#concepts.platforms.nodejs)
* [AWS Elastic Beanstalk --> General Options for All Environments](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html#command-options-general-elasticbeanstalkhealthreporting)
* [AWS CloudFormation --> Sample Templates](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/sample-templates-services-us-west-2.html#w2ab2c21c48c13c29)
* [Develop, Deploy, and Manage for Scale with Elastic Beanstalk and CloudFormation Series](https://aws.amazon.com/es/blogs/devops/part-1-develop-deploy-and-manage-for-scale-with-elastic-beanstalk-and-cloudformation-series/)
