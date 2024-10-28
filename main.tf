provider "aws" {
  region = "us-west-1"
}

resource "aws_s3_bucket" "resume_bucket" {
  bucket = "np-cloud-resume"
}

resource "aws_dynamodb_table" "resume_table" {
  name = "np-cloud-resume-db"
}

resource "aws_apigatewayv2_api" "resume_api" {
  name = "np-cloud-resume-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_credentials = false
    allow_headers     = ["content-type"]
    allow_methods     = ["GET", "OPTIONS", "POST"]
    allow_origins     = [
      "http://np-cloud-resume.s3-website-us-west-1.amazonaws.com",
      "https://djyh4a4rxtaq4.cloudfront.net",
    ]
    expose_headers    = []
    max_age           = 0
  }
}
