resource "aws_vpc" "studocu-vpc" {

  cidr_block           = "${lookup(var.cidr_ab, var.env)}.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "studocu-vpc"
  }
}

resource "aws_internet_gateway" "studocu-igw" {

  vpc_id = aws_vpc.studocu-vpc.id

  tags = {
    Name = "studocu-igw"

  }
}
