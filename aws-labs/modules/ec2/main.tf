# -------------------------------------------
# Security Group
# -------------------------------------------
resource "aws_security_group" "this" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH and HTTP"

  // Setup rules firewall for SG 
  // 1. Traffic inbound (Cho phép SSH (port 22) chỉ từ IP bạn cho phép)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }
  // 2. Cho phép web (port 80) từ mọi nơi (public internet)
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // 3. Cho phép mọi kết nối outbound (ra internet thoải mái)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}

# -------------------------------------------
# Key Pair
# -------------------------------------------
resource "aws_key_pair" "this" {
  key_name   = "${var.project_name}-key"
  public_key = file(var.public_key_path)
  tags       = var.common_tags
}

# -------------------------------------------
# EC2 Instance
# -------------------------------------------
resource "aws_instance" "this" {
  ami                    = var.ami_id                 // image của hệ điều hành 
  instance_type          = var.instance_type          // loại máy aws cung cấp 
  key_name               = aws_key_pair.this.key_name // login to EC2 
  vpc_security_group_ids = [aws_security_group.this.id]
  // scripts chạy lần đầu để auto setup (ở đây: apache + web)
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>${var.project_name} - $(hostname)</h1>" > /var/www/html/index.html
  EOF

  tags = merge(var.common_tags,
    {
      Name = "${var.project_name}-ec2"
  })
}


