
module "rds_instance" {
  source = "terraform-aws-modules/rds/aws"

  identifier = format(module.naming.result, "rds")

  engine               = "mysql"
  engine_version       = "8.0"
  family               = "mysql8.0" # DB parameter group
  parameter_group_name = format(module.naming.result, "parameter-group")
  major_engine_version = "8.0" # DB option group
  instance_class       = "db.t3.micro"

  db_name                     = var.db_name
  username                    = var.db_username
  manage_master_user_password = false
  password                    = var.db_password
  port                        = 3306

  multi_az               = false
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [module.sg_for_rds.security_group_id]

  create_cloudwatch_log_group = false

  skip_final_snapshot = true
  deletion_protection = false
  allocated_storage   = 20
}
