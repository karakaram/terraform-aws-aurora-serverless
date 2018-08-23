region = "ap-northeast-1"

vpc_state_config = {
  bucket = "karakaram-tfstate"
  key    = "env:/production/my-vpc.tfstate"
  region = "ap-northeast-1"
}

name = "my-aurora-serverless"

environment = "production"
