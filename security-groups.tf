resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "security group for an application load balancer"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "alb-to-ec2-egress" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "TCP"
  security_group_id        = aws_security_group.alb_sg.id
  source_security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group" "ec2_sg" {
  name        = "app_server_sg"
  description = "security group for an EC2 instance"
  vpc_id      = aws_vpc.vpc.id

  # Allow all outing traffic from the EC2 instance.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ec2-from-alb-ingress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "TCP"
  security_group_id        = aws_security_group.ec2_sg.id
  source_security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "ec2-ssh-ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["197.167.30.69/32"]
  security_group_id = aws_security_group.ec2_sg.id
}
