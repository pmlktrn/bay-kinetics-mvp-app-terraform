aws_region             = "ap-southeast-1"
environment            = "production"
project                = "secure-infra"
owner                  = "devops-team"

vpc_cidr               = "10.0.0.0/16"
public_subnets         = ["10.0.1.0/24","10.0.2.0/24"]
private_subnets        = ["10.0.10.0/24","10.0.11.0/24"]
db_subnets             = ["10.0.20.0/24","10.0.21.0/24"]
allowed_ssh_cidr       = "YOUR_IP/32"
ssh_key_name           = "your-key-name"
app_instance_type      = "t3.micro"
app_min_size           = 1
app_max_size           = 3
app_desired_capacity   = 2

db_name                = "appdb"
db_username            = "admin"
db_password            = "YourDBPasswordHere"
db_instance_class      = "db.t3.micro"
db_allocated_storage   = 20
db_backup_retention_period = 7
db_multi_az            = true
db_engine_version      = "13.4"
db_port                = 5432
