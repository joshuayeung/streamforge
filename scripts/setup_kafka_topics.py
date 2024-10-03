# setup_kafka_topics.py
from kafka import KafkaAdminClient
from kafka.admin import NewTopic

# Configure your Kafka connection
bootstrap_servers = 'your-msk-endpoint:9092'  # Replace with your MSK endpoint

# Define your topics
topics = [
    {'name': 'twitter_topic', 'partitions': 1, 'replication_factor': 1},
    {'name': 'reddit_topic', 'partitions': 1, 'replication_factor': 1}
]

def create_topics():
    admin_client = KafkaAdminClient(bootstrap_servers=bootstrap_servers)

    existing_topics = admin_client.list_topics()
    new_topics = []

    for topic in topics:
        if topic['name'] not in existing_topics:
            new_topics.append(NewTopic(name=topic['name'], num_partitions=topic['partitions'], replication_factor=topic['replication_factor']))
            print(f"Topic '{topic['name']}' does not exist. Creating it...")
        else:
            print(f"Topic '{topic['name']}' already exists.")

    if new_topics:
        admin_client.create_topics(new_topics)
        print(f"Created topics: {[topic['name'] for topic in new_topics]}")
    else:
        print("No new topics created.")

if __name__ == "__main__":
    create_topics()
