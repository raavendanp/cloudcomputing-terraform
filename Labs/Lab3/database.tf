resource "aws_instance" "mysql_server_1a" {
  ami                    = "ami-0022f774911c1d690"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet_1a.id
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