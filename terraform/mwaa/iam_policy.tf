resource "aws_iam_role_policy" "mwaa_execution_policy" {
  name = "MWAAExecutionPolicy-streamforge-mwaa-env-${random_string.random.result}"
  role = aws_iam_role.mwaa_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "airflow:PublishMetrics",
        Resource = "arn:aws:airflow:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:environment/streamforge-mwaa-env-${random_string.random.result}"
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
        Effect = "Allow", # Ensure MWAA can list and read objects in the S3 bucket
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
        Effect = "Allow", # Ensure MWAA can write logs to CloudWatch
        Action = [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:GetLogRecord",
          "logs:GetLogGroupFields",
          "logs:GetQueryResults"
        ],
        Resource = [
          "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:airflow-streamforge-mwaa-env-${random_string.random.result}-*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:DescribeLogGroups"
        ],
        Resource = [
          "*"
        ]
      },
      {
        Effect   = "Allow", # CloudWatch Metrics permission
        Action   = "cloudwatch:PutMetricData",
        Resource = "*"
      },
      {
        Effect = "Allow", # SQS permissions for Celery task queues
        Action = [
          "sqs:ChangeMessageVisibility",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ReceiveMessage",
          "sqs:SendMessage"
        ],
        Resource = "arn:aws:sqs:${data.aws_region.current.name}:*:airflow-celery-*"
      },
      {
        Effect = "Allow", # KMS permissions for encryption
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey*",
          "kms:Encrypt"
        ],
        NotResource = "arn:aws:kms:*:${data.aws_caller_identity.current.account_id}:key/*",
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

# Create separate policies for each role

# Admin Policy
resource "aws_iam_policy" "mwaa_admin_policy" {
  name        = "MWAAAdminPolicy"
  description = "Policy to allow Admin access to the Apache Airflow Web UI"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "airflow:CreateWebLoginToken",
        Resource = "arn:aws:airflow:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:role/MWAAExecutionPolicy-streamforge-mwaa-env-${random_string.random.result}/Admin"
      }
    ]
  })
}

# Op Policy
resource "aws_iam_policy" "mwaa_op_policy" {
  name        = "MWAAOpPolicy"
  description = "Policy to allow Op access to the Apache Airflow Web UI"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "airflow:CreateWebLoginToken",
        Resource = "arn:aws:airflow:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:role/MWAAExecutionPolicy-streamforge-mwaa-env-${random_string.random.result}/Op"
      }
    ]
  })
}

# User Policy
resource "aws_iam_policy" "mwaa_user_policy" {
  name        = "MWAAUserPolicy"
  description = "Policy to allow User access to the Apache Airflow Web UI"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "airflow:CreateWebLoginToken",
        Resource = "arn:aws:airflow:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:role/MWAAExecutionPolicy-streamforge-mwaa-env-${random_string.random.result}/User"
      }
    ]
  })
}

# Viewer Policy
resource "aws_iam_policy" "mwaa_viewer_policy" {
  name        = "MWAAViewerPolicy"
  description = "Policy to allow Viewer access to the Apache Airflow Web UI"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "airflow:CreateWebLoginToken",
        Resource = "arn:aws:airflow:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:role/MWAAExecutionPolicy-streamforge-mwaa-env-${random_string.random.result}/Viewer"
      }
    ]
  })
}

# Public Policy
resource "aws_iam_policy" "mwaa_public_policy" {
  name        = "MWAAPublicPolicy"
  description = "Policy to allow Public access to the Apache Airflow Web UI"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "airflow:CreateWebLoginToken",
        Resource = "arn:aws:airflow:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:role/MWAAExecutionPolicy-streamforge-mwaa-env-${random_string.random.result}/Public"
      }
    ]
  })
}

# Create separate IAM roles and attach the appropriate policies for each role

# Admin Role
resource "aws_iam_role" "mwaa_admin_role" {
  name = "AdminRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "airflow.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  inline_policy {
    name   = "MWAAAdminPolicy"
    policy = aws_iam_policy.mwaa_admin_policy.policy
  }
}

# Op Role
resource "aws_iam_role" "mwaa_op_role" {
  name = "OpRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "airflow.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  inline_policy {
    name   = "MWAAOpPolicy"
    policy = aws_iam_policy.mwaa_op_policy.policy
  }
}

# User Role
resource "aws_iam_role" "mwaa_user_role" {
  name = "UserRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "airflow.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  inline_policy {
    name   = "MWAAUserPolicy"
    policy = aws_iam_policy.mwaa_user_policy.policy
  }
}

# Viewer Role
resource "aws_iam_role" "mwaa_viewer_role" {
  name = "ViewerRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "airflow.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  inline_policy {
    name   = "MWAAViewerPolicy"
    policy = aws_iam_policy.mwaa_viewer_policy.policy
  }
}

# Public Role
resource "aws_iam_role" "mwaa_public_role" {
  name = "PublicRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "airflow.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  inline_policy {
    name   = "MWAAPublicPolicy"
    policy = aws_iam_policy.mwaa_public_policy.policy
  }
}
