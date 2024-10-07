output "aws_s3_bucket_name" {
  description = "S3 bucket Name of the MWAA Environment"
  value       = module.mwaa.aws_s3_bucket_name
}

output "mwaa_arn" {
  description = "The ARN of the MWAA Environment"
  value       = module.mwaa.mwaa_arn
}

output "mwaa_role_arn" {
  description = "The ARN of the MWAA Environment"
  value       = module.mwaa.mwaa_role_arn
}

output "mwaa_role_name" {
  description = "IAM role name of the MWAA Environment"
  value       = module.mwaa.mwaa_role_name
}

output "mwaa_security_group_id" {
  description = "The ARN of the MWAA Environment"
  value       = module.mwaa.mwaa_security_group_id
}

output "mwaa_service_role_arn" {
  description = "The Service Role ARN of the Amazon MWAA Environment"
  value       = module.mwaa.mwaa_service_role_arn
}

output "mwaa_status" {
  description = " The status of the Amazon MWAA Environment"
  value       = module.mwaa.mwaa_status
}

output "mwaa_webserver_url" {
  description = "The webserver URL of the MWAA Environment"
  value       = module.mwaa.mwaa_webserver_url
}
