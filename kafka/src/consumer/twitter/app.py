from kafka import KafkaConsumer
import json
import re
from collections import Counter
import boto3
import time

# Initialize the S3 client
s3_client = boto3.client('s3')

# S3 bucket and file configuration
S3_BUCKET_NAME = 'your-s3-bucket-name'
S3_FOLDER_NAME = 'twitter_analysis_results/'

# Function to extract hashtags from tweet text
def extract_hashtags(tweet_text):
    return re.findall(r"#(\w+)", tweet_text)

# Function to perform basic analysis
def analyze_tweets(tweets, batch_number):
    hashtag_counter = Counter()
    tweet_count = 0

    for tweet in tweets:
        tweet_count += 1
        hashtags = extract_hashtags(tweet['text']) if 'text' in tweet else []
        hashtag_counter.update(hashtags)

    analysis_result = {
        'total_tweets': tweet_count,
        'top_hashtags': hashtag_counter.most_common(5)
    }

    print(f"Batch {batch_number}: Analyzed {tweet_count} tweets")
    print(f"Top 5 hashtags: {hashtag_counter.most_common(5)}")

    # Save the analysis result to S3
    upload_to_s3(analysis_result, batch_number)

# Function to upload analysis results to S3
def upload_to_s3(data, batch_number):
    timestamp = int(time.time())
    s3_key = f"{S3_FOLDER_NAME}batch_{batch_number}_{timestamp}.json"
    try:
        s3_client.put_object(
            Bucket=S3_BUCKET_NAME,
            Key=s3_key,
            Body=json.dumps(data),
            ContentType='application/json'
        )
        print(f"Analysis result uploaded to S3: s3://{S3_BUCKET_NAME}/{s3_key}")
    except Exception as e:
        print(f"Failed to upload to S3: {e}")

def consume_tweets():
    # Initialize Kafka consumer
    consumer = KafkaConsumer(
        'twitter_topic',
        bootstrap_servers='b-1.streamforgemskcluster2.5d41vc.c4.kafka.us-west-1.amazonaws.com',
        value_deserializer=lambda x: json.loads(x.decode('utf-8')),
        auto_offset_reset='earliest',
        group_id='twitter-consumer-group'
    )

    tweets = []
    batch_number = 1
    try:
        for message in consumer:
            tweet_data = message.value
            tweets.append(tweet_data)

            # You can limit the number of tweets to analyze in batches (e.g., every 100 tweets)
            if len(tweets) >= 100:
                analyze_tweets(tweets, batch_number)
                tweets.clear()
                batch_number += 1

    except Exception as e:
        print(f"Error consuming tweets: {e}")
    finally:
        consumer.close()

if __name__ == "__main__":
    consume_tweets()
