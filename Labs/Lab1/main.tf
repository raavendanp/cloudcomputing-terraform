provider "aws" {
  access_key = "ASIAZJ46FKLD4HTIF4BH"
  secret_key = "jz3zCcSA0A1ow7G5KZj+/aXqMvfKt11/U48pv8p9"
  token      = "FwoGZXIvYXdzEGEaDCClcnjWF0vQOgzvsSLHAVuCUwp5N2MN3sHxWVL4fnSS+agUH2EIERIEw0S4Qxrm9fCO5W2P3XMASwH3eL4bAj2AQug1Gle7e3bDsVogNK6025JrbUoynWk1KeKFTGSImn+59RKJcwxASlvgwLfU/qCqUIxu9HcT1pAR9GBQEWqSGO/za7+zcLFZVaDJL3d59VuDus9AQFquoNGH4w8cAHs7VeBuJNv8aV6t0PX+8xKO9XCHUSyojHVDRAX4kI6pHhtGo0GVpBAwpwFvdJEGc+jheZic2nEok+KllAYyLTwYCnyLqdlV9lS+acLGBDEoj9PxOpKTpw1r0CdCL2sWmxxYg4mbOiV8KfO0qg=="
  region     = "us-east-1"
}

module "vpc" {
  source = "../../Modules/aws_vpc"

}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_security_group" "labsg" {
  name        = "Web Security Group"
  description = "Enable HTTP access"
  vpc_id      = module.vpc.vpc_id

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

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "CCWEBSERVER"
  public_key = file("files/keypair.pem")
}

resource "aws_instance" "webserver" {
  ami                    = "ami-0022f774911c1d690"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.labsg.id]
  user_data              = file("files/userdata.txt")
  tags = {
    Name = "Web Server"
  }
}