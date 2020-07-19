provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "imported" {
  cidr_block = "192.168.0.0/16"
}

resource "aws_security_group" "web_server" {
  name = "web-server"
  description = "Example"
}

resource "aws_security_group_rule" "web_server" {
  from_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.web_server.id
  to_port = 0
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}
