resource "aws_iam_role_policy" "mwaa_execution_policy" {
  name   = "MWAAExecutionPolicy-streamforge-mwaa-env-${random_string.random.result}"
  role   = aws_iam_role.mwaa_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "airflow:PublishMetrics",
        Resource = "arn:aws:airflow:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:environment/streamforge-mwaa-env-${random_string.random.result}"
      },
      {
        Effect = "Allow",  # Ensure MWAA can list and read objects in the S3 bucket
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketVersions",
          "s3:GetBucketLocation",
          "s3:GetBucketPolicy"
        ],
        Resource = [
          "${aws_s3_bucket.mwaa_dag_bucket.arn}",
          "${aws_s3_bucket.mwaa_dag_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow",  # Ensure MWAA can write logs to CloudWatch
        Action = [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:GetLogRecord",
          "logs:GetLogGroupFields",
          "logs:GetQueryResults"
        ],
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:airflow-streamforge-mwaa-env-${random_string.random.result}-*"
      },
      {
        Effect = "Allow",  # CloudWatch Metrics permission
        Action = "cloudwatch:PutMetricData",
        Resource = "*"
      },
      {
        Effect = "Allow",  # SQS permissions for Celery task queues
        Action = [
          "sqs:ChangeMessageVisibility",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ReceiveMessage",
          "sqs:SendMessage"
        ],
        Resource = "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:airflow-celery-*"
      },
      {
        Effect = "Allow",  # KMS permissions for encryption
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey*",
          "kms:Encrypt"
        ],
        NotResource = "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/*",
        Condition = {
          StringLike = {
            "kms:ViaService" = [
              "sqs.${data.aws_region.current.name}.amazonaws.com"
            ]
          }
        }
      }
    ]
  })
}
