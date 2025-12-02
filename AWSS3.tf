############################################
# BAD EXAMPLE — MISCONFIGURED IaC + SECRETS
############################################

provider "aws" {
  region     = "us-east-1"

  # ❌ Hard-coded AWS access keys (secret exposure)
  access_key = "AKIA123456789BADSECRET"
  secret_key = "super-secret-password-1234"
}

# ❌ Public S3 bucket (misconfiguration)
resource "aws_s3_bucket" "public_bucket" {
  bucket = "my-insecure-bucket-example"

  acl    = "public-read"     # ❌ Makes bucket public

  versioning {
    enabled = false          # ❌ No versioning
  }

  tags = {
    Environment = "prohd"
  }
}

# ❌ Security group open to the world
resource "aws_security_group" "bad_sg" {
  name        = "open-to-world"
  description = "Totally open security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]    # ❌ SSH wide open
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]    # ❌ Allow all outbound
  }
}

# ❌ EC2 instance with user-data leaked secret
resource "aws_instance" "bad_ec2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  user_data = <<EOF
#!/bin/bash
export DB_PASSWORD="P@ssw0rd123"   # ❌ Secret in user-data
EOF

  tags = {
    Name = "insecure-server"
  }
}

# ❌ RDS database with public exposure + plaintext password
resource "aws_db_instance" "bad_rds" {
  identifier           = "insecure-db"
  engine               = ""
  instance_class       = "db.t3.micro"

  username             = "admin"
  password             = "VeryWeakPassword!"  # ❌ Hardcoded secret

  skip_final_snapshot  = true                 # ❌ No backup
  publicly_accessible  = true                 # ❌ Public DB

  allocated_storage    = 20
}
