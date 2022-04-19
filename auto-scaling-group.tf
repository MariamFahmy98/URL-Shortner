resource "aws_launch_configuration" "ec2-configuration" {
  name_prefix     = "aws-asg-"
  // An AMI image for the URL shortner server.
  image_id        = "ami-03af0d7dbb5d3e061"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.ec2_key_pair.key_name
  security_groups = ["${aws_security_group.ec2_sg.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = "auto scaling group"
  min_size             = 1
  max_size             = 4
  launch_configuration = aws_launch_configuration.ec2-configuration.name
  vpc_zone_identifier  = [aws_subnet.first_subnet.id, aws_subnet.second_subnet.id]
  health_check_type    = "ELB"

  lifecycle {
    ignore_changes = [load_balancers]
  }

  tag {
    key                 = "name"
    value               = "auto sacling group for ec2 instances"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "ec2-scale-up" {
  name                   = "ec2-scale-up"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_policy" "ec2-scale-down" {
  name                   = "ec2-scale-down"
  scaling_adjustment     = -2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "CPU-high" {
  alarm_name          = "High CPU utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "4"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization for high utilization on hosts"
  alarm_actions     = [aws_autoscaling_policy.ec2-scale-up.arn]
}

resource "aws_cloudwatch_metric_alarm" "CPU-low" {
  alarm_name          = "Low CPU utilization"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "2"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization for low utilization on hosts"
  alarm_actions     = [aws_autoscaling_policy.ec2-scale-down.arn]
}
