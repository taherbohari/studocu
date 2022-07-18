
## target group
resource "aws_lb_target_group" "studocu-alb-tg" {

  name     = "studocu-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.studocu-vpc.id

  tags = {
    Name = "studocu-alb-tg"
  }

  health_check {

    healthy_threshold   = var.healthy_threshold
    interval            = var.health_check_interval
    matcher             = 200
    path                = "/"
    unhealthy_threshold = var.unhealthy_threshold
    port                = 80
  }
}


## application load balancer
resource "aws_lb" "studocu-alb" {

  name               = "studocu-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.studocu-alb-sg.id]
  subnets            = [for subnet in aws_subnet.studocu-public-subnet : subnet.id]

  tags = {
    Name = "studocu-alb"
  }
}

## attach target group to alb
resource "aws_lb_listener" "studocu-alb-listener" {

  load_balancer_arn = aws_lb.studocu-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.studocu-alb-tg.arn
  }
}
