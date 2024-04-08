# config.tf
provider "aws" {
  region  = "ap-east-1"
}

terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket  = "terraform-sp-helloworld"
    key     = "terraform.tfstate"
    region  = "ap-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.69.0"
    }
  }
}