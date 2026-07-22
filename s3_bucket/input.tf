variable "bucket_name" {
  type        = string
  description = "The globally unique name of the S3 bucket"
  default     = "my-unique-terraform-bucket-xyz123-2026" # <-- Change this to something unique
}

variable "environment" {
  type        = string
  description = "Environment tag for the bucket"
  default     = "dev"
}