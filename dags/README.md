# DAGs Folder

This folder contains the Directed Acyclic Graphs (DAGs) for Apache Airflow. The DAGs define the workflows and tasks that are executed on a schedule or based on certain events. Each DAG consists of operators and tasks that can be used to perform ETL (Extract, Transform, Load) processes, data ingestion, and data processing workflows.

## Project Overview

This project is focused on building a data pipeline that fetches weather data from the OpenWeatherMap API and uploads it to Amazon S3. The pipeline is orchestrated using Apache Airflow and leverages AWS services like Amazon Managed Workflows for Apache Airflow (MWAA) and Amazon Managed Streaming for Apache Kafka (MSK).

## Structure

- **`common.py`**: This script contains common functions that can be reused across different DAGs. It helps with setting up connections to AWS services like S3 and retrieving secrets from Airflow Variables.
  
- **`weather_dag.py`**: This DAG fetches weather data from the OpenWeatherMap API and uploads the resulting data in JSON format to an Amazon S3 bucket. The API key, city name, AWS credentials, and bucket name are retrieved using Airflow Variables.

- **`airflow_deploy_dags.sh`**: This script is used to deploy DAGs to an Amazon MWAA S3 bucket.

## Airflow Variables

The DAGs in this folder rely on Airflow Variables to manage sensitive information, such as API keys and AWS credentials. Ensure that the following variables are set up correctly in your Airflow environment:

- **`OPENWEATHERMAP_API_KEY`**: The API key for the OpenWeatherMap API.
- **`S3_BUCKET_NAME`**: The name of the S3 bucket where the weather data will be stored.
- **`AWS_ACCESS_KEY_ID`**: AWS Access Key ID.
- **`AWS_SECRET_ACCESS_KEY`**: AWS Secret Access Key.
- **`AWS_REGION`**: The AWS region where services are deployed.
- **`CITY_NAME`**: (Optional) The city for which to fetch weather data. Defaults to "London".

You can set these variables in the Airflow UI under **Admin > Variables**, or using the Airflow CLI:

```bash
airflow variables -s AWS_ACCESS_KEY_ID "your-access-key-id"
airflow variables -s AWS_SECRET_ACCESS_KEY "your-secret-access-key"
airflow variables -s AWS_REGION "your-aws-region"
airflow variables -s OPENWEATHERMAP_API_KEY "your-openweathermap-api-key"
airflow variables -s S3_BUCKET_NAME "your-s3-bucket-name"
airflow variables -s CITY_NAME "your-city-name"
```

## Usage

1. **Weather Data Pipeline**:  
   The `weather_dag.py` is scheduled to run daily (can be configured) and fetches real-time weather data from the OpenWeatherMap API for a specific city. After fetching the data, it uploads the JSON response to a designated S3 bucket.

2. **Deploying DAGs**:  
   If using MWAA (Managed Workflows for Apache Airflow), you can use the `airflow_deploy_dags.sh` script to upload the DAGs to the appropriate S3 bucket linked to your MWAA environment:

   ```bash
   ./airflow_deploy_dags.sh
   ```

## Adding New DAGs

To add a new DAG:

1. Create a new `.py` file in this folder.
2. Define the workflow using Airflow operators and schedule it as per your requirements.
3. If the DAG requires any sensitive information (API keys, credentials, etc.), add the necessary variables in the Airflow environment as explained above.

## Code Structure

Each DAG should follow the basic Airflow structure:
- **Define default arguments** for the DAG, including the start date and retry policy.
- **Define the DAG** itself, setting the schedule interval and other settings.
- **Define the tasks** using Airflow operators.
- **Set up dependencies** between the tasks using the `>>` operator.

Example:

```python
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.utils.dates import days_ago

default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1),
}

with DAG('example_dag', default_args=default_args, schedule_interval='@daily') as dag:

    def task_function():
        print("Task executed")

    example_task = PythonOperator(
        task_id='example_task',
        python_callable=task_function,
    )
```

## Contributing

If you'd like to contribute to the DAGs, please follow the [Contribution Guidelines](../CONTRIBUTING.md) and [Code of Conduct](../CODE_OF_CONDUCT.md).

---

This `README.md` should provide a clear overview of the DAGs folder, guiding developers on how to use the existing DAGs and contribute new ones.
