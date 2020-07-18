provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "recent_amazon_linux_2" {
  most_recent = true
  owners = [
    "amazon"
  ]

  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-2.0.????????-x86_64-gp2"
    ]
  }

  filter {
    name = "state"
    values = [
      "available"
    ]
  }
}

resource "null_resource" "foo" {}
resource "null_resource" "bar" {}

//resource "aws_instance" "remove" {
//  ami = data.aws_ami.recent_amazon_linux_2.id
//  instance_type = "t3.micro"
//}

resource "null_resource" "after" {}

module "after" {
  source = "./rename"
}
