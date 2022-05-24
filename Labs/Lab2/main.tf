provider "aws" {
  access_key = var.lab_access_key
  secret_key = var.lab_secret_key
  token      = var.lab_token
  region     = var.lab_region
}

locals {
  db_name = "wordpress"
  db_user = "wpuser"
  db_pass = "wppassword"
  db_host = aws_instance.mysql_server.private_ip
}

module "vpc" {
  source = "../../Modules/aws_vpc"

}
###################################################
### Security Groups
###################################################
resource "aws_security_group" "sg_mysqlserver" {
  name        = "SG-MySQLServer"
  description = "Enable SQL Access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow inbound HTTP traffic to servers located in the private subnet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
  ingress {
    description = "Allow inbound HTTPS traffic to servers located in the private subnet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
  ingress {
    description = "Allow DB connection MySQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
  ingress {
    description     = "Allow inbound SSH access"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-MySQLServer"
  }
}
resource "aws_security_group" "sg_web" {
  name        = "SG-Web"
  description = "Enable HTTP Access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Permit Web Requests"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "Allow inbound SSH access"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_bastion.id]
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
resource "aws_security_group" "sg_bastion" {
  name        = "SG-Bastion"
  description = "Allow ssh traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow ssh traffic"
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
    Name = "SG-Bastion"
  }
}
###################################################
### Instances
###################################################

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "CCWEBSERVER"
  public_key = file("files/keypair.pem")
}

data "template_file" "webserver_template" {
  template = file("${path.module}/files/webserver_conf.sh")
  vars = {
    db_name = local.db_name
    db_user = local.db_user
    db_pass = local.db_pass
    db_host = local.db_host
  }
}

resource "aws_instance" "bastion" {
  ami                    = "ami-0022f774911c1d690"
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnet.id
  key_name               = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg_bastion.id]
  tags = {
    Name = " BastionHost"
  }
  root_block_device {
    volume_type = "gp2"
    tags = {
      Name = "bastion ebs volume"
    }
  }
}

resource "aws_instance" "mysql_server" {
  ami                    = "ami-0022f774911c1d690"
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.private_subnet.id
  key_name               = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg_mysqlserver.id]
  user_data              = file("files/mysql_conf.sh")
  tags = {
    Name = " DB-MySQLServer"
  }
  root_block_device {
    volume_type = "gp2"
    tags = {
      Name = "DB-MySQLServervolume"
    }
  }
}

resource "aws_instance" "db_webserver" {
  ami                    = "ami-0022f774911c1d690"
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
