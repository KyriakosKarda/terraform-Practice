locals {
  common_tags = {
    ManagedBy = "Terraform"
  }
}
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = merge(local.common_tags, {
    Name = "vpc-04-resources"
  })
}


resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/24"

  tags = merge(local.common_tags, {
    Name = "subnet-public"
  })

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(local.common_tags, {
    Name = "IGW-04-resources"
  })
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rtb.id
}