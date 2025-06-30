resource "aws_db_subnet_group" "db_group" {
  name       = "db-subnet-group"
  subnet_ids = values(aws_subnet.db)[*].id
}
resource "aws_db_instance" "postgres" {
  identifier              = "postgres-db"
  engine                  = "postgres"
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  port                    = var.db_port
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.db_group.name
  vpc_security_group_ids  = [aws_security_group.app_sg.id]
  multi_az                = var.db_multi_az
  storage_encrypted       = true
  backup_retention_period = var.db_backup_retention_period
  skip_final_snapshot     = true
  apply_immediately       = true
}
