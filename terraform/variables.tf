variable "name" {
  description = "Name of MWAA Environment"
  default     = "streamforge"
  type        = string
}

variable "region" {
  description = "region"
  type        = string
  default     = "us-west-1"
}

variable "vpc_id" {
  description = "VPC ID for MSK and MWAA setup"
  type        = string
  default     = "vpc-0a8cf505f26a8ff7c"
}

variable "private_subnet_ids" {
  description = "Private subnets for MSK and MWAA setup"
  type        = list(string)
  default     = ["subnet-052ac469359f3aa90", "subnet-0e4aab7b9b01949f3"]
}

variable "security_group_id" {
  description = "Security Group ID for MSK and MWAA setup"
  type        = string
  default     = "sg-062dcccd7a0367fd9"
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS access key ID"
  type        = string
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS secret access key"
  type        = string
  sensitive   = true
}
