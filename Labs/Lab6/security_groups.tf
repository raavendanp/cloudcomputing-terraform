###################################################
### Security Groups
###################################################
resource "aws_security_group" "sg_front" {
  name        = "SG-FrontEnd"
  description = "Enable SQL Access"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Allow inbound HTTP traffic to servers located in the private subnet"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_front_lb.id]
  }
  ingress {
    description     = "Allow inbound SSH access"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-FrontEnd"
  }
}
resource "aws_security_group" "sg_back" {
  name        = "SG-Web"
  description = "Enable HTTP Access"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "Permit Web Requests"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_front_lb.id]
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
    Name = "SG-Back"
  }
}
resource "aws_security_group" "sg_front_lb" {
  name        = "SG-Front-LB"
  description = "Enable HTTP Access"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Permit Web Requests"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-Web-LB"
  }
}
resource "aws_security_group" "sg_back_lb" {
  name        = "SG-Back-LB"
  description = "Enable HTTP Access"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Permit Web Requests"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-Back-LB"
  }
}
resource "aws_security_group" "sg_bastion" {
  name        = "SG-Bastion"
  description = "Allow ssh traffic"
  vpc_id      = aws_vpc.vpc.id

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