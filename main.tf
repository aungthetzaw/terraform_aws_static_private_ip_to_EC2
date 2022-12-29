terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  access_key = "AKIAZYQYVC75AGS6IKZS"
  secret_key = "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"
  region  = "us-east-1"
}

resource "aws_vpc" "atz_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "atz_vpc"
  }
}

resource "aws_subnet" "atz_private_subnet" {
  vpc_id            = aws_vpc.atz_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "atz_prtsn"
  }
}

resource "aws_network_interface" "atz_nint" {
  subnet_id = "${aws_subnet.atz_private_subnet.id}"
  private_ips = ["10.0.2.100"]

  tags = {
    Name = "atz_private_network_interface"
  }
}

resource "aws_instance" "atz_web_instance" {
  ami           = "ami-0533f2ba8a1995cf9"
  instance_type = "t2.nano"

  network_interface {
    network_interface_id = "${aws_network_interface.atz_nint.id}"
    device_index = 0
  }
}
