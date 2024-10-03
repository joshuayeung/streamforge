data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_mwaa_environment" "airflow" {
  name = "streamforge-mwaa-env-${random_string.random.result}"

  airflow_version    = "2.10.1"
  dag_s3_path        = "dags/"
  source_bucket_arn  = aws_s3_bucket.mwaa_dag_bucket.arn
  execution_role_arn = aws_iam_role.mwaa_execution_role.arn
  network_configuration {
    security_group_ids = [aws_security_group.mwaa_sg.id]
    subnet_ids         = var.private_subnet_ids
  }
  environment_class = "mw1.small"
}

resource "random_string" "random" {
  length  = 16
  special = false
  upper   = false
}

resource "aws_s3_bucket" "mwaa_dag_bucket" {
  bucket = "streamforge-mwaa-dag-bucket-${random_string.random.result}"
}

resource "aws_security_group" "mwaa_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
