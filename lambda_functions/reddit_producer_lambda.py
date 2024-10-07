import praw
import json
import boto3
import os
from kafka import KafkaProducer

def get_reddit_api():
    secrets_client = boto3.client('secretsmanager')
    secret_name = os.environ['REDDIT_SECRET_NAME']
    secret = secrets_client.get_secret_value(SecretId=secret_name)
    reddit_creds = json.loads(secret['SecretString'])

    return praw.Reddit(
        client_id=reddit_creds['client_id'],
        client_secret=reddit_creds['client_secret'],
        user_agent='your_user_agent'
    )

def lambda_handler(event, context):
    reddit = get_reddit_api()
    producer = KafkaProducer(
        bootstrap_servers='your-msk-endpoint:9092',
        value_serializer=lambda v: json.dumps(v).encode('utf-8')
    )
    
    subreddit = reddit.subreddit('all')

    for submission in subreddit.stream.submissions():
        reddit_data = {
            'title': submission.title,
            'score': submission.score,
            'url': submission.url,
            'created_utc': submission.created_utc
        }
        producer.send('reddit-stream', reddit_data)
        print(f'Sent to Kafka: {reddit_data}')

    return {
        'statusCode': 200,
        'body': json.dumps('Started Reddit streaming!')
    }
