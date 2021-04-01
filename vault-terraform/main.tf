/* resource "aws_lb" "vault-alb" {
  name               = "${var.name}-${var.environment}"
  internal           = true
  load_balancer_type = "application"
  security_groups    = ["var.sg[0]"]
  subnets            = ["var.subnets[0]","var.subnets[1]","var.subnets[2]"]

  enable_deletion_protection = true

  tags = {
    Environment = "${var.environment}"
  }
}
*/

#Redirect Action
/*
resource "aws_lb_listener" "vault-redirect-listener" {
  load_balancer_arn = aws_lb.vault-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#Forward Action

resource "aws_lb_listener" "vault-forward-listener" {
  load_balancer_arn = aws_lb.vault-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "${var.ssl_policy}"
  certificate_arn   = "${var.ssl-cert}"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
*/

# Instance Target Group

resource "aws_lb_target_group" "tg" {
  name     = "${var.tg-name}"
  port     = 8200
  protocol = "HTTP"
  path     = "/v1/sys/health"
  vpc_id   = "${var.vpc_id}"
  health_check {
    path = "/v1/sys/health"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 2
    interval = 6
  }
}

#Create launch_configuration
resource "aws_launch_configuration" "asg-lc" {
  name = "${var.lc-name}"
#  name_prefix   = "${var.lc-name}"
  image_id      = "${var.image-id}"
  instance_type = "${var.instance-type}"
  user_data = "${file("install_vault.sh")}"
  key_name = "${var.key-name}"
  security_groups = "${var.security-groups}"
  iam_instance_profile  = "${var.iam-instance-profile}"
  lifecycle {
    create_before_destroy = true
  }
}


#Create ASG

resource "aws_autoscaling_group" "vault-asg" {
  name                      = "${var.asg-name}"
  max_size                  = 3
  min_size                  = 3
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = 3
  force_delete              = false
  target_group_arns         = ["${aws_lb_target_group.tg.arn}"]
  launch_configuration      = "${aws_launch_configuration.asg-lc.name}"
  vpc_zone_identifier       = ["${var.asg-subnets1}","${var.asg-subnets2}","${var.asg-subnets3}"]

  tag {
    key                 = "Name"
    value               = "Prod-vault-asg"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
  depends_on = ["aws_lb_target_group.tg"]
}
