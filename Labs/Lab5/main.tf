provider "aws" {
  access_key = var.lab_access_key
  secret_key = var.lab_secret_key
  token      = var.lab_token
  region     = var.lab_region
}
module "vpc" {
  source = "../../Modules/aws_vpc"
}
resource "aws_security_group" "sg_web" {
  name        = "SG-Web"
  description = "Enable HTTP Access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Permit Web Requests"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Permit Web Requests"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow inbound SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-Web"
  }
}
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "CCWEBSERVER"
  public_key = file("files/keypair.pem")
}
data "template_file" "webserver_template" {
  template = file("${path.module}/files/webserver_conf.sh")
  vars = {
  }
}
resource "aws_instance" "db_webserver" {
  ami                    = "ami-09d56f8956ab235b3"
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnet.id
  key_name               = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg_web.id]
  user_data              = data.template_file.webserver_template.rendered
  tags = {
    Name = "DB-WebServer"
  }
  root_block_device {
    volume_type = "gp2"
    tags = {
      Name = "DB-WebServer volume"
    }
  }
}