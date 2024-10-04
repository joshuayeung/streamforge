import os
import json
import boto3
import praw
from kafka import KafkaProducer

secrets_client = boto3.client('secretsmanager')

def get_secret(secret_name):
    response = secrets_client.get_secret_value(SecretId=secret_name)
    secret = json.loads(response['SecretString'])
    return secret

def get_kafka_producer():
    kafka_secret = get_secret(os.getenv('KAFKA_SECRET_ARN'))
    bootstrap_servers = kafka_secret['bootstrap_servers']
    producer = KafkaProducer(
        bootstrap_servers=bootstrap_servers,
        value_serializer=lambda v: json.dumps(v).encode('utf-8')
    )
    return producer

def get_reddit_api():
    reddit_secret = get_secret(os.getenv('REDDIT_API_SECRET_ARN'))
    return praw.Reddit(client_id=reddit_secret['client_id'],
                       client_secret=reddit_secret['client_secret'],
                       user_agent=reddit_secret['user_agent'])

def lambda_handler(event, context):
    producer = get_kafka_producer()
    reddit = get_reddit_api()

    for submission in reddit.subreddit('dataengineering').hot(limit=10):
        submission_data = {
            'title': submission.title,
            'url': submission.url,
            'score': submission.score
        }
        producer.send('reddit_topic', submission_data)
