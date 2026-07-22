output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.web_server.id
}

output "public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.web_server.public_ip
}

output "bucket_name" {
  description = "S3 Bucket Name"
  value       = aws_s3_bucket.storage_bucket.bucket
}