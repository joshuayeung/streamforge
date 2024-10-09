from datetime import datetime, timedelta
import requests
import pandas as pd

from airflow import DAG
from airflow.operators.python import PythonOperator
from utils.common import get_aws_client, get_s3_bucket_name

# AWS S3 Configuration
S3_BUCKET_NAME = get_s3_bucket_name()
S3_KEY_PREFIX = 'world_bank_data/'

# Fetch World Bank Data Function
def fetch_world_bank_data(**kwargs):
    url = 'https://api.worldbank.org/v2/country/ALL/indicator/NY.GDP.MKTP.CD?format=json'

    # Send a GET request to the World Bank API
    response = requests.get(url)
    response.raise_for_status()  # Raise an error for bad responses

    # Extract data from the response

    data = response.json()[1]
    df = pd.DataFrame(data)
    
    # Return the DataFrame for downstream tasks
    return df

# Upload to S3 Function
def upload_to_s3(df, ds):
    output_file = f'/tmp/world_bank_data_{ds}.csv'
    df.to_csv(output_file, index=False)

    s3_client = get_aws_client('s3')
    s3_client.upload_file(output_file, S3_BUCKET_NAME, f"{S3_KEY_PREFIX}world_bank_data_{ds}.csv")
    print(f"World Bank data uploaded to s3://{S3_BUCKET_NAME}/{S3_KEY_PREFIX}world_bank_data_{ds}.csv")

# Define the default arguments
default_args = {
    'owner': 'airflow',
    'start_date': datetime(2024, 10, 9),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Define the DAG
with DAG(
    'world_bank_dag',
    default_args=default_args,
    description='A DAG to fetch and upload World Bank data to S3',
    schedule='@daily',
) as dag:

    # Define the tasks
    fetch_world_bank_data_task = PythonOperator(
        task_id='fetch_world_bank_data',
        python_callable=fetch_world_bank_data,
    )

    upload_to_s3_task = PythonOperator(
        task_id='upload_to_s3',
        python_callable=upload_to_s3,
        op_kwargs={'ds': '{{ ds }}'},  # Pass the execution date as an argument
    )

    # Set the task dependencies
    fetch_world_bank_data_task >> upload_to_s3_task
