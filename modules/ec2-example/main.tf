terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Security Group para instâncias na subnet pública
resource "aws_security_group" "public_instance" {
  name_prefix = "public-instance-"
  vpc_id      = var.vpc_id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "public-instance-sg"
  })
}

# Security Group para instâncias na subnet privada
resource "aws_security_group" "private_instance" {
  name_prefix = "private-instance-"
  vpc_id      = var.vpc_id

  # SSH access from public subnet
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_instance.id]
  }

  # HTTP access from public subnet
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_instance.id]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "private-instance-sg"
  })
}

# Dados da AMI mais recente do Amazon Linux 2
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Instâncias EC2 nas subnets públicas
resource "aws_instance" "public" {
  count = length(var.public_subnet_ids)

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  subnet_id              = var.public_subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.public_instance.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Public Instance ${count.index + 1}</h1>" > /var/www/html/index.html
              EOF

  tags = merge(var.tags, {
    Name = "public-instance-${count.index + 1}"
    Type = "Public"
  })
}

# Instâncias EC2 nas subnets privadas (primeira de cada AZ)
resource "aws_instance" "private" {
  count = length(var.public_subnet_ids) # Uma instância privada por AZ

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_name
  subnet_id              = var.private_subnet_ids[count.index * 2] # Primeira subnet privada de cada AZ
  vpc_security_group_ids = [aws_security_group.private_instance.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Private Instance ${count.index + 1}</h1>" > /var/www/html/index.html
              EOF

  tags = merge(var.tags, {
    Name = "private-instance-${count.index + 1}"
    Type = "Private"
  })
}
