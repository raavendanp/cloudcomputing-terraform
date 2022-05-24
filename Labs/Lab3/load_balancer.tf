
locals {
  db_name = "wordpress"
  db_user = "wpuser"
  db_pass = "wppassword"
  db_host = aws_instance.mysql_server_1a.private_ip
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
###################################################
### LB Resources
###################################################
resource "aws_lb_target_group" "webserver_tg" {
  name        = "TG-WebCMS"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
}
resource "aws_lb" "webserver_lb" {
  name               = "LB-WebCMS"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_webserverlb.id]
  subnets            = [aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1b.id]

  tags = {
    Environment = "LB-WebCMS"
  }
}
resource "aws_lb_listener" "webserver_lb_listener" {
  load_balancer_arn = aws_lb.webserver_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver_tg.arn
  }
}
resource "aws_launch_template" "webserver_lt" {
  name                                 = "WCMS-Template"
  disable_api_termination              = false
  image_id                             = "ami-09d56f8956ab235b3"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  key_name                             = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids               = [aws_security_group.sg_web.id]
  user_data                            = base64encode(data.template_file.webserver_template.rendered)
  tags = {
    Name = "DB-WebServer"
  }
}
resource "aws_autoscaling_group" "webserver_asg" {
  name                      = "AG-WebCM"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1b.id]
  target_group_arns         = [aws_lb_target_group.webserver_tg.arn]
  launch_template {
    id      = aws_launch_template.webserver_lt.id
    version = "$Latest"
  }
}