variable "aws_region" { description = "AWS region"; type = string; default = "ap-southeast-1" }
variable "environment" { description = "Deployment environment"; type = string }
variable "project" { description = "Project identifier"; type = string }
variable "owner" { description = "Resource owner/team"; type = string }
variable "vpc_cidr" { description = "VPC CIDR block"; type = string; default = "10.0.0.0/16" }
variable "public_subnets" { description = "Public subnet CIDRs"; type = list(string); default = ["10.0.1.0/24", "10.0.2.0/24"] }
variable "private_subnets" { description = "Private subnet CIDRs"; type = list(string); default = ["10.0.10.0/24", "10.0.11.0/24"] }
variable "db_subnets" { description = "DB subnet CIDRs"; type = list(string); default = ["10.0.20.0/24", "10.0.21.0/24"] }
variable "allowed_ssh_cidr" { description = "CIDR for SSH to bastion"; type = string }
variable "ssh_key_name" {
  description = "EC2 SSH key pair"
  type        = string
}

variable "app_port" {
  description = "Application port for security group"
  type        = number
  default     = 443
}
variable "app_instance_type" { description = "EC2 instance type"; type = string; default = "t3.micro" }
variable "app_min_size" { description = "ASG min size"; type = number; default = 1 }
variable "app_max_size" { description = "ASG max size"; type = number; default = 3 }
variable "app_desired_capacity" { description = "ASG desired"; type = number; default = 2 }
variable "db_name" { description = "RDS DB name"; type = string; default = "appdb" }
variable "db_username" { description = "RDS master user"; type = string; default = "admin" }
variable "db_password" { description = "RDS master password"; type = string; sensitive = true }
variable "db_instance_class" { description = "RDS instance class"; type = string; default = "db.t3.micro" }
variable "db_allocated_storage" { description = "RDS storage (GB)"; type = number; default = 20 }
variable "db_backup_retention_period" { description = "RDS backup days"; type = number; default = 7 }
variable "db_multi_az" { description = "Enable RDS Multi-AZ"; type = bool; default = true }
variable "db_engine_version" { description = "RDS engine version"; type = string; default = "13.4" }
variable "db_port" { description = "RDS port"; type = number; default = 5432 }
