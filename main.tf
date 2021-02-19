provider "aws" {
  region  = "us-east-1"
}

data "aws_ami" "amazonlinux2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "foo" {
  ami           = data.aws_ami.amazonlinux2.id
  instance_type = "t2.micro"
  
  tags = {
    Name = "Prowler-Instance"
  }
}