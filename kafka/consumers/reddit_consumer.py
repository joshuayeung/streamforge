from kafka import KafkaConsumer
import json

def consume_reddit():
    consumer = KafkaConsumer(
        'reddit-stream',
        bootstrap_servers='your-msk-endpoint:9092',
        value_deserializer=lambda x: json.loads(x.decode('utf-8')),
        auto_offset_reset='earliest',
        group_id='reddit-group'
    )

    for message in consumer:
        reddit_data = message.value
        print(f'Consumed Reddit Post: {reddit_data}')  # Process the Reddit data

if __name__ == "__main__":
    consume_reddit()
