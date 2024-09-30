variable "vpc_id" {
  description = "VPC ID for MSK and MWAA setup"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets for MSK and MWAA setup"
  type        = list(string)
}
