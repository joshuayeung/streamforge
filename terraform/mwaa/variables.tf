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

variable "tags" {
  description = "Default tags"
  default     = {}
  type        = map(string)
}

variable "vpc_cidr" {
  description = "VPC CIDR for MWAA"
  type        = string
  default     = "10.1.0.0/16"
}

variable "requirements_s3_path" {
  description = "(Optional) The relative path to the requirements.txt file on your Amazon S3 storage bucket. For example, requirements.txt. If a relative path is provided in the request, then requirements_s3_object_version is required."
  type        = string
  default     = "dags/requirements.txt"
}
