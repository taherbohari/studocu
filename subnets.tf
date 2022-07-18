data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "studocu-public-subnet" {

  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.studocu-vpc.id
  cidr_block              = "${lookup(var.cidr_ab, var.env)}.${0 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "studocu-public-subnet"
  }
}

resource "aws_subnet" "studocu-private-subnet" {

  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.studocu-vpc.id
  cidr_block              = "${lookup(var.cidr_ab, var.env)}.${10 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name = "studocu-private-subnet"
  }
}

## this will be required during asg creation
locals {
  pri-subnet-ids = [
    for i in range(0, length(data.aws_availability_zones.available.names)) : aws_subnet.studocu-private-subnet[i].id
  ]

}

## Nat Gateway
resource "aws_eip" "studocu-nat-eip" {

  vpc = true

  tags = {
    Name = "studocu-nat-eip"
  }
  depends_on = [aws_internet_gateway.studocu-igw]
}

resource "aws_nat_gateway" "studocu-natgw" {

  allocation_id = aws_eip.studocu-nat-eip.id
  subnet_id     = aws_subnet.studocu-public-subnet[0].id

  tags = {
    Name = "studocu-natgw"
  }
  depends_on = [aws_internet_gateway.studocu-igw]
}


## Public Route Table
resource "aws_route_table" "studocu-public-rt" {

  vpc_id = aws_vpc.studocu-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.studocu-igw.id
  }

  tags = {
    Name = "studocu-public-rt"
  }
}

resource "aws_route_table_association" "studocu-pub-rt-association" {

  count = length(aws_subnet.studocu-public-subnet)

  subnet_id      = aws_subnet.studocu-public-subnet[count.index].id
  route_table_id = aws_route_table.studocu-public-rt.id
}

## Private Route Table
resource "aws_route_table" "studocu-private-rt" {

  vpc_id = aws_vpc.studocu-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.studocu-natgw.id
  }

  tags = {
    Name = "studocu-private-rt"
  }
}

resource "aws_route_table_association" "studocu-private-rt-association" {

  count = length(aws_subnet.studocu-private-subnet)

  subnet_id      = aws_subnet.studocu-private-subnet[count.index].id
  route_table_id = aws_route_table.studocu-private-rt.id
}

#https://awstip.com/aws-how-to-use-terraform-to-create-a-subnet-per-availability-zone-8f7236378f93

