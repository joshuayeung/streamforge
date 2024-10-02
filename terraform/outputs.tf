output "mwaa_environment_arn" {
  value = module.mwaa.environment_arn # Use the output from the MWAA module
}

output "msk_cluster_arn" {
  value = module.msk.cluster_arn # Use the output from the MSK module
}

output "mwaa_dag_bucket" {
  value = module.mwaa.mwaa_dag_bucket # Use the output from the MWAA module
}
