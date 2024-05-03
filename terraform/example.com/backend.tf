terraform {
  backend "s3" {
    bucket = "your-s3-bucket-name"
    key    = "ec2/example.com/terraform.tfstate"
    region = "us-east-1"
  }
}