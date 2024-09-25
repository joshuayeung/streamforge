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

- **Producers**:
    - **`twitter_producer.py`**: Streams tweets from Twitter into Kafka.
    - **`reddit_producer.py`**: Streams posts/comments from Reddit into Kafka.

- **Consumers**:
    - **`data_consumer.py`**: Generic consumer that reads from Kafka topics for further processing (e.g., storing data or triggering real-time analytics).

### **Running Kafka Producers**:
To start the Twitter producer, run:
```bash
cd kafka/producers
python3 twitter_producer.py
```

Similarly, for Reddit:
```bash
cd kafka/producers
python3 reddit_producer.py
```

### **Running Kafka Consumers**:
Kafka consumers will read messages from Kafka topics:
```bash
cd kafka/consumers
python3 data_consumer.py
```

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
