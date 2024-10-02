resource "aws_mwaa_environment" "airflow" {
  name = "streamforge-mwaa-env"

  airflow_version      = "2.10.1"
  dag_s3_path          = "dags/"
  source_bucket_arn    = aws_s3_bucket.mwaa_dag_bucket.arn
  execution_role_arn   = aws_iam_role.mwaa_execution_role.arn
  network_configuration {
    security_group_ids = [var.security_group_id]
    subnet_ids         = var.private_subnet_ids
  }
  environment_class = "mw1.small"
}

resource "random_string" "random" {
  length           = 16
  special          = false
  upper            = false
}

resource "aws_s3_bucket" "mwaa_dag_bucket" {
  bucket = "streamforge-mwaa-dag-bucket-${random_string.random.result}"
}

resource "aws_iam_role" "mwaa_execution_role" {
  name = "MWAAExecutionRole-${random_string.random.result}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {
      "Service": "airflow.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }
}
EOF
}


