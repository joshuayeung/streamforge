#!/bin/bash

# Script to deploy Apache Airflow DAGs to the MWAA S3 bucket
# Make sure AWS CLI is configured properly with access to the MWAA environment

# Define variables
# S3_BUCKET_NAME="your-mwaa-s3-bucket-name"    # Replace with your S3 bucket name
# DAGS_DIR="dags"                              # Directory containing your DAGs
# AWS_REGION="your-aws-region"                 # Replace with your AWS region
# MWAA_ENV_NAME="your-mwaa-env-name"           # Replace with your MWAA environment name

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install AWS CLI and configure credentials."
    exit 1
fi

# Sync DAGs to the S3 bucket's Airflow DAGs folder
echo "Deploying DAGs to the MWAA S3 bucket: s3://${S3_BUCKET_NAME}/dags/"

aws s3 sync $DAGS_DIR s3://$S3_BUCKET_NAME/dags --region $AWS_REGION

if [ $? -eq 0 ]; then
    echo "DAGs successfully deployed to the S3 bucket."
else
    echo "Error: Failed to deploy DAGs to the S3 bucket."
    exit 1
fi

# Optionally, trigger an environment update to refresh the DAGs
echo "Triggering MWAA environment update to refresh the DAGs..."

aws mwaa update-environment --name $MWAA_ENV_NAME --region $AWS_REGION --dag-s3-path "dags/" > /dev/null

if [ $? -eq 0 ]; then
    echo "MWAA environment updated successfully."
else
    echo "Error: Failed to update the MWAA environment."
    exit 1
fi

echo "DAG deployment and environment update completed successfully!"
