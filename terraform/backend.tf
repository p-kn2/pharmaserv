terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "pharmaserv-tf-state-prod"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    #dynamodb_table = "pharmaserv-tf-locks"
    #encrypt        = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "Production"
      Project     = "PharmaServ"
      ManagedBy   = "Terraform"
    }
  }
}