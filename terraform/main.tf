# Include the other files

module "vpc" {
  source = "./vpc"
}

module "mwaa" {
  source             = "./mwaa"
}

module "msk" {
  source             = "./msk"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}
