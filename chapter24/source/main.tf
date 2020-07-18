provider "aws" {
  region = "us-east-1"
}

resource "null_resource" "source" {}
resource "null_resource" "target" {}
