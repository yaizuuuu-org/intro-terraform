resource "aws_instance" "example" {
  ami = "ami-09d95fab7fff3776c"
  instance_type = "t3.micro"

//  tags = {
//    Name = "example"
//  }

  user_data = <<EOF
    #!/bin/bash
    yum install -y httpd
    systemctl start httpd.service
EOF
}
