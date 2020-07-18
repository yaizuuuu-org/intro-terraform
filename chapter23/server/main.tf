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

resource "aws_instance" "server" {
  ami = data.aws_ami.recent_amazon_linux_2.image_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.server.id]
//  subnet_id = data.terraform_remote_state.network.outputs.subnet_id
  subnet_id = data.aws_subnet.public_staging.id
}

resource "aws_security_group" "server" {
//  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  vpc_id = data.aws_vpc.staging.id
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "yaizuuuu-tfstate"
    key = "network/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_vpc" "staging" {
  tags = {
    Environment = "Staging"
  }
}

data "aws_subnet" "public_staging" {
  tags = {
    Environment = "Staging"
    Accessibility = "Public"
  }
}
