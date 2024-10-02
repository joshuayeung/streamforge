resource "aws_iam_role_policy" "mwaa_execution_policy" {
  name   = "MWAAExecutionPolicy-${aws_mwaa_environment.airflow.name}"
  role   = aws_iam_role.mwaa_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "airflow:PublishMetrics",
        Resource = "arn:aws:airflow:${var.region}:${data.aws_caller_identity.current.account_id}:environment/${aws_mwaa_environment.airflow.name}"
      },
      {
        Effect = "Deny",
        Action = "s3:ListAllMyBuckets",
        Resource = [
          "${aws_s3_bucket.mwaa_dag_bucket.arn}",
          "${aws_s3_bucket.mwaa_dag_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject*",
          "s3:GetBucket*",
          "s3:List*"
        ],
        Resource = [
          "${aws_s3_bucket.mwaa_dag_bucket.arn}",
          "${aws_s3_bucket.mwaa_dag_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:GetLogRecord",
          "logs:GetLogGroupFields",
          "logs:GetQueryResults"
        ],
        Resource = "arn:aws:logs:${var.region}:${var.aws_account_id}:log-group:airflow-${aws_mwaa_environment.airflow.name}-*"
      },
      {
        Effect = "Allow",
        Action = "logs:DescribeLogGroups",
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = "cloudwatch:PutMetricData",
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "sqs:ChangeMessageVisibility",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ReceiveMessage",
          "sqs:SendMessage"
        ],
        Resource = "arn:aws:sqs:${var.region}:${var.aws_account_id}:airflow-celery-*"
      },
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey*",
          "kms:Encrypt"
        ],
        NotResource = "arn:aws:kms:${var.region}:${var.aws_account_id}:key/*",
        Condition = {
          StringLike = {
            "kms:ViaService" = [
              "sqs.${var.region}.amazonaws.com"
            ]
          }
        }
      }
    ]
  })
}
