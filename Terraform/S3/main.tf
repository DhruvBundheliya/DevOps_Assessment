terraform {
  backend "s3" {
    key                  = "s3/s3.tfstate"
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name

  tags = merge(local.default_tags, {
    Name = var.bucket_name
  })
}