provider "aws" {
  region = "us-west-1"
}

resource "aws_s3_bucket" "resume_bucket" {
  bucket = "np-cloud-resume"
}

resource "aws_dynamodb_table" "resume_table" {
  name = "np-cloud-resume-db"
}