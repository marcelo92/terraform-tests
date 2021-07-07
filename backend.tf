terraform {
  required_version = "~> 0.12.30"
  backend "s3" {
  }
}

provider "aws" {
  version = "~> 2.70"
  region  = "us-east-1"
}