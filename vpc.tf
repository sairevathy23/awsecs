# Internet VPC
resource "aws_vpc" "ecs-test-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "ecs-vpc"
  }
}

#Public Subnets
resource "aws_subnet" "ecs-public-subnet-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2a"

  tags = {
    Name = "ecs-public-1"
  }
}

resource "aws_subnet" "ecs-public-subnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2b"

  tags = {
    Name = "ecs-public-2"
  }
}

#Private Subnets

resource "aws_subnet" "ecs-private-subnet-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-2a"

  tags = {
    Name = "ecs-private-1"
  }
}

resource "aws_subnet" "ecs-private-subnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-2a"

  tags = {
    Name = "ecs-private-2"
  }
}

#IGW for Internet Connection

resource "aws_internet_gateway" "ecs-vpc-igw" {
  vpc_id = aws_vpc.ecs-test-vpc.id
  tags = {
    "name" = "ecs-vpc-igw"
  }
}

#Route table association for IGW

resource "aws_route_table" "ecs-vpc-public" {
  vpc_id = aws_vpc.ecs-test-vpc.id
  route =  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs-vpc-igw.id
  } 

 tags = {
    Name = "ecs-public-r1"
  } 
}

#Route table association

resource "aws_route_table_association" "ecs-public-1-a" {
  subnet_id      = aws_subnet.ecs-public-subnet-1.id
  route_table_id = aws_route_table.ecs-vpc-public.id
}

resource "aws_route_table_association" "ecs-public-2-a" {
  subnet_id      = aws_subnet.ecs-public-subnet-2.id
  route_table_id = aws_route_table.ecs-vpc-public.id
}

