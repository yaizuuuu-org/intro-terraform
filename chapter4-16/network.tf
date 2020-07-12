resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "example"
  }
}

resource "aws_subnet" "public_0" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.example.id
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "public_1" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.example.id
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

// デフォルトのルートテーブルも同じものが作られるが、変更できない、管理できないという理由からそれを使うのはアンチパターン
// 同じ設定であっても自作して適応する
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_0" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public_0.id
}

resource "aws_route_table_association" "public_1" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public_1.id
}

resource "aws_subnet" "private_0" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.65.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.example.id
  cidr_block = "10.0.66.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false
}

resource "aws_route_table" "private_0" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table_association" "private_0" {
  subnet_id = aws_subnet.private_0.id
  route_table_id = aws_route_table.private_0.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_eip" "nat_gateway_0" {
  vpc = true
  depends_on = [aws_internet_gateway.example]
}

resource "aws_eip" "nat_gateway_1" {
  vpc = true
  depends_on = [aws_internet_gateway.example]
}

resource "aws_nat_gateway" "nat_gateway_0" {
  allocation_id = aws_eip.nat_gateway_0.id
  subnet_id = aws_subnet.public_0.id
  depends_on = [aws_internet_gateway.example]
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_1.id
  subnet_id = aws_subnet.public_1.id
  depends_on = [aws_internet_gateway.example]
}

resource "aws_route" "private_0" {
  route_table_id = aws_route_table.private_0.id
  nat_gateway_id = aws_nat_gateway.nat_gateway_0.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_1" {
  route_table_id = aws_route_table.private_1.id
  nat_gateway_id = aws_nat_gateway.nat_gateway_1.id
  destination_cidr_block = "0.0.0.0/0"
}

//resource "aws_security_group" "example" {
//  name = "example"
//  vpc_id = aws_vpc.example.id
//}
//
//resource "aws_security_group_rule" "ingress_example" {
//  from_port = 80
//  protocol = "tcp"
//  security_group_id = aws_security_group.example.id
//  to_port = 80
//  cidr_blocks = ["0.0.0.0/0"]
//  type = "ingress"
//}
//
//resource "aws_security_group_rule" "egress_example" {
//  from_port = 0
//  protocol = "-1"
//  security_group_id = aws_security_group.example.id
//  to_port = 0
//  type = "egress"
//  cidr_blocks = ["0.0.0.0/0"]
//}

module "example_sg" {
  source = "./security_group"
  name = "module_sg"
  vpc_id = aws_vpc.example.id
  port = 80
  cidr_blocks = ["0.0.0.0/0"]
}
