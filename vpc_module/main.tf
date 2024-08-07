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