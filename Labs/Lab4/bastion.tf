resource "aws_instance" "bastion" {
  ami                    = "ami-0022f774911c1d690"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet_1a.id
  key_name               = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg_bastion.id]
  tags = {
    Name = " BastionHost"
  }
  root_block_device {
    volume_type = "gp2"
    tags = {
      Name = "bastionS ebs volume"
    }
  }
}
