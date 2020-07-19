resource "aws_vpc" "tfer--vpc-002D-01832429e2bdae399" {
  assign_generated_ipv6_cidr_block = "false"
  cidr_block                       = "10.0.0.0/16"
  enable_classiclink               = "false"
  enable_classiclink_dns_support   = "false"
  enable_dns_hostnames             = "true"
  enable_dns_support               = "true"
  instance_tenancy                 = "default"

  tags = {
    Name = "example"
  }
}

resource "aws_vpc" "tfer--vpc-002D-02cdc7faab824ec52" {
  assign_generated_ipv6_cidr_block = "false"
  cidr_block                       = "192.168.0.0/16"
  enable_classiclink               = "false"
  enable_classiclink_dns_support   = "false"
  enable_dns_hostnames             = "false"
  enable_dns_support               = "true"
  instance_tenancy                 = "default"

  tags = {
    Environment = "Staging"
  }
}

resource "aws_vpc" "tfer--vpc-002D-0d2f6f2516e6608fc" {
  assign_generated_ipv6_cidr_block = "false"
  cidr_block                       = "192.168.0.0/16"
  enable_classiclink               = "false"
  enable_classiclink_dns_support   = "false"
  enable_dns_hostnames             = "false"
  enable_dns_support               = "true"
  instance_tenancy                 = "default"
}

resource "aws_vpc" "tfer--vpc-002D-f6ccf68f" {
  assign_generated_ipv6_cidr_block = "false"
  cidr_block                       = "172.31.0.0/16"
  enable_classiclink               = "false"
  enable_classiclink_dns_support   = "false"
  enable_dns_hostnames             = "true"
  enable_dns_support               = "true"
  instance_tenancy                 = "default"
}
