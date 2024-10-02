# Include the other files


module "mwaa" {
  source             = "./mwaa"
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  security_group_id  = var.security_group_id
}

module "msk" {
  source             = "./msk"
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  security_group_id  = var.security_group_id
}
