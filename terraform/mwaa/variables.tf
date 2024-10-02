variable "vpc_id" {
  description = "VPC ID for the MWAA"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the MWAA"
  type        = list(string)
}
