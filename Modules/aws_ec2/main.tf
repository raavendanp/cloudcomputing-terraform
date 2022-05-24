resource "aws_security_group" "labsg" {
  name        = var.sg_name "Web Security Group"
  description = var.sg_description "Enable HTTP access"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Web Security Group"
  }
}

resource "aws_instance" "webserver" {
  ami           = var.ami_id "ami-0022f774911c1d690" 
  instance_type = var.instance_type "t2.micro"
  subnet_id     = var.subnet_id 
  key_name      = var.key_name "CCWEBSERVER"
  vpc_security_group_ids = coalesce(aws_security_group.labsg.id)
  user_data = file("files/userdata.txt")
  tags = {
    Name = "Web Server"
  }
}