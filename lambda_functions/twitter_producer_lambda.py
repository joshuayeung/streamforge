import tweepy
import json
import boto3
import os
from kafka import KafkaProducer

def get_twitter_api():
    secrets_client = boto3.client('secretsmanager')
    secret_name = os.environ['TWITTER_SECRET_NAME']
    secret = secrets_client.get_secret_value(SecretId=secret_name)
    twitter_creds = json.loads(secret['SecretString'])
    
    auth = tweepy.OAuthHandler(twitter_creds['consumer_key'], twitter_creds['consumer_secret'])
    auth.set_access_token(twitter_creds['access_token'], twitter_creds['access_token_secret'])
    return tweepy.API(auth)

def lambda_handler(event, context):
    api = get_twitter_api()
    producer = KafkaProducer(
        bootstrap_servers='your-msk-endpoint:9092',
        value_serializer=lambda v: json.dumps(v).encode('utf-8')
    )
    
    class StreamListener(tweepy.StreamListener):
        def on_data(self, raw_data):
            tweet = json.loads(raw_data)
            producer.send('twitter-stream', tweet)
            print(f'Sent to Kafka: {tweet}')

        def on_error(self, status_code):
            print(f'Error: {status_code}')
            return True

    listener = StreamListener()
    stream = tweepy.Stream(auth=api.auth, listener=listener)
    stream.filter(track=['AWS', 'data'], languages=['en'], is_async=True)  # Run asynchronously
    return {
        'statusCode': 200,
        'body': json.dumps('Started Twitter streaming!')
    }
