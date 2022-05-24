################################################
### Subnets
################################################
#Public
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.16.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Public 1 Subnet 1a"
  }
}
resource "aws_subnet" "public_subnet_1b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.16.4.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "Public 1 Subnet 1b"
  }
}
#Private
resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.16.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Private 1 Subnet 1a"
  }
}
resource "aws_subnet" "private_subnet_2a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.16.5.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Private 2 Subnet 1a"
  }
}
resource "aws_subnet" "private_subnet_1b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.16.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"
  tags = {
    Name = "Private 1 Subnet 1b"
  }
}
resource "aws_subnet" "private_subnet_2b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.16.6.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"
  tags = {
    Name = "Private 2 Subnet 1b"
  }
}
################################################
### Route Tables
################################################

# Route table associations for Public Subnets
resource "aws_route_table" "public_rt_1a" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Public Route Table 1 a"
  }

}
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_rt_1a.id
}
resource "aws_route_table_association" "public_1b" {
  subnet_id      = aws_subnet.public_subnet_1b.id
  route_table_id = aws_route_table.public_rt_1a.id
}
# Route table associations for Private Subnets
resource "aws_route_table" "private_rt_1a" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Private Route Table 1 a"
  }
}
resource "aws_route_table" "private_rt_2a" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Private Route Table 2 a"
  }
}
resource "aws_route_table" "private_rt_1b" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Private Route Table 1 b"
  }
}
resource "aws_route_table" "private_rt_2b" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Private Route Table 2 b"
  }
}
resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.private_rt_1a.id
}
resource "aws_route_table_association" "private_1b" {
  subnet_id      = aws_subnet.private_subnet_1b.id
  route_table_id = aws_route_table.private_rt_1b.id
}
resource "aws_route_table_association" "private_2a" {
  subnet_id      = aws_subnet.private_subnet_2a.id
  route_table_id = aws_route_table.private_rt_2a.id
}
resource "aws_route_table_association" "private_2b" {
  subnet_id      = aws_subnet.private_subnet_2b.id
  route_table_id = aws_route_table.private_rt_2b.id
}
