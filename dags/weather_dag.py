import pendulum
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.models import Variable
import requests

import json
from datetime import datetime

# Import the helper functions from common.py
from utils.common import get_aws_client, get_s3_bucket_name

# Default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'start_date': pendulum.today('UTC').add(days=-1),  # Use pendulum for the start_date
    'retries': 1,
}

# DAG definition
dag = DAG(
    'weather_data_to_s3',
    default_args=default_args,
    description='Fetch weather data and store it in S3',
    schedule='@daily',
)

# Function to fetch weather data
def fetch_weather_data():
    api_key = Variable.get("OPENWEATHERMAP_API_KEY")  # Fetch OpenWeatherMap API Key from Airflow Variable
    city = Variable.get("CITY_NAME", default_var="London")  # Fetch the city name, default to London
    weather_url = f"http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}"

    response = requests.get(weather_url)
    weather_data = response.json()

    if response.status_code == 200:
        print(f"Weather data for {city} fetched successfully.")
        return weather_data
    else:
        print(f"Failed to fetch weather data: {weather_data}")
        return None

# Function to upload weather data to S3
def upload_to_s3(**context):
    # Get the weather data from the previous task
    weather_data = context['ti'].xcom_pull(task_ids='fetch_weather_data')

    if weather_data:
        # Get the S3 bucket name from Airflow Variables
        s3_bucket_name = get_s3_bucket_name()

        # Create a boto3 S3 client using the credentials from Airflow Variables
        s3_client = get_aws_client('s3')

        # Prepare the file name
        city = Variable.get("CITY_NAME", default_var="London")
        timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
        file_name = f"weather_data/{city}_weather_{timestamp}.json"

        # Upload the weather data to S3
        s3_client.put_object(
            Bucket=s3_bucket_name,
            Key=file_name,
            Body=json.dumps(weather_data),
            ContentType='application/json'
        )

        print(f"Weather data for {city} uploaded to S3 bucket {s3_bucket_name} as {file_name}.")
    else:
        print("No weather data to upload.")

# Task 1: Fetch weather data
fetch_weather_data_task = PythonOperator(
    task_id='fetch_weather_data',
    python_callable=fetch_weather_data,
    dag=dag,
)

# Task 2: Upload weather data to S3
upload_to_s3_task = PythonOperator(
    task_id='upload_to_s3',
    python_callable=upload_to_s3,
    dag=dag,
)

# Task dependencies
fetch_weather_data_task >> upload_to_s3_task
