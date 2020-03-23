terraform {
  backend "s3" {
    bucket = "senrdesign-cit481"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}

