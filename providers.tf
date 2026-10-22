###########################################
############ AWS Provider #################
###########################################

provider "aws" {
  alias  = "principal"
  region = var.aws_region

  assume_role {
    role_arn = var.deploy_role_arn
  }

  default_tags {
    tags = var.common_tags
  }
}

###########################################
#Version definition - Terraform - Providers
###########################################

terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.96.0"
    }
  }
  backend "s3" {}
}
