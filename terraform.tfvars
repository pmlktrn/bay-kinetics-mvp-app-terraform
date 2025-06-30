aws_region             = "ap-southeast-1"
environment            = "development"
project                = "mvp-app"
owner                  = "devOps"

vpc_cidr               = "10.0.0.0/16"
public_subnets         = ["10.0.1.0/24","10.0.2.0/24"]
private_subnets        = ["10.0.10.0/24","10.0.11.0/24"]
db_subnets             = ["10.0.20.0/24","10.0.21.0/24"]
allowed_ssh_cidr       = "110.93.82.27/32"
ssh_key_name           = "mvp-app-dev"
app_instance_type      = "t2.micro"
app_min_size           = 1
app_max_size           = 2
app_desired_capacity   = 1

db_name                = "mvp-app-dev"
db_username            = "admin"
db_password            = "mvpapp123"
db_instance_class      = "db.t3.micro"
db_allocated_storage   = 20
db_backup_retention_period = 7
db_multi_az            = false
db_engine_version      = "13.4"
db_port                = 5432
