terraform {
  backend "s3" {
    bucket         = "terra-repo-bucket"
    key            = "tf-infra/terraform.tfstate"
    region         = "eu-west-1"
  }

  required_version = ">=0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}