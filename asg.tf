## 


## auto scaling group
resource "aws_autoscaling_group" "studocu-asg" {

  name                = "studocu-asg"
  vpc_zone_identifier = local.pri-subnet-ids
  desired_capacity    = 2
  min_size            = 2
  max_size            = 5

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

}
