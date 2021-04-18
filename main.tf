provider "aws" {
  version = "~> 3.0"
  region  = "us-east-1"
  access_key = "AKIASXGOLKYP7PYTG4H2"
  secret_key = "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"
}


resource "aws_ecr_repository" "apline" {
  name                 = "apline"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "webgoat" {
  name                 = "webgoat"
  image_tag_mutability = "IMMUTABLE"
  encryption_configuration {
    encryption_type = "KMS"
#   kms_key = "ARN"
  }
}

resource "aws_ecr_repository" "kali" {
  name                 = "kali"
  image_tag_mutability = "IMMUTABLE"
}












