terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "development"
      Project     = "mvp-app"
      Owner       = "devops"
    }
  }
}
