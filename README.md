# terraform-aws-aurora-serverless

This repository contains the terraform scripts to create Aurora Serverless Cluster.

### Installing

Install AWS Command Line Interface. See the installing guide [Installing the AWS Command Line Interface \- AWS Command Line Interface](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)

Install tfenv

```
brew install tfenv
```

Install Terraform

```
tfenv install
```

## Getting Started

Initializing

```
make init
```

Running the tests

```
make plan [env=production]
```

Deployment

```
make apply [env=production]
```

## How to edit/view encrypted files

If you want to edit/view encrypted files, decrypt files as follows. See also [aws kms decrypt — AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/reference/kms/decrypt.html).

```
make decrypt
```

After editing files, encrypt secret files as follows. See also [aws kms encrypt — AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/reference/kms/encrypt.html).

```
make encrypt
```
