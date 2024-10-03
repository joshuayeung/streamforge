from kafka import KafkaConsumer
import json

def consume_tweets():
    consumer = KafkaConsumer(
        'twitter-stream',
        bootstrap_servers='your-msk-endpoint:9092',
        value_deserializer=lambda x: json.loads(x.decode('utf-8')),
        auto_offset_reset='earliest',
        group_id='twitter-group'
    )

    for message in consumer:
        tweet_data = message.value
        print(f'Consumed Tweet: {tweet_data}')  # Process the tweet data

if __name__ == "__main__":
    consume_tweets()
