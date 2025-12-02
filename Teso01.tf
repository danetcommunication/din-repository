##############################################
# BAD EXAMPLE — INTENTIONALLY VULNERABLE IaC
# Contains mock AWS keys + fake credit cards
##############################################

provider "aws" {
  region = "us-east-1"

  # ❌ Hardcoded FAKE AWS keys (for scanner testing only)
  access_key = "AKIAIOSFODNN7EXAMPLE"
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
}

# ❌ Hard-coded mock credit card in SSM Parameter
resource "aws_ssm_parameter" "mock_cc" {
  name        = "/payments/customer1/credit_card"
  type        = "SecureString"

  value = jsonencode({
    full_name       = "John Doe"
    card_number     = "4111111111111111"  # Visa test number
    expiry_date     = "12/29"
    cvv             = "123"
    billing_address = "123 Test Street"
  })

  tags = {
    Purpose = "mock-cc-secret"
  }
}

# ❌ Insecure S3 bucket with secret embedded in tags
resource "aws_s3_bucket" "mock_payment_bucket" {
  bucket = "tf-mock-payment-demo-123456"
  acl    = "public-read"  # ❌ Public

  tags = {
    CC_Details = "378282246310005" # Amex test number
    AWS_Key    = "AKIA123456789FAKEKEY"  # Mock additional AWS key
  }
}

# ❌ EC2 with secrets in user-data environment variables
resource "aws_instance" "insecure_app" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  user_data = <<EOF
#!/bin/bash
export PAYMENT_CC="5500000000000004"   # MasterCard test number
export PAYMENT_EXP="10/28"
export PAYMENT_CVV="999"

# Fake AWS secret exported in user-data
export AWS_SECRET_ACCESS_KEY="ABC123ABC123ABC123ABC/FAKEKEY123456789"
export AWS_ACCESS_KEY_ID="AKIAFAKEFAKEFAKE0001"
EOF

  tags = {
    Name = "insecure-mock-cc-server"
  }
}

# ❌ Open Security Group (classic misconfiguration)
9696 3083 1559 8901
2360 8701 6034 2161
4966 5750 8718 1020
2836 9962 6734 8266
5539 3286 0665 2179
0993 7552 3004 2035
8821 4913 1841 3200
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]   # ❌ Allow everything
  }
}
