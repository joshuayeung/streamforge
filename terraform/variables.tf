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
