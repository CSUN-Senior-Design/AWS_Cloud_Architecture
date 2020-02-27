terraform {
  backend "s3" {
    #put the bucket name
    #my bucket name is storage.solution.s3
    #modify accordingly
    bucket = "storage.solution.s3"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}
