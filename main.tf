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

resource "aws_lambda_function" "resume_lambda" {
  function_name = "np-cloud-resume-lambda"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  role          = "arn:aws:iam::026344247838:role/service-role/np-cloud-resume-lambda-role-8ow26ejy"
  memory_size   = 128
  timeout       = 3
  filename      = "function.zip"

  lifecycle {
    ignore_changes = [filename]
  }
}

resource "aws_cloudfront_distribution" "resume_cloudfront" {
  enabled       = true
  price_class   = "PriceClass_All"
  http_version  = "http2and3"
  is_ipv6_enabled = true
  retain_on_delete = false

  origin {
    domain_name = "np-cloud-resume.s3-website-us-west-1.amazonaws.com"
    origin_id   = "np-cloud-resume.s3-website-us-west-1.amazonaws.com"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "http-only"
      origin_ssl_protocols     = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
      origin_read_timeout      = 30
      origin_keepalive_timeout = 5
    }
  }

  default_cache_behavior {
    target_origin_id       = "np-cloud-resume.s3-website-us-west-1.amazonaws.com"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    default_ttl            = 0
    min_ttl                = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
  }
}
