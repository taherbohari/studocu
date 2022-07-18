## 


## auto scaling group
resource "aws_autoscaling_group" "studocu-asg" {

  name                = "studocu-asg"
  vpc_zone_identifier = [for subnet in aws_subnet.studocu-private-subnet : subnet.id]
  desired_capacity    = var.asg_desired_capacity
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size

  launch_template {
    id      = aws_launch_template.studocu-lc.id
    version = aws_launch_template.studocu-lc.latest_version
  }

  instance_refresh {

    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }

    triggers = ["tag"]
  }

  target_group_arns = [aws_lb_target_group.studocu-alb-tg.arn]

  depends_on = [aws_nat_gateway.studocu-natgw]
}
