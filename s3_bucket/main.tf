terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Change to your preferred AWS region
}

# Generates a random lowercase alphanumeric string to ensure unique bucket names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "my_bucket" {
  # Combines the variable name with the random suffix
  bucket = "${var.bucket_name}-${random_string.suffix.result}"

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Optional: Enable private access (Block public access)
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}