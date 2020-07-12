provider "aws" {
  region = "us-east-1"
}

variable "example_instance_type" {
  default = "t3.micro"
}

locals {
  tags_name = "example"
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

resource "aws_security_group" "example_ec2" {
  name = "example-ec2"

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  //  ami = "ami-09d95fab7fff3776c"
  ami = data.aws_ami.recent_amazon_linux_2.image_id
  instance_type = var.example_instance_type
  vpc_security_group_ids = [aws_security_group.example_ec2.id]

//  user_data = <<EOF
//    #!/bin/bash
//    yum install -y httpd
//    systemctl start httpd.service
//EOF

  user_data = file("./user_data.sh")

  tags = {
    Name = local.tags_name
  }
}

module "web_server" {
  source = "./http_server"
  instance_type = "t3.micro"
}

output "example_instance_id" {
  value = aws_instance.example.id
}

output "example_public_dns" {
  value = aws_instance.example.public_dns
}

output "public_dns" {
  value = module.web_server.public_dns
}