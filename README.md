# StreamForge: Data Pipeline Project
This project, titled **StreamForge**, is a modern data pipeline solution that integrates **Amazon Managed Workflows for Apache Airflow (MWAA)** for batch data ingestion and **Amazon Managed Streaming for Apache Kafka (MSK)** for real-time data streaming.

## Why "StreamForge"?
The name StreamForge is inspired by two key aspects of the project:

- "Stream": Refers to the real-time data streaming capabilities provided by Kafka, which allows continuous ingestion and processing of event data from platforms like Twitter and Reddit.
- "Forge": Represents the powerful automation and orchestration of batch data pipelines using Airflow. Just like a forge is used to create strong and resilient objects, StreamForge builds robust, scalable data pipelines for both batch and streaming data, allowing seamless data flows across various services.

## **Table of Contents**

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Technologies Used](#technologies-used)
4. [Infrastructure Setup](#infrastructure-setup)
   - [Pre-requisites](#pre-requisites)
   - [Setting Up the Environment](#setting-up-the-environment)
5. [Airflow DAGs](#airflow-dags)
6. [Kafka Producers and Consumers](#kafka-producers-and-consumers)
7. [Running the Pipeline](#running-the-pipeline)
8. [Contributing](#contributing)
9. [License](#license)

---

## **Project Overview**

This project implements two key components:
- **Batch Data Ingestion**: Managed by **Airflow (MWAA)** to schedule and automate ETL processes.
- **Real-time Data Streaming**: Handled by **Kafka (MSK)** to stream events from data sources like Twitter and Reddit.

### **Use Cases**:
- **Batch Processing**: Periodically pull data from APIs like **OpenWeatherMap** or **World Bank** and process/store it for analysis.
- **Event Streaming**: Collect real-time streams of data from platforms like **Twitter** and **Reddit**, and process them through Kafka for further insights.

## **Architecture**

- **Amazon MWAA**: Manages the scheduling and orchestration of batch ETL jobs.
- **Amazon MSK**: Facilitates real-time data ingestion using Kafka producers and consumers.
- **AWS S3**: Storage for Airflow DAGs.
- **AWS VPC**: Provides networking isolation and security for MSK and MWAA.
- **Amazon EC2 (Optional)**: You can use EC2 for additional services like custom monitoring or processing Kafka data.

## **Technologies Used**

- **Terraform**: Infrastructure-as-code tool to provision MSK, MWAA, VPC, and other AWS resources.
- **Apache Airflow (MWAA)**: For scheduling and managing DAGs (Directed Acyclic Graphs).
- **Apache Kafka (MSK)**: For real-time event streaming and processing.
- **AWS S3**: For storing DAGs and logs.
- **Python**: For Airflow DAGs, Kafka producers, and consumers.
- **tweepy**: To interact with the Twitter API.
- **praw**: To interact with the Reddit API.

---

## **Infrastructure Setup**

### **Pre-requisites**

1. **AWS Account**: You need an AWS account to provision MWAA and MSK resources.
2. **Terraform**: Install Terraform on your machine to manage infrastructure.
    ```bash
    # Install Terraform (Linux/macOS)
    brew install terraform

    # Install Terraform (Windows)
    choco install terraform
    ```

3. **AWS CLI**: Ensure you have AWS CLI installed and configured with your credentials.
    ```bash
    aws configure
    ```

4. **S3 Bucket**: Create an S3 bucket to store Airflow DAGs (used by MWAA).
    ```bash
    aws s3 mb s3://<your-mwaa-dags-bucket>
    ```

### **Setting Up the Environment**

1. **Clone the Repository**:
    ```bash
    git clone https://github.com/joshuayeung/streamforge.git
    cd streamforge
    ```

2. **Terraform Setup**:
    Navigate to the `terraform/` directory:
    ```bash
    cd terraform/
    terraform init   # Initialize Terraform
    terraform apply  # Deploy the infrastructure
    ```

    This will provision the following resources on AWS:
    - Amazon MSK (Kafka cluster)
    - Amazon MWAA (Airflow environment)
    - S3 bucket for DAGs
    - Security groups, subnets, VPC

    For detailed information on how to set up and manage Terraform with Terraform Cloud as the backend, please refer to the [Terraform Setup Guide](terraform/README.md).

3. **Deploy Airflow DAGs**:
    Once the infrastructure is provisioned, use the provided script to upload DAGs to the MWAA S3 bucket:
    ```bash
    ./scripts/airflow_deploy_dags.sh
    ```

4. **Setup Kafka Topics**:
    Create the necessary Kafka topics for event streaming (Twitter, Reddit, etc.):
    ```bash
    ./scripts/setup_kafka_topics.sh
    ```

---

## **Airflow DAGs**

Airflow DAGs are used to schedule and manage batch data ingestion jobs. The DAGs are automatically synced from the S3 bucket to MWAA.

- **`weather_dag.py`**: Fetches weather data from **OpenWeatherMap** API and processes it.
- **`world_bank_dag.py`**: Fetches economic data from the **World Bank** API.

### **Triggering a DAG**:
DAGs can be triggered manually from the Airflow UI or scheduled to run at specific intervals (e.g., daily).

You can access the MWAA Airflow UI through the URL provided in the Terraform output:
```bash
terraform output mwaa_web_url
```

---

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

---

## **Contributing**

If you would like to contribute to this project, please follow the [contribution guidelines](CONTRIBUTING.md) (if available), or open a Pull Request.

---

## **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Feel free to update the instructions as you refine your project, and let me know if you need to adjust any specifics!
