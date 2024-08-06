





module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/24"

  azs             = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
  private_subnets = ["10.0.0.48/28", "10.0.0.64/28", "10.0.0.80/28"]
  public_subnets  = ["10.0.0.96/28", "10.0.0.112/28", "10.0.0.128/28"]
  database_subnets = ["10.0.0.0/28", "10.0.0.16/28", "10.0.0.32/28"]

  enable_nat_gateway = true

  tags = {
    Environment = "dev"
  }
}


module "db_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "db-sg"
  description = "Security group for RDS database"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     =65535
      protocol    = "tcp"
      description = "All tcp"
      cidr_blocks = "10.10.0.0/16"
    }
  ]
}


module "public_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.vpc.vpc_id


  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8090
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.10.0.0/16"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}