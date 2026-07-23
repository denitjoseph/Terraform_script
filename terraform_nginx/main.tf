terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

#--------------------------------------
# Security Group
#--------------------------------------
resource "aws_security_group" "web_sg" {
  name        = "terraform-web-sg"
  description = "Allow HTTP and SSH"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-Web-SG"
  }
}

#--------------------------------------
# EC2 Instance
#--------------------------------------
resource "aws_instance" "web_server" {

  ami                    = "ami-01a00762f46d584a1"
  instance_type          = "t3.micro"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash

# Update Ubuntu
apt update -y
apt upgrade -y

# Install Nginx
apt install nginx -y

# Start Nginx if not already running
if ! systemctl is-active --quiet nginx; then
    systemctl start nginx
fi

# Enable Nginx on every boot
systemctl enable nginx

# Create a custom webpage
cat <<HTML > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>welcome to Terraform </title>
</head>
<body style="font-family:Arial;text-align:center;margin-top:80px;background:#f4f4f4;">
    <h1>?? Hello from AWS EC2!</h1>
    <h2>Nginx Installed Successfully</h2>
    <p>This website was deployed automatically using <strong>Terraform</strong>.</p>
    <p><strong>Operating System:</strong> Ubuntu</p>
    <p><strong>Region:</strong> Mumbai (ap-south-1)</p>
</body>
</html>
HTML

# Restart Nginx
systemctl restart nginx
EOF

  tags = {
    Name = "Terraform-Ubuntu-Nginx"
  }
}

#--------------------------------------
# Outputs
#--------------------------------------
output "instance_public_ip" {
  description = "Public IP Address"
  value       = aws_instance.web_server.public_ip
}

output "website_url" {
  description = "Website URL"
  value       = "http://${aws_instance.web_server.public_ip}"
}