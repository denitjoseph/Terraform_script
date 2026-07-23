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
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Terraform DevOps Project</title>

<style>

body{

margin:0;

padding:0;

background:linear-gradient(135deg,#0f172a,#1e3a8a);

font-family:Arial,Helvetica,sans-serif;

display:flex;

justify-content:center;

align-items:center;

height:100vh;

color:white;

}

.container{

background:rgba(255,255,255,0.08);

padding:50px;

border-radius:20px;

width:700px;

text-align:center;

box-shadow:0 10px 30px rgba(0,0,0,0.5);

}

h1{

font-size:42px;

color:#38bdf8;

margin-bottom:10px;

}

h2{

color:#facc15;

margin-bottom:30px;

}

ul{

list-style:none;

padding:0;

font-size:22px;

line-height:2;

}

.badge{

display:inline-block;

margin-top:20px;

padding:12px 25px;

background:#22c55e;

border-radius:30px;

font-size:20px;

font-weight:bold;

}

.footer{

margin-top:35px;

font-size:22px;

}

.footer span{

color:#38bdf8;

font-weight:bold;

}

</style>

</head>

<body>

<div class="container">

<h1>?? Terraform Project</h1>

<h2>AWS EC2 Instance Successfully Provisioned</h2>

<ul>

<li>? Ubuntu Server</li>

<li>? Nginx Installed</li>

<li>? Infrastructure as Code (Terraform)</li>

<li>? AWS Cloud</li>

<li>? Automated Deployment using user_data</li>

</ul>

<div class="badge">

DevOps Project Completed Successfully

</div>

<div class="footer">

Created by <span>Denit Joseph</span><br>

Junior DevOps Engineer

</div>

</div>

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
