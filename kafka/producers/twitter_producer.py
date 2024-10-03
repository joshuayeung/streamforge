import tweepy
from kafka import KafkaProducer
import json

# Function to authenticate and create a Twitter API client
def get_twitter_api():
    # Replace with your Twitter API credentials
    auth = tweepy.OAuthHandler('consumer_key', 'consumer_secret')
    auth.set_access_token('access_token', 'access_token_secret')
    return tweepy.API(auth)

# Function to send data to Kafka
def send_to_kafka(tweet_data):
    producer = KafkaProducer(
        bootstrap_servers='your-msk-endpoint:9092',  # Replace with your MSK endpoint
        value_serializer=lambda v: json.dumps(v).encode('utf-8')
    )
    producer.send('twitter-stream', tweet_data)  # Ensure this matches your Kafka topic name
    producer.flush()  # Ensure all messages are sent

# Twitter stream listener that pushes data to Kafka
class StreamListener(tweepy.StreamListener):
    def on_data(self, raw_data):
        try:
            tweet = json.loads(raw_data)
            send_to_kafka(tweet)  # Send tweet data to Kafka
            print(f'Sent to Kafka: {tweet}')  # Optional: print the tweet data sent to Kafka
        except Exception as e:
            print(f'Error processing tweet: {e}')

    def on_error(self, status_code):
        print(f'Error: {status_code}')  # Print error codes from the Twitter API
        return True  # Keep stream alive

# Function to start streaming Twitter data
def start_streaming():
    api = get_twitter_api()  # Get the Twitter API client
    listener = StreamListener()  # Create a stream listener
    stream = tweepy.Stream(auth=api.auth, listener=listener)  # Set up the stream
    stream.filter(track=['AWS', 'data'], languages=['en'])  # Track specific keywords

if __name__ == "__main__":
    start_streaming()  # Start streaming when script is executed
