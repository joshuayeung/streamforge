output "environment_arn" {
  value = aws_mwaa_environment.airflow.arn
}

output "mwaa_dag_bucket" {
  value = aws_s3_bucket.mwaa_dag_bucket.id
}
