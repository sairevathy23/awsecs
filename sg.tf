resource "aws_security_group" "ecs_sg" {
  name        = "SG for ECS service"
  description = "Allow TLS inbound traffic from ELB to ECS"
  vpc_id      = aws_vpc.ecs-test-vpc.id

  ingress {
    description      = "Allow from ELB"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    security_groups = [aws_security_group.myapp-elb-securitygroup.id]
    
  }
  ingress {
    description      = "Allow from ELB"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]    
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs"
  }
}

resource "aws_security_group" "myapp-elb-securitygroup" {
  vpc_id      = aws_vpc.ecs-test-vpc.id
  name        = "myapp-elb"
  description = "security group for ecs-elb"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "myapp-elb"
  }
}