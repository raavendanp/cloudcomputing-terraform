resource "aws_db_subnet_group" "mydb_subnetgroup" {
  name        = "db subnet group"
  description = "Subnet group for RDS"
  subnet_ids  = [aws_subnet.private_subnet_2a.id, aws_subnet.private_subnet_2b.id]

  tags = {
    Name = "DB-Subnet Group"
  }
}
resource "aws_db_instance" "mysql_server" {
  allocated_storage      = 20
  engine                 = "mariadb"
  engine_version         = "10.6.7"
  identifier             = "wordpress"
  username               = "wpuser"
  password               = "wppassword"
  instance_class         = "db.t3.micro"
  db_name                = "wordpress"
  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.mydb_subnetgroup.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.sg_mysqlserver.id]
}