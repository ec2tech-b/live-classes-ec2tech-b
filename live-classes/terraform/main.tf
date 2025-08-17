terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.8.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-dsdhsdjhsgdjhsgdjsgdsjgdsjdgsjd"
  force_destroy = false

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}