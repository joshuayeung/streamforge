resource "aws_iam_role" "mwaa_execution_role" {
  name = "MWAAExecutionRole-streamforge-mwaa-env-${random_string.random.result}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : ["airflow.amazonaws.com", "airflow-env.amazonaws.com"]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}
