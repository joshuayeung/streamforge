from datetime import datetime, timedelta
import requests
import json

from airflow.models import Variable
import boto3

# Function to fetch data from OpenWeatherMap API
def fetch_weather_data():
    api_key = 'your_openweathermap_api_key'  # Replace with your API key
    city = 'London'
    url = f'http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}'
    
    response = requests.get(url)
    data = response.json()
    
    # Save the data to a local file or storage system
    with open(f'/path/to/storage/weather_{datetime.now().date()}.json', 'w') as f:
        json.dump(data, f)

def get_aws_client(service_name):
    """
    Function to create a boto3 client using AWS credentials retrieved from Airflow Variables.
    :param service_name: The AWS service for which to create the client (e.g., 's3', 'mwaa', 'msk')
    :return: boto3 client
    """
    # Retrieve AWS credentials from Airflow Variables
    aws_access_key = Variable.get("AWS_ACCESS_KEY_ID")
    aws_secret_key = Variable.get("AWS_SECRET_ACCESS_KEY")
    aws_region = Variable.get("AWS_REGION")

    # Create and return the boto3 client using the credentials
    return boto3.client(
        service_name,
        aws_access_key_id=aws_access_key,
        aws_secret_access_key=aws_secret_key,
        region_name=aws_region
    )

def get_s3_bucket_name():
    """
    Retrieve the S3 bucket name from an Airflow Variable.
    :return: S3 bucket name
    """
    return Variable.get("S3_BUCKET_NAME")

def get_mwaa_env_name():
    """
    Retrieve the MWAA environment name from an Airflow Variable.
    :return: MWAA environment name
    """
    return Variable.get("MWAA_ENV_NAME")
