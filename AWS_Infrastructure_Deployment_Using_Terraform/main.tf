terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "Terraform-EC2"
  }
}

resource "aws_s3_bucket" "storage_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "Terraform-S3"
    Environment = "Dev"
  }
}