# **StreamForge: Data Pipeline Project**

**StreamForge** is a modern data pipeline solution that integrates **Amazon Managed Workflows for Apache Airflow (MWAA)** for batch data ingestion and **Amazon Managed Streaming for Apache Kafka (MSK)** for real-time data streaming.

---

## **Why StreamForge?**

The name **StreamForge** is inspired by two core components of the project:

- **"Stream"**: Refers to the real-time data streaming capabilities provided by Kafka, which allows continuous ingestion and processing of event data from platforms like Twitter and Reddit.
- **"Forge"**: Symbolizes the automation and orchestration of batch data pipelines using Airflow. Similar to a forge building strong objects, StreamForge constructs robust, scalable data pipelines for both batch and streaming data.

---

## **Table of Contents**

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Technologies Used](#technologies-used)
4. [Infrastructure Setup](#infrastructure-setup)
   - [Pre-requisites](#pre-requisites)
   - [Setting Up the Environment](#setting-up-the-environment)
5. [Batch Ingestion with Airflow DAGs](#batch-ingestion-with-airflow-dags)
   - [weather_dag.py Overview](#weather_dagpy-overview)
6. [Kafka Producers and Consumers](#kafka-producers-and-consumers)
   - [Real-time Data Streaming](#real-time-data-streaming)
7. [Running the Pipeline](#running-the-pipeline)
8. [Contributing](#contributing)
9. [License](#license)

---

## **Project Overview**

StreamForge implements two key components:

- **Batch Data Ingestion**: Managed by **Airflow (MWAA)** to schedule and automate ETL processes.
- **Real-time Data Streaming**: Handled by **Kafka (MSK)** to stream events from data sources like **Twitter** and **Reddit**.

### **Use Cases**

- **Batch Processing**: Periodically pull data from APIs like **OpenWeatherMap** or **World Bank** and process/store it for analysis.
- **Event Streaming**: Collect real-time streams of data from platforms like **Twitter** and **Reddit**, process them through Kafka, and generate insights.

---

## **Architecture**

- **Amazon MWAA**: Manages the scheduling and orchestration of batch ETL jobs.
- **Amazon MSK**: Facilitates real-time data ingestion using Kafka producers and consumers.
- **AWS S3**: Storage for Airflow DAGs and Kafka consumer output.
- **AWS VPC**: Provides networking isolation and security for MSK and MWAA.

---

## **Technologies Used**

- **Terraform**: Infrastructure-as-code to provision AWS resources such as MSK, MWAA, and VPC.
- **Apache Airflow (MWAA)**: Schedules and manages DAGs (Directed Acyclic Graphs) for batch processing.
- **Apache Kafka (MSK)**: Real-time event streaming.
- **AWS S3**: Storage for DAGs and Kafka consumer results.
- **Python**: For Airflow DAGs, Kafka producers, and consumers.
- **tweepy**: Interacts with Twitter API.
- **praw**: Interacts with Reddit API.

---

## **Infrastructure Setup**

### **Pre-requisites**

1. **AWS Account**: Required for provisioning MWAA and MSK resources.
2. **Terraform**: Install Terraform to manage your infrastructure.
    ```bash
    # Install Terraform (macOS)
    brew install terraform

    # Install Terraform (Windows)
    choco install terraform
    ```
3. **AWS CLI**: Install and configure AWS CLI with your credentials.
    ```bash
    aws configure
    ```

### **Setting Up the Environment**

1. **Clone the Repository**:
    ```bash
    git clone https://github.com/joshuayeung/streamforge.git
    cd streamforge
    ```

2. **Terraform Setup**:
    To provision the necessary AWS resources like Amazon MSK, MWAA, VPC, and security groups, please refer to the detailed instructions provided in the [Terraform Setup Guide](terraform/README.md) file. It contains comprehensive steps for configuring and running Terraform to set up the infrastructure.

    This provisions the following AWS resources:
    - MSK (Kafka cluster)
    - MWAA (Airflow environment)
    - S3 bucket for Airflow DAGs
    - Networking (Security groups, subnets, VPC)

3. **Deploy Airflow DAGs**:
    Upload the DAGs to the S3 bucket to sync with MWAA:
    ```bash
    ./scripts/airflow_deploy_dags.sh
    ```

4. **Setup Kafka Topics**:
    Create Kafka topics for streaming data from Twitter and Reddit:
    ```bash
    ./scripts/setup_kafka_topics.sh
    ```

---

## **Batch Ingestion with Airflow DAGs**

Airflow DAGs handle batch ingestion by scheduling ETL jobs. These DAGs are stored in an S3 bucket and synchronized to the MWAA environment.

### **weather_dag.py Overview**

The `weather_dag.py` DAG retrieves weather data from the **OpenWeatherMap API** at scheduled intervals, processes the data, and stores it for further analysis. This batch ingestion is particularly useful for data that doesn't require real-time processing.

**Key Components**:

- **API Integration**: Fetches weather data from OpenWeatherMap API.
- **Processing**: Performs transformations on the weather data, such as extracting key metrics like temperature, humidity, and wind speed.
- **Storage**: Saves the processed data into a data lake (e.g., S3 bucket or a database).
- **Scheduling**: The DAG can be set to run at periodic intervals (e.g., daily or hourly).

**DAG Steps**:
1. Fetch weather data via API.
2. Process and clean the data.
3. Store the results in the designated storage service (S3 or database).
4. Optional: Trigger downstream processes like data analysis or visualization.

--- 

## **Kafka Producers and Consumers**

Kafka is used for real-time event data streaming. The producers ingest data from APIs like Twitter and Reddit, while consumers process this data and generate insights.

### **Real-time Data Streaming**

- **Producers**: Kafka producers (Twitter and Reddit) ingest data from their respective APIs and publish it to Kafka topics.
- **Consumers**: Kafka consumers process the data in real-time, performing analytics such as extracting top hashtags from tweets or trending topics from Reddit posts.

Please refer to the detailed instructions provided in the [StreamForge Kafka Producer-Consumer Application](kafka/README.md) . 

---

## **Running the Pipeline**

### **Batch Ingestion**:
1. **Trigger Airflow DAGs**: Visit the MWAA Web UI to manually trigger DAGs like `weather_dag.py` or schedule them to run automatically.
   
2. **Monitor Jobs**: Monitor the status and logs of your DAGs directly from the MWAA UI.

### **Real-time Streaming**:
1. **Start Kafka Producers**: The Twitter and Reddit producers run Lambda functions to stream data into Kafka.
2. **Start Kafka Consumers**: Consumers listen to the Kafka topics and process the data, storing results in S3 for further analysis.

---

## **Contributing**

If you would like to contribute to this project, please follow the [contribution guidelines](CONTRIBUTING.md) (if available), or open a Pull Request.

---

## **License**

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
