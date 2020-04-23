provider "aws" {
  region  = "us-east-2"
  version = "~> 2.8"
}

resource "aws_s3_bucket" "backend" {
  bucket = "terraform.austinclarke.net"
  acl    = "private"
  force_destroy               = false

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  tags = {
    Name        = "TF Backend"
  }
}

resource "aws_dynamodb_table" "terraform-locks" {
  name           = "terraform-locks"
  hash_key       = "LockID"
  billing_mode   = "PAY_PER_REQUEST"

  lifecycle {
    prevent_destroy = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform-locks"
  }
}
