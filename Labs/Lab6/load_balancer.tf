data "template_file" "front_template" {
  template = file("${path.module}/files/front.sh")
  vars = {
  }
}
# data "template_file" "back_template" {
#   template = file("${path.module}/files/webserver_conf.sh")
#   vars = {
#   }
# }
###################################################
### LB Resources Front
###################################################

resource "aws_lb_target_group" "front_tg" {
  name        = "TG-Front"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
}
resource "aws_lb" "front_lb" {
  name               = "LB-Front"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_front_lb.id]
  subnets            = [aws_subnet.public_subnet_1a.id, aws_subnet.public_subnet_1b.id]

  tags = {
    Name = "LB-Front"
  }
}
resource "aws_lb_listener" "front_lb_listener" {
  load_balancer_arn = aws_lb.front_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_tg.arn
  }
}
resource "aws_launch_template" "front_lt" {
  name                                 = "Front-Template"
  disable_api_termination              = false
  image_id                             = "ami-0022f774911c1d690"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  key_name                             = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids               = [aws_security_group.sg_front.id]
  user_data                            = base64encode(data.template_file.front_template.rendered)
  tags = {
    Name = "Front_LT"
  }
}
resource "aws_autoscaling_group" "front_asg" {
  name                      = "AG-Front"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1b.id]
  target_group_arns         = [aws_lb_target_group.front_tg.arn]
  launch_template {
    id      = aws_launch_template.front_lt.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "Front"
    propagate_at_launch = true
  }

}

###################################################
### LB Resources BackEnd
###################################################

resource "aws_lb_target_group" "back_tg" {
  name        = "TG-BackEnd"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
}
resource "aws_lb" "back_lb" {
  name               = "LB-BackEnd"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_back_lb.id]
  subnets            = [aws_subnet.private_subnet_1a.id, aws_subnet.private_subnet_1b.id]

  tags = {
    Name = "LB-Backend"
  }
}
resource "aws_lb_listener" "back_lb_listener" {
  load_balancer_arn = aws_lb.back_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.back_tg.arn
  }
}
resource "aws_launch_template" "back_lt" {
  name                                 = "BackEnd-Template"
  disable_api_termination              = false
  image_id                             = "ami-0022f774911c1d690"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  key_name                             = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids               = [aws_security_group.sg_back.id]
  #user_data                            = base64encode(data.template_file.back_template.rendered)
  tags = {
    Name = "Back_LT"
  }
}
resource "aws_autoscaling_group" "back_asg" {
  name                      = "AG-BackEnd"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.private_subnet_2a.id, aws_subnet.private_subnet_2b.id]
  target_group_arns         = [aws_lb_target_group.back_tg.arn]
  launch_template {
    id      = aws_launch_template.back_lt.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "Back"
    propagate_at_launch = true
  }

}