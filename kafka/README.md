## **Kafka Producers and Consumers**

Kafka handles real-time event data streaming. Producers collect data from sources like Twitter or Reddit and push it to Kafka topics, while consumers read from these topics for further processing.

### Architecture Overview
- **Producers**: The Twitter and Reddit producers are set up using AWS Lambda functions, which connect to the Twitter and Reddit APIs to ingest data and publish messages to a Kafka topic.
- **Consumers**: The Kafka consumers process the data from the topics, perform analytics (such as extracting the top 5 hashtags), and store the results in an S3 bucket for further visualization.
- **MSK**: AWS Managed Streaming for Apache Kafka (MSK) serves as the central message broker between producers and consumers.
- **S3**: The analytics results from the consumers are stored in an S3 bucket for further data analysis and visualization.
Here’s an updated version of the `README.md` file that reflects the latest changes to your Kafka producers and consumers, especially the move to using AWS Lambda for producers and the data storage process in S3 for consumers.

---

# StreamForge Kafka Producer-Consumer Application

This project is designed to ingest Twitter and Reddit data using Kafka Producers and perform analytics using Kafka Consumers. The application is built using AWS Lambda, AWS Managed Streaming for Kafka (MSK), and S3 for storing analysis results.

## Table of Contents
- [Architecture Overview](#architecture-overview)
- [Technologies Used](#technologies-used)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
  - [1. Deploying SAM Application](#1-deploying-sam-application)
  - [2. Kafka Producers and Consumers](#2-kafka-producers-and-consumers)
- [GitHub Actions](#github-actions)
- [Usage](#usage)
  - [1. Twitter Producer](#1-twitter-producer)
  - [2. Reddit Producer](#2-reddit-producer)
  - [3. Twitter Consumer](#3-twitter-consumer)
- [Results](#results)
- [Troubleshooting](#troubleshooting)

## Architecture Overview

- **Producers**: The Twitter and Reddit producers are set up using AWS Lambda functions, which connect to the Twitter and Reddit APIs to ingest data and publish messages to a Kafka topic.
- **Consumers**: The Kafka consumers process the data from the topics, perform analytics (such as extracting the top 5 hashtags), and store the results in an S3 bucket for further visualization.
- **MSK**: AWS Managed Streaming for Apache Kafka (MSK) serves as the central message broker between producers and consumers.
- **S3**: The analytics results from the consumers are stored in an S3 bucket for further data analysis and visualization.

## Technologies Used

- **AWS Lambda** for the Kafka producers and consumers.
- **AWS Managed Streaming for Apache Kafka (MSK)** for message brokering.
- **Amazon S3** for storing analysis results.
- **Tweepy** for Twitter API integration.
- **Kafka-Python** for producing and consuming messages.
- **AWS SAM** for deploying the Lambda functions.

## Prerequisites

- AWS CLI installed and configured.
- AWS SAM CLI installed.
- Terraform for MSK provisioning.
- Python 3.11 and required dependencies for producers/consumers.
- Kafka Cluster (AWS MSK or other setup).

### 1. Deploying SAM Application

Ensure that the following environment variables are set in your GitHub Actions or your local environment:

- `S3_BUCKET_NAME` (for storing Lambda deployment artifacts)
- `VPC_ID`, `PRIVATE_SUBNET_1`, `PRIVATE_SUBNET_2` (for networking setup)
- `TWITTER_API_SECRET_ARN` (for accessing Twitter API credentials from AWS Secrets Manager)
- `KAFKA_SECRET_ARN` (for accessing Kafka connection details from AWS Secrets Manager)

To deploy the SAM application:

```bash
cd kafka
sam build
sam deploy --guided
```

### 2. Kafka Producers and Consumers

The producers and consumers are stored in the following directories:

- **Twitter Producer**: `src/producer/twitter/`
- **Reddit Producer**: `src/producer/reddit/`
- **Twitter Consumer**: `src/consumer/twitter/`

Each Lambda function uses the respective configuration for MSK and API access.

## GitHub Actions

The deployment process is automated via GitHub Actions. Ensure your repository contains the necessary secrets:

- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
- `S3_BUCKET_NAME`, `VPC_ID`, `PRIVATE_SUBNET_1`, `PRIVATE_SUBNET_2`
- `TWITTER_API_SECRET_ARN`, `KAFKA_SECRET_ARN`

The SAM deployment workflow is defined in `.github/workflows/sam-deploy.yml`.

## Usage

### 1. Twitter Producer

The Twitter producer listens for tweets containing the keywords `AWS` and `Data`. It fetches real-time tweets and sends them to the Kafka topic `twitter_topic`.

### 2. Reddit Producer

The Reddit producer scrapes posts and comments from subreddits related to technology and data, sending them to the Kafka topic `reddit_topic`.

### 3. Twitter Consumer

The Twitter consumer reads messages from the `twitter_topic`, performs analytics to extract the top 5 hashtags, and stores the results in the specified S3 bucket.

To run the consumer manually (local testing):

```bash
cd src/consumer/twitter
python app.py
```

The results are stored in the S3 bucket under the path `twitter-analysis/`.

## Results

The Twitter consumer stores the analysis results in S3 as JSON files. The data can be visualized using tools like Amazon QuickSight or custom visualization solutions.

### Example JSON Output:

```json
{
  "top_hashtags": ["#AWS", "#Data", "#Cloud", "#AI", "#Tech"],
  "total_tweets": 250
}
```

## Troubleshooting

- **Timeout Issues**: The Twitter and Reddit producers are designed to run within the Lambda's execution time limit (120 seconds). If your use case requires longer processing time, consider alternatives like AWS Fargate.
- **Kafka Connectivity**: Ensure your MSK cluster is accessible, and the security groups and networking configurations allow your Lambda functions to connect to the Kafka brokers.
- **Deployment Errors**: Ensure that all the necessary parameters and environment variables are passed during deployment via SAM or GitHub Actions.

---

## **Running the Pipeline**

1. **Batch Ingestion**:
   - Visit the MWAA Web UI to trigger or monitor DAGs like `weather_dag` and `world_bank_dag`.
   
2. **Real-time Streaming**:
   - Start the Kafka producers for Twitter and Reddit. These will send data to Kafka topics in real time.
   - Start Kafka consumers to process the streamed data.
