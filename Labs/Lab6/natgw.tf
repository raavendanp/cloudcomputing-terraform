################################################
### Nat Gateway
################################################
resource "aws_eip" "nat_eip_1a" {
  vpc = true
}
resource "aws_eip" "nat_eip_1b" {
  vpc = true
}
resource "aws_nat_gateway" "nat_gateway_1a" {
  subnet_id     = aws_subnet.public_subnet_1a.id
  allocation_id = aws_eip.nat_eip_1a.id
  tags = {
    Name = "Public NAT GW 1a"
  }
  depends_on = [aws_internet_gateway.igw]
}
resource "aws_nat_gateway" "nat_gateway_1b" {
  subnet_id     = aws_subnet.public_subnet_1b.id
  allocation_id = aws_eip.nat_eip_1b.id
  tags = {
    Name = "Public NAT GW 1b"
  }
  depends_on = [aws_internet_gateway.igw]
}
################################################
### Routes
################################################
resource "aws_route" "natgw_rt_1a" {
  route_table_id         = aws_route_table.private_rt_1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1a.id
}
resource "aws_route" "natgw_rt_2a" {
  route_table_id         = aws_route_table.private_rt_2a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1a.id
}
resource "aws_route" "natgw_rt_1b" {
  route_table_id         = aws_route_table.private_rt_1b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1b.id
}
resource "aws_route" "natgw_rt_2b" {
  route_table_id         = aws_route_table.private_rt_2b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1b.id
}