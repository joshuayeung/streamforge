import os
import json
import boto3
import tweepy
import time
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

def get_twitter_api():
    twitter_secret = get_secret(os.getenv('TWITTER_API_SECRET_ARN'))
    auth = tweepy.OAuthHandler(twitter_secret['api_key'], twitter_secret['api_secret'])
    auth.set_access_token(twitter_secret['access_token'], twitter_secret['access_token_secret'])
    return tweepy.API(auth)

def lambda_handler(event, context):
    producer = get_kafka_producer()
    api = get_twitter_api()

    class StreamListener(tweepy.StreamListener):
        def on_data(self, raw_data):
            tweet = json.loads(raw_data)
            producer.send('twitter_topic', tweet)

    listener = StreamListener()
    stream = tweepy.Stream(auth=api.auth, listener=listener)

    # Limit the streaming time to 100 seconds to avoid Lambda timeout
    start_time = time.time()
    try:
        stream.filter(track=['AWS', 'Data'], languages=['en'], is_async=True)

        # Stop streaming after 100 seconds to ensure completion within Lambda's 120-second timeout
        while time.time() - start_time < 100:
            time.sleep(1)
    finally:
        stream.disconnect()
