# IAM Role & Profile
resource "aws_iam_role" "ec2_role" {
  name = "${var.project}-${var.environment}-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" } }]
  })
}
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project}-${var.environment}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# Security Groups
resource "aws_security_group" "bastion_sg" {
  name   = "bastion-sg"
  vpc_id = aws_vpc.main.id
  ingress = [{ from_port=22; to_port=22; protocol="tcp"; cidr_blocks=[var.allowed_ssh_cidr] }]
  egress  = [{ from_port=0; to_port=0; protocol="-1"; cidr_blocks=["0.0.0.0/0"] }]
}
resource "aws_security_group" "app_sg" {
  name   = "app-sg"
  vpc_id = aws_vpc.main.id
  ingress = [{ from_port=var.app_port; to_port=var.app_port; protocol="tcp"; security_groups=[aws_security_group.bastion_sg.id] }]
  egress  = [{ from_port=0; to_port=0; protocol="-1"; cidr_blocks=["0.0.0.0/0"] }]
}

# Launch Template & Auto Scaling
resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-lt-"
  image_id      = data.aws_ami.linux.id
  instance_type = var.app_instance_type
  key_name      = var.ssh_key_name
  iam_instance_profile { name = aws_iam_instance_profile.ec2_profile.name }
  network_interfaces = [{ security_groups=[aws_security_group.app_sg.id]; associate_public_ip_address=false }]
  user_data = base64encode("#!/bin/bash\nyum update -y\n")
}
resource "aws_autoscaling_group" "app_asg" {
  name                = "app-asg"
  desired_capacity    = var.app_desired_capacity
  min_size            = var.app_min_size
  max_size            = var.app_max_size
  vpc_zone_identifier = values(aws_subnet.private)[*].id
  launch_template     = { id=aws_launch_template.app_lt.id; version="$Latest" }
  health_check_type   = "EC2"
  health_check_grace_period = 60
}

data "aws_ami" "linux" { owners=["amazon"]; most_recent=true; filter=[{ name="name"; values=["amzn2-ami-hvm-*-x86_64-gp2"] }] }
