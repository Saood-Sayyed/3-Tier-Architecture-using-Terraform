terraform {
  backend "s3" {
    bucket         = "terrabackend001"
    key            = "statefile/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terra"
  }
}