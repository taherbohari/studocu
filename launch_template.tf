## get ami ids
data "aws_ami" "amazon-2" {

  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}


resource "aws_launch_template" "studocu-lc" {

  name = "studocu-lc"

  block_device_mappings {

    device_name = "/dev/sda1"
    ebs {
      volume_size = 8
    }
  }

  image_id      = data.aws_ami.amazon-2.id
  instance_type = "t2.micro"
  key_name      = "demo-1"

  vpc_security_group_ids = [aws_security_group.studocu-instance-sg.id]
  user_data              = filebase64("userdata.sh")

  tags = {
    Name = "studocu-instance"
  }
}
