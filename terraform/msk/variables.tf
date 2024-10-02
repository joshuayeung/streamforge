variable "vpc_id" {
  description = "VPC ID for the MSK cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the MSK cluster"
  type        = list(string)
}

variable "security_group_id" {
  description = "The ID of the security group to assign to the MSK cluster."
  type        = string
}
