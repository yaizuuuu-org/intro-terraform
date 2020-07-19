provider "aws" {
  region = "us-east-1"
  version = "~>v2.70.0"
}

resource "aws_vpc" "exmple" {
  cidr_block = "192.168.0.0/16"
}
