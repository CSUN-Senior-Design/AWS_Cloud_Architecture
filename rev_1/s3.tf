terraform {
  backend "s3" {
    bucket = "petra.bucket.csun"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}

