data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "random_string" "random" {
  length  = 16
  special = false
  upper   = false
}

resource "aws_s3_bucket" "mwaa_dag_bucket" {
  bucket = "streamforge-mwaa-dag-bucket-${random_string.random.result}"
}

resource "aws_mwaa_environment" "airflow" {

  name              = "streamforge-mwaa-env-${random_string.random.result}"
  airflow_version   = "2.10.1"
  environment_class = "mw1.small"

  source_bucket_arn = aws_s3_bucket.mwaa_dag_bucket.arn
  dag_s3_path       = "dags"

  network_configuration {
    security_group_ids = [aws_security_group.mwaa_sg.id]
    subnet_ids         = var.private_subnet_ids
  }

  execution_role_arn = aws_iam_role.mwaa_execution_role.arn

  airflow_configuration_options = {
    "core.load_default_connections" = "false"
    "core.load_examples"            = "false"
    "webserver.dag_default_view"    = "tree"
    "webserver.dag_orientation"     = "TB"
    "logging.logging_level"         = "INFO"
  }

  webserver_access_mode = "PUBLIC_ONLY" # Choose the Private network option(PRIVATE_ONLY) if your Apache Airflow UI is only accessed within a corporate network, and you do not require access to public repositories for web server requirements installation

  depends_on = [
    aws_iam_role.mwaa_execution_role,         # Ensure the IAM role is created first
    aws_iam_role_policy.mwaa_execution_policy # Ensure IAM role policy is created first
  ]
}

resource "aws_security_group" "mwaa_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
