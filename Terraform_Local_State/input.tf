variable "aws_region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "ami-01a00762f46d584a1"
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "LocalState-EC2-Instance"
}