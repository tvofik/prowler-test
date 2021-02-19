provider "aws" {
  region  = "us-east-1"
}
# Get Account ID 
data "aws_caller_identity" "current" {}

# data "aws_ami" "amazonlinux2" {
#   most_recent = true
#   owners = ["amazon"]
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm*"]
#   }
# }

# resource "aws_instance" "foo" {
#   ami           = data.aws_ami.amazonlinux2.id
#   instance_type = "t2.micro"
  
#   tags = {
#     Name = "Prowler-Instance"
#   }
# }


resource "aws_iam_role" "prowler_role" {
  name = "ProwlerRole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      },
    ]
  })
}