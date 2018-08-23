region = "us-west-2"

vpc_state_config = {
  bucket = "karakaram-tfstate"
  key    = "env:/development/my-vpc.tfstate"
  region = "ap-northeast-1"
}

name = "my-aurora-serverless"

environment = "development"
