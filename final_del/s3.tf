terraform {
  backend "s3" {
    bucket = "cloudartproject"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}

