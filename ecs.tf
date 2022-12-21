
# cluster
resource "aws_ecs_cluster" "myecs-cluster1" {
  name = "myecs-cluster1"
}

resource "aws_launch_configuration" "myecs-cluster1-launchconfig" {
  name_prefix          = "myecs-launchconfig"
  image_id             = var.ECS_AMIS[var.AWS_REGION]
  instance_type        = var.ECS_INSTANCE_TYPE
  key_name             = aws_key_pair.mykeypair.key_name
  iam_instance_profile = aws_iam_instance_profile.ecs-ec2-role.id
  security_groups      = [aws_security_group.ecs-securitygroup.id]
  user_data            = "#!/bin/bash\necho 'ECS_CLUSTER=myecs-cluster1' > /etc/ecs/ecs.config\nstart ecs"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs-example-autoscaling" {
  name                 = "myecs-cluster1-autoscaling"
  vpc_zone_identifier  = [aws_subnet.ecs-public-subnet-1.id, aws_subnet.ecs-public-subnet-2.id]
  launch_configuration = aws_launch_configuration.myecs-cluster1-launchconfig.name
  min_size             = 1
  max_size             = 1
  tag {
    key                 = "Name"
    value               = "ecs-ec2-container"
    propagate_at_launch = true
  }
}
