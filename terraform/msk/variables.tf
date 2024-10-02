variable "vpc_id" {
  description = "VPC ID for the MSK cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the MSK cluster"
  type        = list(string)
}
