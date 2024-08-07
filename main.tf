





module "vpc" {
  source = "./vpc_module"

}

module "security_group" {
  source  = "./security_group_module"
}


module "db_rds" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "wordpress-db"

  engine            = "mysql"
  engine_version    = "8.0.35"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "word_press_db"
  username = "admin"
  password =  "db_sujaan2706@"
  port     = "3306"

  iam_database_authentication_enabled = false

  vpc_security_group_ids = [  module.db_sg.security_group_id]



  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    project       = "wordpressr"
    Environment = "dev"
  }

  # DB subnet group
  create_db_subnet_group = false
  subnet_ids             = module.vpc.database_subnets

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0.35"

  # Database Deletion Protection
  deletion_protection = true


}