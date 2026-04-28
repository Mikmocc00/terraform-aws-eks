# main.tf - File di test per RADON DEFUSE

provider "aws" {
  region     = "us-east-1"
  # 1. ANTI-PATTERN GRAVE: Credenziali hardcoded nel file
  access_key = "AKIAIOSFODNN7EXAMPLE"
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
}

# 2. ANTI-PATTERN GRAVE: Security Group aperto al mondo intero (0.0.0.0/0) sulla porta 22 (SSH)
resource "aws_security_group" "web_sg" {
  name        = "insecure_web_sg"
  description = "Allow SSH and HTTP to the world"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. ANTI-PATTERN: Bucket S3 pubblico e senza crittografia (acl = "public-read")
resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "my-company-public-data-bucket-12345"
  acl    = "public-read" 
}

# 4. ANTI-PATTERN: Istanza EC2 con IP pubblico assegnato di default
resource "aws_instance" "web" {
  ami                         = "ami-0c55b159cbfafe1f0"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.web_sg.name]

  tags = {
    Name = "VulnerableWebServer"
  }
}
